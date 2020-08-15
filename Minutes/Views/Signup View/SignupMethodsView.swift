//
//  SignupMethodsView.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/1/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct SignupMethodsView: View {
    @EnvironmentObject var userInfo: UserInfo
    @Binding var showView: SigninView.ShowView
    
    @State var showLoginScreen: Bool = false
    @State var showEmail: Bool = false

    
    var body: some View {
        GeometryReader { geometry in
                VStack {
                    EscapeButton()
                    Spacer()
                    Text("Sign up for Project Tucker")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.bottom, 10)
                    // Phone or Email
                    Button(action: {
                        self.showEmail = true
                    }){
                        ContinueWith(logo: Image(systemName: "person"), text: "Use email")
                        .frame(height: 50)
                        .padding(2)
                    }
                    // Apple
                    ContinueWithApple()
                        .frame(width: geometry.size.width * 0.85, height: 50)
                        .padding(2)
                    Spacer()
                    Divider()
                    // Login if already have an account
                    ZStack {
                        Rectangle()
                            .frame(height: 45)
                            .foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
                        HStack {
                            Spacer()
                            Text("Already have an account?")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            Button(action: {
                                withAnimation {
                                    self.showView = .login
                                }
                            }){
                                Text("Log in")
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 1, green: 0, blue: 0.5))
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.bottom, 8)
                }
                .frame(height: geometry.size.height)

            if self.showEmail {
                EmailSignupView(showThisView: self.$showEmail)
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let cornerRadius: CGFloat = 5
}

struct LoginMethodsView_Previews: PreviewProvider {
    
    @State static var value: SigninView.ShowView = .login
    static var previews: some View {
        SignupMethodsView(showView: self.$value)
        
    }
}

