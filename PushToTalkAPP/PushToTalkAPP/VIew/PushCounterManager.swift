//
//  PushCounterManager.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI
import Combine

class PushCountManager: ObservableObject {
    @AppStorage("pushCount") var pushCount: Int = 0 {
        didSet {
            updateLevel()
        }
    }
    @Published var currentLevel: String = "종이컵 전화기"
    
    let levelImage: [String: String] = [
        "종이컵 전화기": "Lv.1 종이컵 전화",
        "모스부호": "Lv.2 모스부호",
        "집전화": "Lv.3 집전화",
        "삐삐": "Lv.4 삐삐",
        "씨티폰": "Lv.5 씨티폰",
        "폴더폰": "Lv.6 폴더폰",
        "스마트폰": "Lv.7 스마트폰"
    ]
    
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
    
    func calculatePushesRemaining() -> Int {
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
        case 1000...:
            return 0 // 스마트폰 단계에서는 더 이상 레벨업 없음
        default:
            return 0
        }
    }
    func getMaxCount() -> Int {
            switch pushCount {
            case 0..<100:
                return 100
            case 100..<200:
                return 100
            case 200..<300:
                return 100
            case 300..<500:
                return 200
            case 500..<700:
                return 200
            case 700..<1000:
                return 300
            case 1000...:
                return 1000 // 스마트폰 단계에서는 더 이상 레벨업 없음
            default:
                return 0
            }
        }
        
        func getCurrentPushCount() -> Int {
            switch pushCount {
            case 0..<100:
                return pushCount
            case 100..<200:
                return pushCount - 100
            case 200..<300:
                return pushCount - 200
            case 300..<500:
                return pushCount - 300
            case 500..<700:
                return pushCount - 500
            case 700..<1000:
                return pushCount - 700
            case 1000...:
                return pushCount - 1000
            default:
                return 0
            }
        }
}
