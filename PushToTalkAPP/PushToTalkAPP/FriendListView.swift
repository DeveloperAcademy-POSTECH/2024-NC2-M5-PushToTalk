
//
//  FriendListView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI

struct FriendListView: View {
//    let PTTfont = "DOSSaemmul"
    var Friends = ["Kumi","Hale", "Boo", "Arthur", "Keenie"]
    var body: some View {
        VStack {
            HStack {
                ZStack{
                    Image("FriendListImage")
                    Text("Friends")
                        .font(.custom("DOSSaemmul", size: 28))
                    
                }
                
                Spacer()
                Button {
                    print("친구추가가 눌림")
                } label: {
                    Text("친구추가")
                        .font(.custom("DOSSaemmul", size: 16))
                        .underline()
                        .foregroundStyle(.black)
                }
                
            }.padding()
        
            Spacer()
        }
    }
}

#Preview {
    FriendListView()
}

