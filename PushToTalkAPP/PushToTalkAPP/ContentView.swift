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
//    @Binding var pushCount: Int
    @State private var selectedIndex: Int = 1
    let numberOfPages = 3
    
    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(0..<numberOfPages) { index in
                    ColorView(index: index)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<numberOfPages) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(selectedIndex == index ? .blue : .gray)
                        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                }
            }
            .padding(.top, 16)
        }
        //        VStack {
        //            Text("PushToTalk")
        //                .font(.largeTitle)
        //
        //            Spacer()
        //
        //            Button {
        //                pushToTalkManager.joinChannel()
        //                checkfont()
        //            } label: {
        //                Text("join channel")
        //            }
        //
        //
        //            Button(action: {
        //                if pushToTalkManager.isTalking {
        //                    pushToTalkManager.stopTalking()
        //                } else {
        //                    pushToTalkManager.startTalking()
        //                }
        //            }) {
        //                Image(systemName: pushToTalkManager.isTalking ? "mic.slash.fill" : "mic.fill")
        //                    .font(.largeTitle)
        //                    .padding()
        //                    .background(Circle().fill(pushToTalkManager.isTalking ? Color.red : Color.gray))
        //            }
        //
        //            Spacer()
        //        }
        //        .padding()
        //        .onAppear {
        //            Task {
        //                pushToTalkManager.initialize()
        //            }
        //        }
    }
}

struct ColorView: View {
    let index: Int
//    @Binding var pushCount: Int
    var body: some View {
        ZStack {
            switch index {
            case 0:
                FriendListView()
            case 1:
                LvlView()
            case 2:
                TallkBeforePushView()
            default:
                Color.white
            }
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(pushCount: $pushCount)
//    }
//}

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
