//
//  LvlDetailView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI

struct LvlDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                HStack(spacing: 30) {
                    Image("종이컵 전화기").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.1 종이컵 전화").font(.custom("DOSSaemmul", size: 22))
                        Text("처음 레벨이에요.").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
                HStack(spacing: 30) {
                    Image("모스부호").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.2 모스부호").font(.custom("DOSSaemmul", size: 22))
                        Text("Push! 100번을 달성하세요").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
                HStack(spacing: 30) {
                    Image("집전화").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.3 집전화").font(.custom("DOSSaemmul", size: 22))
                        Text("Push! 200번을 달성하세요").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
                HStack(spacing: 30) {
                    Image("삐삐").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.4 삐삐").font(.custom("DOSSaemmul", size: 22))
                        Text("Push! 300번을 달성하세요").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
                HStack(spacing: 30) {
                    Image("씨티폰").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.5 씨티폰").font(.custom("DOSSaemmul", size: 22))
                        Text("Push! 500번을 달성하세요").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
                HStack(spacing: 30) {
                    Image("폴더폰").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.6 폴더폰").font(.custom("DOSSaemmul", size: 22))
                        Text("Push! 700번을 달성하세요").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
                HStack(spacing: 30) {
                    Image("스마트폰").resizable().frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Lv.7 스마트폰").font(.custom("DOSSaemmul", size: 22))
                        Text("Push! 1000번을 달성하세요").font(.custom("DOSSaemmul", size: 18))
                    }
                }.padding(.leading, 20)
            }
            
        }.scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.goBack()
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text("LVL. List")
                        .font(.custom("DOSSaemmul", size: 22))
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("")
                }
            }
//            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    func goBack() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    LvlDetailView()
}
