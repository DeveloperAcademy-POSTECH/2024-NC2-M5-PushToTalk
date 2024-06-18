//
//  CustomNavigationBarView.swift
//  PushToTalkAPP
//
//  Created by 김이예은 on 6/18/24.
//

import SwiftUI

struct CustomNavigationBarView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Content Here")
                    .padding()
                
                Spacer()
            }
            .navigationBarItems(
                leading: HStack {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            // Handle back action here
                        }
                    Text("Lvl. List")
                        .font(.custom("YourCustomFont", size: 20))
                        .foregroundColor(.black)
                },
                trailing: Text("") // Optional: Add any trailing items
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBarView()
    }
}
