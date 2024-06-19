//
//  CustomAlertView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/19/24.
//

import SwiftUI

public enum CustomAlertButtonType {
    case 취소
    case 연결하기
    case 연결끊기
}

struct CustomAlertView: View {
    var title: String = ""
    var content: String = ""
    let confirmBtn: CustomAlertButtonView
    let cancelBtn: CustomAlertButtonView
    
    init(title: String, content: String, confirmBtn: () -> CustomAlertButtonView, cancelBtn: () -> CustomAlertButtonView) {
        self.title = title
        self.content = content
        self.confirmBtn = confirmBtn()
        self.cancelBtn = cancelBtn()
    }
    var body: some View {
        ZStack {
            Image("alertBackImage")
            VStack {
                Text(title)
                    .font(.custom("DOSSaemmul", size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                HStack(spacing: 24) {
                    self.cancelBtn
                    self.confirmBtn
                }
            }
        }.background(ClearBackground())
    }
}


struct ClearBackground: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> UIView {
        
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}


