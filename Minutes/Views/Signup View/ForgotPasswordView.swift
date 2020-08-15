//
//  ForgotPasswordView.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/2/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var user: UserViewModel = UserViewModel()
    @Binding var showThisView: Bool
    
    @State private var showAlert: Bool = false
    @State private var errorString: String?
    
    @State var keyboardValue: CGFloat = 0
    
    var body: some View {
        VStack {
            EscapeChev(showView: self.$showThisView)
            Spacer()
            Text("Request a password reset")
            TextField("Enter email address", text: $user.email).autocapitalization(.none).keyboardType(.emailAddress)
                .frame(width: 300)
            Button(action: {
                // Reset Password action
                print("calling reset pw function")
                FBAuth.resetPassword(email: self.user.email) { result in
                    switch result {
                    case .failure(let error):
                        self.errorString = error.localizedDescription
                    case .success( _):
                        break
                    }
                    self.showAlert = true
                    print("showAlert = \(self.showAlert)")
                }
                print("done with reset password function")
            }) {
                Text("Reset")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .opacity(user.isEmailValid() ? 1 : 0.75)
            }
            .disabled(!user.isEmailValid())
            Spacer(minLength: self.keyboardValue + CGFloat(20))
        }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password reset"), message: Text(self.errorString ?? "Success.  Reset password instructions sent to your email"), dismissButton: .default(Text("Ok")) {
                    if self.errorString == nil {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        .textFieldStyle(RoundedBorderTextFieldStyle())
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
    }
    
     @Environment(\.colorScheme) var colorScheme
}

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var showView: Bool = true
    
    static var previews: some View {
        ForgotPasswordView(showThisView: $showView)
    }
}
