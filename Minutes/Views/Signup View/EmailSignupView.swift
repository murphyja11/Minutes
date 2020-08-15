//
//  EmailSignupView.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/1/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct EmailSignupView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Binding var showThisView: Bool
    
    @State private var showError: Bool = false
    @State private var errorString: String = ""
    
    @State var keyboardValue: CGFloat = 0
    
    var body: some View {
        VStack {
            EscapeChev(showView: self.$showThisView)
            Spacer()
            Group {
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.validNameText).font(.caption).foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    HStack {
                        TextField("Name", text: self.$user.fullname).autocapitalization(.words)
                        if (self.user.fullname != "") {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.validEmailAddressText).font(.caption).foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    HStack {
                        TextField("Email Address", text: self.$user.email).autocapitalization(.none).keyboardType(.emailAddress)
                        if (self.user.isEmailValid()) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.validPasswordText).font(.caption).foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    HStack {
                        SecureField("Password", text: self.$user.password)
                        if (self.user.isPasswordValid()) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        }
                    }
                }
                VStack(alignment: .leading) {
                    withAnimation {
                        Text(user.validPasswordTextPrompt).font(.caption)
                        .lineSpacing(0)
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .padding(.top, 1)
                    }
                    HStack {
                        SecureField("Confirm Password", text: self.$user.confirmPassword)
                        if (self.user.passwordsMatch()) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        }
                    }
                    if !self.user.passwordsMatch() {
                        withAnimation {
                            Text(user.validConfirmPasswordText).font(.caption).foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        }
                    }
                }
            }
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            VStack(spacing: 20 ) {
                Button(action: {
                    // Signup
                    FBAuth.createUser(withEmail: self.user.email, name: self.user.fullname, password: self.user.password) { (result) in
                        switch result {
                        case .failure(let error):
                            self.errorString = error.localizedDescription
                            self.showError = true
                        case .success( _):
                            print("account creation successful")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Register")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(5)
                        .opacity(user.isSignInComplete ? 1 : 0.75)
                }
                .disabled(!user.isSignInComplete)
            }.padding()
            Spacer(minLength: self.keyboardValue)
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
        .alert(isPresented: self.$showError) {
            Alert(title: Text("Error creating account"), message: Text(self.errorString), dismissButton: .default(Text("Ok")))
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
}

struct EmailSignupView_Previews: PreviewProvider {
    @State static var showThis: Bool = true
    
    static var previews: some View {
        EmailSignupView(showThisView: $showThis)
    }
}
