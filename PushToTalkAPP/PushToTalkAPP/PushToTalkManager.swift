//
//  PushToTalkManager.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI
import PushToTalk
import AVFoundation
import Firebase

class PushToTalkManager: NSObject, ObservableObject, PTChannelManagerDelegate, PTChannelRestorationDelegate {
    var channelManager: PTChannelManager?
    var channelUUID: UUID?
    @Published var isTalking: Bool = false
    @Published var isInChannel: Bool = false
    @Published var isInitialized: Bool = false
    @Published var activeSpeaker: String = ""
    let db = Firestore.firestore()
    
    func sendPushNotificationToClient(token: String, activeSpeaker: String) {
        // Replace <The certificate key name>.pem with your certificate key name
        let certificateKey = "PushToTalkApp.pem" //적용됨
        
        // Prepare the JSON payload
        let json: [String: Any] = [
            "activeSpeaker": activeSpeaker
        ]
        
        // Prepare the request
        let urlString = "https://api.sandbox.push.apple.com/3/device/\(token)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("pushtotalk", forHTTPHeaderField: "apns-push-type")
        request.setValue("<The app bundle id>.voip-ptt", forHTTPHeaderField: "apns-topic")
        request.setValue("10", forHTTPHeaderField: "apns-priority")
        request.setValue("0", forHTTPHeaderField: "apns-expiration")
        request.setValue("Bearer \(certificateKey)", forHTTPHeaderField: "Authorization")
        
        // Set HTTP/2 protocol
        request.httpShouldUsePipelining = true
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending push notification: \(error.localizedDescription)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Push notification sent, status code: \(response.statusCode)")
            }
        }.resume()
    }
    
    func updateActiveSpeakerInFirestore(channelId: String, activeSpeaker: String) {
        db.collection("channels").document(channelId)
            .updateData([
                "activeSpeaker": activeSpeaker
            ]) { error in
                if let error = error {
                    print("Error updating active speaker in Firestore: \(error.localizedDescription)")
                } else {
                    print("Active speaker updated in Firestore")
                }
            }
    }
    
    func initialize() {
        requestMicrophoneAccess { granted in
            if granted {
                Task {
                    do {
                        let manager = try await PTChannelManager.channelManager(delegate: self, restorationDelegate: self)
                        DispatchQueue.main.async {
                            self.channelManager = manager
                            self.isInitialized = true
                        }
                    } catch {
                        print("Failed to initialize channel manager: \(error)")
                    }
                }
            } else {
                print("Microphone access denied")
            }
        }
    }
    
    ///오디오 접근권한
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    ///채널 매니저를 만듭니다
    func setupChannelManager() async {
        do {
            let manager = try await PTChannelManager.channelManager(delegate: self, restorationDelegate: self)
            DispatchQueue.main.async {
                self.channelManager = manager
                self.isInitialized = true
            }
        } catch {
            print("Failed to initialize channel manager: \(error)")
            // Handle error as needed
        }
    }
    
    ///채널에 들어갑니다
    func listenToChannelChanges(channelUUID: UUID) {
        db.collection("channels").document(channelUUID.uuidString).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            if let data = document.data() {
                self.isTalking = data["isTalking"] as? Bool ?? false
            }
        }
    }
    
    func joinChannel(channelUUID: UUID) async throws {
        try await setupChannelManager()
        
        guard let channelManager = self.channelManager else {
            throw NSError(domain: "PushToTalkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Channel manager is not initialized"])
        }
        let channelImage = UIImage(named: "ChannelIcon")
        let channelDescriptor = PTChannelDescriptor(name: "Awesome Crew", image: channelImage)
        
        do {
            try await channelManager.requestJoinChannel(channelUUID: channelUUID, descriptor: channelDescriptor)
            try await channelManager.setTransmissionMode(.halfDuplex, channelUUID: channelUUID)
            self.channelUUID = channelUUID
            // Firestore에 채널 참여 상태 저장
            try await db.collection("channels").document(channelUUID.uuidString).setData(["isTalking": false])
            listenToChannelChanges(channelUUID: channelUUID)
            
            // Send push notification to all users in the channel
            let token = "<device_token>"  // Replace with actual device token
            let activeSpeakerName = "Your Active Speaker Name"  // Replace with actual active speaker name
            sendPushNotificationToClient(token: token, activeSpeaker: activeSpeakerName)
        } catch {
            print("Failed to join channel: \(error)")
            throw error
        }
    }
    
    
    ///사용자가 채널에 가입하면, 이 대리자 메서드가 앱이 채널에 가입했음을 나타냄
    func channelManager(_ channelManager: PTChannelManager,
                        didJoinChannel channelUUID: UUID,
                        reason: PTChannelJoinReason) {
        // Process joining the channel
        print("Joined channel with UUID: \(channelUUID)")
    }
    func channelManager(_ channelManager: PTChannelManager,
                        receivedEphemeralPushToken pushToken: Data) {
        // Send the variable length push token to the server
        print("Received push token")
    }
    
    ///채널 가입에 실패했을 때 실행하는 함수
    func channelManager(_ channelManager: PTChannelManager,
                        failedToJoinChannel channelUUID: UUID,
                        error: Error) {
        let error = error as NSError
        
        switch error.code {
        case PTChannelError.channelLimitReached.rawValue:
            print("The user has already joined a channel")
        default:
            break
        }
    }
    
    ///채널을 떠나는 함수
    func deactivateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            print("Audio session deactivated")
        } catch {
            DispatchQueue.main.async {
                print("Failed to deactivate audio session: \(error)")
            }
        }
    }
    func leaveChannel() async {
        guard let channelManager = self.channelManager, let channelUUID = self.channelUUID else {
            DispatchQueue.main.async {
                print("Channel manager or channel UUID is nil")
            }
            return
        }
        
        do {
            try await channelManager.leaveChannel(channelUUID: channelUUID)
            DispatchQueue.main.async {
                self.channelUUID = nil
                //                self.deactivateAudioSession()
                self.db.collection("channels").document(channelUUID.uuidString).delete()
                self.isInChannel = true
                print("Left channel with UUID: \(channelUUID)")
            }
        } catch {
            DispatchQueue.main.async {
                print("Failed to leave channel: \(error)")
            }
        }
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        didLeaveChannel channelUUID: UUID,
                        reason: PTChannelLeaveReason) {
        // Process leaving the channel
        deactivateAudioSession()
        print("Left channel with UUID: \(channelUUID)")
    }
    
    ///앱을 나가거나 장치를 재부팅했을 때 채널을 복원해주는 함수
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        let channelImage = UIImage(named: "ChannelIcon")
        return PTChannelDescriptor(name: "Restored Channel", image: channelImage)
    }
    
    
    //        func getCachedChannelDescriptor(channelUUID: UUID) {
    //            return getCachedChannelDescriptor(channelUUID: UUID())
    //        }
    
    ///채널에 대한 기술자 : 채널 이름 또는 이미지 업데이트
    func updateChannel(_ channelDescriptor: PTChannelDescriptor, channelUUID: UUID) async throws {
        guard let channelManager = self.channelManager else { return }
        try await channelManager.setChannelDescriptor(channelDescriptor, channelUUID: channelUUID)
    }
    
    ///서버와 연결중임을 알게 해주는 함수: 시스템에 업데이트를 제공
    func reportServiceIsReconnecting() async throws {
        guard let channelManager = self.channelManager else { return }
        try await channelManager.setServiceStatus(.connecting, channelUUID: UUID())
    }
    
    func reportServiceIsConnected() async throws {
        guard let channelManager = self.channelManager else { return }
        try await channelManager.setServiceStatus(.ready, channelUUID: UUID())
    }
    
    ///🟢  채널에서 음성 전송을 시작하고 싶을 떄
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .interruptSpokenAudioAndMixWithOthers]
            )
            try audioSession.setActive(true)
            print("오디오 세션 활성화됨")
            //아니 왜 활성화 안됨??? setActive면 활성화되는거아닌가
        } catch {
            print("Failed to configure and activate audio session: \(error)")
        }
    }
    
    func startTransmitting(channelUUID: UUID) {
        configureAudioSession()
        guard let channelManager = channelManager else {
            DispatchQueue.main.async {
                print("Error: channelManager is nil")
            }
            return
        }
        channelManager.requestBeginTransmitting(channelUUID: channelUUID)
        //        db.collection("channels").document(channelUUID.uuidString).updateData(["isTalking": true])
        DispatchQueue.main.async {
            self.isTalking = true
        }
    }
    ///음성 전송을 시작할 수 없을 때 이 함수를 사용
    func channelManager(_ channelManager: PTChannelManager,
                        failedToBeginTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        DispatchQueue.main.async {
            print("The system has another ongoing call that is preventing transmission.")
        }
    }
    
    ///🔴 채널에서 음성 전송을 멈추고 싶을 때
    func stopTalking(channelUUID: UUID) {
        guard let channelManager = channelManager else {
            DispatchQueue.main.async {
                print("Error: channelManager is nil")
            }
            return
        }
        channelManager.stopTransmitting(channelUUID: channelUUID)
        db.collection("channels").document(channelUUID.uuidString).updateData(["isTalking": false])
        DispatchQueue.main.async {
            self.isTalking = false
        }        //        deactivateAudioSession()
    }
    ///음성 전송 중단을 시작할 수 없을 때
    func channelManager(_ channelManager: PTChannelManager,
                        failedToStopTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        DispatchQueue.main.async {
            let error = error as NSError
            
            switch error.code {
            case PTChannelError.transmissionNotFound.rawValue:
                print("The user was not in a transmitting state")
            default:
                break
            }
        }
    }
    
    ///전송 시작 콜백을 받으면, 실행하는 메서드와, 소스를 받으면 오디오 세션을 활성화 함 = 녹음을 시작할 수 있다는 신호
    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didBeginTransmittingFrom source: PTChannelTransmitRequestSource) {
        DispatchQueue.main.async {
            self.isTalking = true
            print("Did begin transmission from: \(source)")
        }
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        didActivate audioSession: AVAudioSession) {
        DispatchQueue.main.async {
            print("Did activate audio session")
        }
    }
    
    
    ///전송 종료를 요청하면 전송 종료와 오디오 세션 비활성화 이벤트 수신
    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didEndTransmittingFrom source: PTChannelTransmitRequestSource) {
        DispatchQueue.main.async {
            self.isTalking = false
            print("Did end transmission from: \(source)")
        }
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        didDeactivate audioSession: AVAudioSession) {
        DispatchQueue.main.async {
            print("Did deactivate audio session")
        }
    }
    
    
    ///서버에서 PTT 알림을 보내면 백그라운드에서 앱이 실행되고, 수신 푸시 Delegate 메서드가 호출됨
    func incomingPushResult(channelManager: PTChannelManager,
                            channelUUID: UUID,
                            pushPayload: [String : Any]) -> PTPushResult {
        
        //채널이 방출하기로 했으면 .leaveChannel메서드를 반환함
        guard let activeSpeaker = pushPayload["activeSpeaker"] as? String else {
            // If no active speaker is set, the only other valid operation
            // is to leave the channel
            return .leaveChannel
        }
        
        // 누가 말했는지 알려면 수신자의 정보를 이렇게 return해줌
        let activeSpeakerImage = Image("globe")
        let participant = PTParticipant(name: activeSpeaker, image: UIImage(named: "globe"))
        return .activeRemoteParticipant(participant)
    }
    
    ///원격 참가자가 말을 마치면, activeRemoteParticipant를 0으로 설정. -> 오디오 세션도 종료됨.
    func stopReceivingAudio() {
        guard let channelManager = channelManager else { return }
        channelManager.setActiveRemoteParticipant(nil, channelUUID: UUID())
    }
    
}
