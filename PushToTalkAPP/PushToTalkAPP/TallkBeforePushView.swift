//
//  TallkBeforePushView.swift
//  call
//
//  Created by yeji on 6/18/24.
//

import SwiftUI

struct TallkBeforePushView: View {
    
    @GestureState private var isPressing = false
    
    var body: some View {
        
        let defaultImage = "Push"
        let pressedImage = "Pushopacity"
        
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20){
           
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
//                            pushCount += 1
                        }
                )
            
        
            Text(isPressing ? "Listening.." : "Push!")
                .padding()
                .font(.custom("DOSSaemmul", size:30))
           
            Text("15/100")
                .font(.custom("DOSSaemmul", size: 24))
                
        }
        .padding(.bottom, 60)
    }
}




    
    
//https://stackoverflow.com/questions/62220494/swiftui-how-to-change-the-buttons-image-on-click
