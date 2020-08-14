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
    
    var body: some View {
        VStack {
            EscapeChevron(showView: self.$showThisView)
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
                    Text(user.validPasswordTextPrompt).font(.caption)
                    .lineSpacing(0)
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .padding(.top, 1)
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
                        Text(user.validConfirmPasswordText).font(.caption).foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    }
                }
            }.frame(width: 300)
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
            Spacer()
        }
        .background(self.colorScheme == .light ? Color.white : Color.black)
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
