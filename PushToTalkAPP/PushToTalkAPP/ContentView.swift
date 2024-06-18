//
//  ContentView2.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI
import PushToTalk
import AVFoundation

class ChannelClass {
    var channelUUID = UUID()
    var name = ""
    var isActivating: Bool = false
}


struct ContentView: View {
    @StateObject private var pushToTalkManager = PushToTalkManager()
    var channelUUID = UUID()
    
    var body: some View {
        VStack {
            Text("PushToTalk")
                .font(.largeTitle)
            
            Spacer()
            
            Button {
                pushToTalkManager.joinChannel()
                checkfont()
            } label: {
                Text("join channel")
            }
            
            
            Button(action: {
                if pushToTalkManager.isTalking {
                    pushToTalkManager.stopTalking()
                } else {
                    pushToTalkManager.startTalking()
                }
            }) {
                Image(systemName: pushToTalkManager.isTalking ? "mic.slash.fill" : "mic.fill")
                    .font(.largeTitle)
                    .padding()
                    .background(Circle().fill(pushToTalkManager.isTalking ? Color.red : Color.gray))
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                pushToTalkManager.initialize()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Placeholder functions
func getCachedChannelDescriptor(_ channelUUID: UUID) -> PTChannelDescriptor {
    return PTChannelDescriptor(name: "Restored Channel", image: nil)
}


func checkfont() {
    for family in UIFont.familyNames {
        print(family)
        for name in UIFont.fontNames(forFamilyName: family) {
            print(name)
        }
    }
}
