//
//  LvlView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI

struct LvlView: View {
    @State var pushCount: Int = 0 {
        didSet {
            updateLevel()
        }
    }
    @State var currentLevel: String = "종이컵 전화기"
    var levelImage: [String: String] =
    ["종이컵 전화기": "Lv.1 종이컵 전화",
     "모스부호":"Lv.2 모스부호",
     "집전화" : "Lv.3 집전화",
     "삐삐":"Lv.4 삐삐",
     "씨티폰":"Lv.5 씨티폰",
     "폴더폰":"Lv.6 폴더폰",
     "스마트폰":"Lv.7 스마트폰"]
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Spacer()
                    NavigationLink(destination: LvlDetailView()) {
                        Text("레벨 자세히 보기")
                            .font(.custom("DOSSaemmul", size: 16))
                            .underline()
                            .foregroundColor(.black)
                    }
                }.padding(.top, 51)
                Text("Jane의 현재 Level")
                    .font(.custom("DOSSaemmul", size: 28))
                    .padding(.top, 82)
                
                if let imageName = levelImage[currentLevel] {
                    Image(currentLevel)
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
                Text("다음 레벨까지 \(calculatePushesRemaining())번의 Push가 남았어요.\n힘내요!")
                    .font(.custom("DOSSaemmul", size: 18))
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                Spacer()
            }.padding()
                .onAppear {
                    updateLevel()
                }
                .onChange(of: pushCount) { _ in
                    updateLevel()
                }
        }.navigationTitle("Lvl.List")
    }
    private func updateLevel() {
        switch pushCount {
        case 0..<100:
            self.currentLevel = "종이컵 전화기"
        case 100..<200:
            self.currentLevel = "모스부호"
        case 200..<300:
            self.currentLevel = "집전화"
        case 300..<500:
            self.currentLevel = "삐삐"
        case 500..<700:
            self.currentLevel = "씨티폰"
        case 700..<1000:
            self.currentLevel = "폴더폰"
        case 1000...:
            self.currentLevel = "스마트폰"
        default:
            self.currentLevel = ""
        }
    }
    
    private func calculatePushesRemaining() -> Int {
        switch pushCount {
        case 0..<100:
            return 100 - pushCount
        case 100..<200:
            return 200 - pushCount
        case 200..<300:
            return 300 - pushCount
        case 300..<500:
            return 500 - pushCount
        case 500..<700:
            return 700 - pushCount
        case 700..<1000:
            return 1000 - pushCount
        case 800...:
            return 0 // 스마트폰 단계에서는 더 이상 레벨업 없음
        default:
            return 0
        }
    }
}


#Preview {
    LvlView()
}
