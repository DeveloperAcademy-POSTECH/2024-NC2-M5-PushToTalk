import SwiftUI

struct CustomAlertButtonView: View {
    typealias Action = () -> Void // Action 타입 수정
    
    @Binding var isPresented: Bool
    var btnTitle: String // btnTitle은 타입 선언에서 변경할 필요 없음
    var action: Action
    var type: CustomAlertButtonType
    
    init(type: CustomAlertButtonType, isPresented: Binding<Bool>, action: @escaping Action) {
        self._isPresented = isPresented
        
        switch type {
        case .취소:
            self.btnTitle = "취소"
        case .연결하기:
            self.btnTitle = "연결하기"
        case .연결끊기:
            self.btnTitle = "연결끊기"
        }
        self.action = action
        self.type = type
    }
    
    var body: some View {
        Button(action: {
            self.isPresented = false // 버튼 클릭 후 isPresented를 false로 설정
            action() // 클로저 실행
        }, label: {
            Text(btnTitle)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color.blue)
                .font(.custom("DOSSaemmul", size: 12))
        })
    }
}
