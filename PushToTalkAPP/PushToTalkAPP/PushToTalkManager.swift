//
//  PushToTalkManager.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI
import PushToTalk
import AVFoundation

class PushToTalkManager: NSObject, ObservableObject, PTChannelManagerDelegate, PTChannelRestorationDelegate {
    let channelUUID = UUID()
    
    ///채널 매니저를 만듭니다
    func setupChannelManager() async throws {
        channelManager = try await PTChannelManager.channelManager(delegate: self,
                                                                   restorationDelegate: self)
        DispatchQueue.main.async {
            self.isInitialized = true
        }
    }
    
    ///채널에 들어갑니다
    func joinChannel(){
        func channelManager(_ channelManager: PTChannelManager,
                            didJoinChannel channelUUID: UUID,
                            reason: PTChannelJoinReason) {
            // Process joining the channel
            print("Joined channel with UUID: \(channelUUID)")
        }
    }
    
    ///사용자가 채널에 가입하면, 이 대리자 메서드가 앱이 채널에 가입했음을 나타냄
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
    func channelManager(_ channelManager: PTChannelManager,
                        didLeaveChannel channelUUID: UUID,
                        reason: PTChannelLeaveReason) {
        // Process leaving the channel
        print("Left channel with UUID: \(channelUUID)")
    }
    
    ///앱을 나가거나 장치를 재부팅했을 때 채널을 복원해주는 함수
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        return getCachedChannelDescriptor(channelUUID)
    }
    
    ///채널에 대한 기술자 : 채널 이름 또는 이미지 업데이트
    func updateChannel(_ channelDescriptor: PTChannelDescriptor) async throws {
        try await channelManager.setChannelDescriptor(channelDescriptor,
                                                      channelUUID: channelUUID)
    }
    
    ///서버와 연결중임을 알게 해주는 함수: 시스템에 업데이트를 제공
    //    func reportServiceIsReconnecting() async throws {
    //        try await channelManager.setServiceStatus(.connecting, channelUUID: channelUUID)
    //    }
    //
    //    func reportServiceIsConnected() async throws {
    //        try await channelManager.setServiceStatus(.ready, channelUUID: channelUUID)
    //    }
    
    ///🟢  채널에서 음성 전송을 시작하고 싶을 떄
    func startTransmitting() {
        channelManager.requestBeginTransmitting(channelUUID: channelUUID)
    }
    ///음성 전송을 시작할 수 없을 때 이 함수를 사용
    func channelManager(_ channelManager: PTChannelManager,
                        failedToBeginTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        let error = error as NSError
        
        switch error.code {
        case PTChannelError.callIsActive.rawValue:
            print("The system has another ongoing call that is preventing transmission.")
        default:
            break
        }
    }
    
    ///🔴 채널에서 음성 전송을 멈추고 싶을 때
    func stopTalking() {
        // Stop talking logic
        channelManager.stopTransmitting(channelUUID: channelUUID)
    }
    ///음성 전송 중단을 시작할 수 없을 때
    func channelManager(_ channelManager: PTChannelManager,
                        failedToStopTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        let error = error as NSError
        
        switch error.code {
        case PTChannelError.transmissionNotFound.rawValue:
            print("The user was not in a transmitting state")
        default:
            break
        }
    }
    
    ///전송 시작 콜백을 받으면, 실행하는 메서드와, 소스를 받으면 오디오 세션을 활성화 함 = 녹음을 시작할 수 있다는 신호
    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didBeginTransmittingFrom source: PTChannelTransmitRequestSource) {
        print("Did begin transmission from: \(source)")
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        didActivate audioSession: AVAudioSession) {
        print("Did activate audio session")
        // Configure your audio session and begin recording
    }
    
    
    ///전송 종료를 요청하면 전송 종료와 오디오 세션 비활성화 이벤트 수신
    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didEndTransmittingFrom source: PTChannelTransmitRequestSource) {
        print("Did end transmission from: \(source)")
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        didDeactivate audioSession: AVAudioSession) {
        print("Did deactivate audio session")
        // Stop recording and clean up resources
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
        let activeSpeakerImage = getActiveSpeakerImage(activeSpeaker)
        let participant = PTParticipant(name: activeSpeaker, image: activeSpeakerImage)
        return .activeRemoteParticipant(participant)
    }
    
    ///원격 참가자가 말을 마치면, activeRemoteParticipant를 0으로 설정. -> 오디오 세션도 종료됨.
    func stopReceivingAudio() {
        channelManager.setActiveRemoteParticipant(nil, channelUUID: channelUUID)
    }

    
    
    
    var channelManager: PTChannelManager!
    @Published var isTalking: Bool = false
    @Published var isInitialized: Bool = false
    
    override init() {
        super.init()
        initialize()
    }
    
    func initialize() {
        Task {
            try await setupChannelManager()
        }
    }
}
