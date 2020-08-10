//
//  LoginWithEmailView.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/2/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct LoginWithEmailView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Binding var showThisView: Bool
    @State var showForgotPW: Bool = false
    
    @State private var authError: EmailAuthError?
    @State private var showAlert: Bool = false

    
    var body: some View {
        Group {
            VStack {
                EscapeChevron(showView: self.$showThisView)
                Spacer()
                VStack {
                    TextField("Email Address",
                              text: self.$user.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $user.password)
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showForgotPW = true
                        }) {
                            Text("Forgot Password")
                        }
                    }.padding(.bottom)
                    VStack(spacing: 10) {
                        Button(action: {
                            // Sign In Action
                            FBAuth.authenticate(withEmail: self.user.email, password: self.user.password) { result in
                                switch result {
                                case .failure(let error):
                                    self.authError = error
                                    self.showAlert = true
                                case .success( _):
                                    print("Signed In")
                                }
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color.green)
                                    .cornerRadius(8)
                                    .frame(width: 200, height: 50)
                                Text("Sign in")
                                    .padding(.vertical, 15)
                                    .foregroundColor(.white)
                            }
                            .opacity(user.isLogInComplete ? 1 : 0.75)
                            .disabled(!user.isLogInComplete)
                        }
                    }
                }
                .frame(width: 300)
                Spacer()
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(self.colorScheme == .light ? Color.white : Color.black)
             
            if self.showForgotPW {
                ForgotPasswordView(showThisView: self.$showForgotPW)
            }
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Login error"), message: Text(self.authError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("Ok")) {
                if self.authError == .incorrectPassword {
                    self.user.password = ""
                } else {
                    self.user.email = ""
                    self.user.password = ""
                }
            })
            
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
}

struct SignInWithEmailView_Previews: PreviewProvider {
    @State static var thisView: Bool = true
    
    static var previews: some View {
        LoginWithEmailView(showThisView: $thisView)
    }
}
