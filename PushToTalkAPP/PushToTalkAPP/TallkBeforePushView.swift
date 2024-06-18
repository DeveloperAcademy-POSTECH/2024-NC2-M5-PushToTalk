//
//  TallkBeforePushView.swift
//  call
//
//  Created by yeji on 6/18/24.
//

import SwiftUI

struct TallkBeforePushView: View {
    @State private var isImageTapped: Bool = false
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20){
           
            ZStack{
                Image("Friend")
                    .padding(.vertical, 30)
                Text("Kumi")
                    .font(.custom("DOSSaemmul", size: 30))
            }
            Button(action: {
                self.isImageTapped.toggle()
            }) {
                VStack {
                    Image(self.isImageTapped == true ? "Push" : "Push")
                }
                
            }
                .padding()
            Text("Push!")
                .font(.custom("DOSSaemmul", size: 30))
            Text("15/100")
                .font(.custom("DOSSaemmul", size: 24))
                
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    TallkBeforePushView()
}



    
    
//https://stackoverflow.com/questions/62220494/swiftui-how-to-change-the-buttons-image-on-click
