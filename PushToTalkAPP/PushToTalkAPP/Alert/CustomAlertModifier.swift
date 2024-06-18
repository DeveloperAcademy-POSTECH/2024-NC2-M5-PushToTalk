//
//  CustomAlertModifier.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/19/24.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresent: Bool
    let alert: CustomAlertView
    
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresent){
                alert
            }
            .transaction {transaction in
                transaction.disablesAnimations = true
            }
    }
}

extension View {
    func CustomAlert(isPresented: Binding<Bool>, CustomAlert: @escaping () -> CustomAlertView) -> some View {
        return modifier(CustomAlertModifier(isPresent: isPresented, alert: CustomAlert()))
    }
}
