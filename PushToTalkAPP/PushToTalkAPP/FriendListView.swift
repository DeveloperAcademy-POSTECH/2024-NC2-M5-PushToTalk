
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
    @State private var isPresented: Bool = false
    @State var friends: [Friend] = [
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
                            .onTapGesture {
                                // 여기서 CustomAlert를 표시하도록 수정
                                isPresented.toggle()
                            }
                            .CustomAlert(isPresented: $isPresented) {
                                CustomAlertView(title: "\(friend.name)님과\n연결을 끊으시겠습니까?", content: "") {
                                    // 연결 끊기 버튼 눌렀을 때 실행할 액션
                                    CustomAlertButtonView(type: .연결끊기, isPresented: $isPresented){
                                        //                                        friends.first(where: { $0.id == friend.id })?.isConnected.toggle()
                                        print("연결 끊기 눌림")
                                    }
                                } cancelBtn: {
                                    // 취소 버튼 눌렀을 때 실행할 액션
                                    CustomAlertButtonView(type: .취소, isPresented: $isPresented){
                                        print("취소 눌림")
                                    }
                                }
                            }
                        
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
