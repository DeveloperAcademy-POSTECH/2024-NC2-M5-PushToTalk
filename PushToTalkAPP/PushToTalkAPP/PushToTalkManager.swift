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
    func channelManager(_ channelManager: PTChannelManager, didJoinChannel channelUUID: UUID, reason: PTChannelJoinReason) {
        
    }
    
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        return getCachedChannelDescriptor(channelUUID)
    }
    
    //초기화 메서드 필요
    //    init(channelManager: PTChannelManager?, isTalking: Bool, isInitialized: Bool) {
    //        self.channelManager = channelManager
    //        self.isTalking = isTalking
    //        self.isInitialized = isInitialized
    //        super.init()
    //        initialize()
    //    }
    
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
    
    //    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
    //
    //    }
    
    
    func channelManager(_ channelManager: PTChannelManager,
                        didActivate audioSession: AVAudioSession) {
        print("Did activate audio session")
        // Configure your audio session and begin recording
    }
    
    func channelManager(_ channelManager: PTChannelManager, didDeactivate audioSession: AVAudioSession) {
        print("Did Deactivate audio session")
    }
    
    func joinChannel(){
        func channelManager(_ channelManager: PTChannelManager,
                            didJoinChannel channelUUID: UUID,
                            reason: PTChannelJoinReason) {
            // Process joining the channel
            print("Joined channel with UUID: \(channelUUID)")
        }
    }
    
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
    
    func channelManager(_ channelManager: PTChannelManager,
                        failedToBeginTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        let error = error as NSError
        
        switch error.code {
        case PTChannelError.transmissionNotFound.rawValue:
            print("The system has another ongoing call that is preventing transmission.")
        default:
            break
        }
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        didLeaveChannel channelUUID: UUID,
                        reason: PTChannelLeaveReason) {
        // Process leaving the channel
        print("Left channel with UUID: \(channelUUID)")
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didBeginTransmittingFrom source: PTChannelTransmitRequestSource) {
        print("Did begin transmission from: \(source)")
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didEndTransmittingFrom source: PTChannelTransmitRequestSource) {
        print("Did end transmission from: \(source)")
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        receivedEphemeralPushToken pushToken: Data) {
        // Send the variable length push token to the server
        print("Received push token")
    }
    
    func incomingPushResult(channelManager: PTChannelManager,
                            channelUUID: UUID,
                            pushPayload: [String : Any]) -> PTPushResult {
        guard let activeSpeaker = pushPayload["activeSpeaker"] as? String else {
            return .leaveChannel
        }
        let activeSpeakerImage = getActiveSpeakerImage(activeSpeaker)
        let participant = PTParticipant(name: activeSpeaker, image: activeSpeakerImage)
        return .activeRemoteParticipant(participant)
    }
    
    func setupChannelManager() async throws {
        channelManager = try await PTChannelManager.channelManager(delegate: self,
                                                                   restorationDelegate: self)
        DispatchQueue.main.async {
            self.isInitialized = true
        }
    }
    
    func startTalking() {
        // Start talking logic
        isTalking = true
//        channelManager.requestBeginTransmitting(channelUUID: UUID)
    }
    
    func stopTalking() {
        // Stop talking logic
        isTalking = false
//        channelManager.endTransmitting(channelUUID: UUID)
    }
    
    private func getActiveSpeakerImage(_ speaker: String) -> UIImage {
        // Placeholder function to return an image for the active speaker
        return UIImage()
    }
}
