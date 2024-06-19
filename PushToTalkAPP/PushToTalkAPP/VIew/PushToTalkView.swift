//
//  PushToTalkView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/19/24.
//

import SwiftUI
struct PushToTalkView: View {
    @StateObject private var pttManager = PushToTalkManager()
//    @State private var channelId = "channelId"
    @State private var token = "<device_token>"
    @State private var channelUUID = UUID(uuidString: "133D01EA-9D9D-4174-BD3D-5BCB82358334")!  // 같은 UUID를 사용하려면 여기에 원하는 값을 넣으세요
    
    var body: some View {
        VStack {
            if pttManager.isInitialized {
                Button("Join Channel") {
                    Task {
                        do {
                            try await pttManager.joinChannel(channelUUID: channelUUID)
                        } catch {
                            print("Failed to join channel: \(error)")
                        }
                    }
                }
                .padding()
                Button("Leave Channel") {
                    Task {
                        do {
                            try await pttManager.leaveChannel()
                        } catch {
                            print("Failed to join channel: \(error)")
                        }
                    }
                }
                .padding()
                
                Button(pttManager.isTalking ? "Stop Talking" : "Start Talking") {
                    if pttManager.isTalking {
                        pttManager.stopTalking(channelUUID: channelUUID)
                    } else {
                        pttManager.startTransmitting(channelUUID: channelUUID)
                    }
                    pttManager.isTalking.toggle()
                }
                .padding()
                .disabled(!pttManager.isInitialized)
            } else {
                Text("Initializing...")
            }
        }
        .onAppear {
            // Initialize the manager when the view appears
            pttManager.initialize()
        }
    }
}
