//
//  LvlView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI

struct LvlView: View {
    @EnvironmentObject var pushCountManager: PushCountManager
    @StateObject private var pttManager = PushToTalkManager()
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                NavigationLink(destination: LvlDetailView()) {
                    Text("레벨 자세히 보기")
                        .font(.custom("DOSSaemmul", size: 16))
                        .underline()
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
            }
            .padding(.top, 50)
            Text("Jane의 현재 Level")
                .font(.custom("DOSSaemmul", size: 28))
                .padding(.top, 52)
            
            if let imageName = pushCountManager.levelImage[pushCountManager.currentLevel]  {
                Image(pushCountManager.currentLevel)
                    .resizable()
                    .frame(width: 240, height: 260)
                    .padding(.top, 20)
                Text(imageName)
                    .font(.custom("DOSSaemmul", size: 28))
                    .padding(.top, 20)
            } else {
                Text("레벨 정보를 찾을 수 없습니다.")
                    .font(.custom("DOSSaemmul", size: 28))
                    .padding(.top, 20)
            }
            Text("다음 레벨까지 \(pushCountManager.calculatePushesRemaining())번의 Push가 남았어요.\n힘내요!")
                .font(.custom("DOSSaemmul", size: 18))
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            Spacer()
        }
        .padding()
        .onAppear {
            // Initialize the manager when the view appears
            pttManager.initialize()
        }
    }
}


#Preview {
    LvlView()
}
