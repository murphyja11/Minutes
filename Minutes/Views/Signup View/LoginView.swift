//
//  LoginView.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/1/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct LoginView: View {

    @Binding var showThisView: Bool
    @State var emailView: Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                EscapeChevron(showView: self.$showThisView)
                Spacer()
                Text("Log in to Project Tucker")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom, 10)
                Button(action: {
                    self.emailView = true
                }){
                    ContinueWith(logo: Image(systemName: "person"), text: "Use email")
                    .frame(height: 50)
                    .padding(2)
                }
                ContinueWithApple()
                    .frame(width: geometry.size.width * 0.85, height: 50)
                    .padding(2)
                Spacer()
                Divider()
                ZStack {
                    Rectangle()
                        .frame(height: 45)
                        .foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        Button(action: {
                            self.showThisView = false
                        }){
                            Text("Sign up")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 1, green: 0, blue: 0.5))
                        }
                        Spacer()
                    }
                    
                }
                .padding(.bottom, 8)
            }
            .background(self.colorScheme == .light ? Color.white : Color.black)
            
            if self.emailView {
                LoginWithEmailView(showThisView: self.$emailView)
                    .background(self.colorScheme == .light ? Color.white : Color.black)
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let cornerRadius: CGFloat = 5
    private let buttonWidth: CGFloat = 0.65
}

struct LoginView_Previews: PreviewProvider {
    @State static var showView: Bool = true
    
    static var previews: some View {
        LoginView(showThisView: $showView)
    }
}
