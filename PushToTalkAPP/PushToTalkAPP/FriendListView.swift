
//
//  FriendListView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI

struct FriendList: Identifiable {
    let id = UUID()
    let name : String
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    var isConnected: Bool
}
struct FriendListView: View {
//    let PTTfont = "DOSSaemmul"
    @State private var friends: [Friend] = [
            Friend(name: "Kumi", isConnected: true),
            Friend(name: "Hale", isConnected: false),
            Friend(name: "Boo", isConnected: false),
            Friend(name: "Arthur", isConnected: false),
            Friend(name: "Keenie", isConnected: false)
        ]
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
                    HStack {
                        ZStack {
                            Image("FriendListImage")
                            
                            Text("Friends")
                                .font(.custom("DOSSaemmul", size: 28))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("친구추가가 눌림")
                            // 친구 추가 관련 동작 추가
                        }) {
                            Text("친구추가")
                                .font(.custom("DOSSaemmul", size: 16))
                                .underline()
                                .foregroundColor(.black)
                        }
                    }.padding(.top, 30)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(friends) { friend in
                            HStack {
                                Text(friend.name)
                                    .font(.custom("DOSSaemmul", size: 28))
                                    .padding(.bottom, 20)
                                
                                Spacer()
                                
                                Rectangle()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(friend.isConnected ? .green : .red)
                                    .padding(.bottom, 18)
                            }
                        }.padding(.bottom, 35)
                    }
                .padding(.horizontal, 52)
                    
                    Spacer()
                }
            }
}

#Preview {
    FriendListView()
}

