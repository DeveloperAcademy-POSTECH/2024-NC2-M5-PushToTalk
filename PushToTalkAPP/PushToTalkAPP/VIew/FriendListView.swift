
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

class FriendViewModel: ObservableObject {
    @Published var friends: [Friend] = [
        Friend(name: "Kumi", isConnected: false),
        Friend(name: "Hale", isConnected: false),
        Friend(name: "Boo", isConnected: false),
        Friend(name: "Arthur", isConnected: false),
        Friend(name: "Keenie", isConnected: false)
    ]
    
    func toggleConnection(for friend: Friend) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index].isConnected.toggle()
        }
    }
}

struct FriendListView: View {
    @State private var isPresented: Bool = false
    @State private var selectedFriend: Friend?
    @StateObject private var viewModel = FriendViewModel()
    @StateObject private var pttManager = PushToTalkManager()
    @State private var channelUUID = UUID(uuidString: "133D01EA-9D9D-4174-BD3D-5BCB82358334")!
    
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
                ForEach(viewModel.friends.indices, id: \.self) { index in
                    let friend = viewModel.friends[index]
                    HStack {
                        Text(friend.name)
                            .font(.custom("DOSSaemmul", size: 28))
                            .padding(.bottom, 20)
                            .onTapGesture {
                                selectedFriend = friend
                                isPresented.toggle()
                            }
                            .CustomAlert(isPresented: $isPresented) {
                                if friend.isConnected {
                                    CustomAlertView(title: "\(selectedFriend?.name ?? "")님과\n연결을 끊으시겠습니까?", content: "") {
                                        CustomAlertButtonView(type: .연결끊기, isPresented: $isPresented) {
                                            viewModel.toggleConnection(for: selectedFriend!)
                                            Task {
                                                do {
                                                    try await pttManager.leaveChannel()
                                                } catch {
                                                    print("Failed to join channel: \(error)")
                                                }
                                            }
                                            print("연결 끊기 눌림")
                                        }
                                    } cancelBtn: {
                                        CustomAlertButtonView(type: .취소, isPresented: $isPresented) {
                                            print("취소 눌림")
                                        }
                                    }
                                }
                                else{
                                    CustomAlertView(title: "\(selectedFriend?.name ?? "")님과\n연결하시겠습니까?", content: "") {
                                        CustomAlertButtonView(type: .연결하기, isPresented: $isPresented) {
                                            viewModel.toggleConnection(for: selectedFriend!)
                                            Task {
                                                do {
                                                    try await pttManager.joinChannel(channelUUID: channelUUID)
                                                } catch {
                                                    print("Failed to join channel: \(error)")
                                                }
                                            }
                                            print("연결 하기 눌림")
                                        }
                                    } cancelBtn: {
                                        CustomAlertButtonView(type: .취소, isPresented: $isPresented) {
                                            print("취소 눌림")
                                        }
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
        }.onAppear {
            // Initialize the manager when the view appears
            pttManager.initialize()
        }
    }
}
