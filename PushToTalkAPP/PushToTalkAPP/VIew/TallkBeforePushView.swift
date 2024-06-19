//
//  TallkBeforePushView.swift
//  call
//
//  Created by yeji on 6/18/24.
//

import SwiftUI

struct TallkBeforePushView: View {
    @EnvironmentObject var pushCountManager: PushCountManager
    @GestureState private var isPressing = false
    
    @StateObject private var pttManager = PushToTalkManager()
    //    @State private var channelId = "channelId"
    @State private var token = "<device_token>"
    @State private var channelUUID = UUID(uuidString: "133D01EA-9D9D-4174-BD3D-5BCB82358334")!
    
    var body: some View {
        
        let defaultImage = "Push"
        let pressedImage = "PushSpeaking"
        
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20){
            
            if pttManager.isInitialized {
                ZStack{
                    Image("Friend")
                        .padding(.vertical, 30)
                    Text("Kumi")
                        .font(.custom("DOSSaemmul", size: 30))
                }
                Image(isPressing ? pressedImage : defaultImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .updating($isPressing) { currentState, gestureState, transaction in
                                gestureState = currentState
                                pttManager.startTransmitting(channelUUID: channelUUID)
                                pushCountManager.pushCount += 1
                                //                            pushCount += 1
                            }
                            .onEnded { _ in
                                pttManager.stopTalking(channelUUID: channelUUID)
                            }
                        
                    )
                
                
                Text(isPressing ? "Speaking.." : "Push!")
                    .padding()
                    .font(.custom("DOSSaemmul", size:30))
                
                Text("\(pushCountManager.getCurrentPushCount())/\(pushCountManager.getMaxCount())")
                    .font(.custom("DOSSaemmul", size: 24))
            }
            else {
                Text("pttManager 초기화 안됨")
            }
            
        }
        .padding(.bottom, 60)
        .onAppear {
            // Initialize the manager when the view appears
            pttManager.initialize()
        }
    }
}






//https://stackoverflow.com/questions/62220494/swiftui-how-to-change-the-buttons-image-on-click
