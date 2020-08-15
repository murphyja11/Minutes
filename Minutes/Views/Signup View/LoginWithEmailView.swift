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
    
    @State var keyboardValue: CGFloat = 0

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                EscapeChev(showView: self.$showThisView)
                Spacer()
                VStack {
                    TextField("Email Address",
                              text: self.$user.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: self.$user.password)
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.showForgotPW = true
                            }
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
                                    .cornerRadius(5)
                                    .frame(width: 200, height: 50)
                                Text("Sign in")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                            }
                            .opacity(self.user.isLogInComplete ? 1 : 0.75)
                            .disabled(!self.user.isLogInComplete)
                        }
                    }
                }
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer(minLength: self.keyboardValue + CGFloat(20))
            }
            .background(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    withAnimation {
                        self.keyboardValue = value.height
                    }
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                    self.keyboardValue = 0
                }
            }
             
            if self.showForgotPW {
                ForgotPasswordView(showThisView: self.$showForgotPW)
                    .transition(.move(edge: .trailing))
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

#if canImport(UIKit)
extension View {
    
}
#endif

struct SignInWithEmailView_Previews: PreviewProvider {
    @State static var thisView: Bool = true
    
    static var previews: some View {
        LoginWithEmailView(showThisView: $thisView)
    }
}
