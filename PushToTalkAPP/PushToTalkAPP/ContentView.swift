import SwiftUI
import PushToTalk
import AVFoundation

class ChannelClass {
    var channelUUID = UUID()
    var name = ""
    var isActivating: Bool = false
}

struct ContentView: View {
//    @StateObject private var pushToTalkManager = PushToTalkManager()
    @StateObject private var pushCountManager = PushCountManager()
    var channelUUID = UUID()
    @State private var selectedIndex: Int = 1
    let numberOfPages = 3
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedIndex) {
                    ForEach(0..<numberOfPages) { index in
                        ColorView(index: index)
                            .environmentObject(pushCountManager)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    ForEach(0..<numberOfPages) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(selectedIndex == index ? .black : .gray)
                            .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                    }
                }
                .padding(.top, 0)
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
    }
}

struct ColorView: View {
    let index: Int
    
    var body: some View {
        ZStack {
            switch index {
            case 0:
                FriendListView()
            case 1:
                LvlView()
            case 2:
                TallkBeforePushView()
            default:
                Color.white
            }
        }
    }
}
