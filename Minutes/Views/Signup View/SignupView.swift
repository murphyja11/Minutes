//
//  SignupView.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/1/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var showSignupMethods: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Image(systemName: "person").resizable()
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .frame(width: geometry.size.width * self.imageRefactor, height: geometry.size.width * self.imageRefactor)
                    Text("Sign up for an account")
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .font(.system(size: 15))
                        .padding(.vertical, 8)
                    Button(action: {self.showSignupMethods = true}) {
                        ZStack {
                            RoundedRectangle(cornerRadius: self.cornerRadius)
                                .foregroundColor(Color(red: 1, green: 0, blue: 0.5))
                            Text("Sign Up")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame(width: geometry.size.width * self.buttonWidth, height: 50)
                }
                Spacer()
            }
            .frame(height: geometry.size.height)
        }
        .sheet(isPresented: self.$showSignupMethods) {
            SignupMethodsView(showThisView: self.$showSignupMethods)
                .environmentObject(self.userInfo)
        }
        .onAppear {
            
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let cornerRadius: CGFloat = 5
    private let imageRefactor: CGFloat = 0.15
    private let buttonWidth: CGFloat = 0.65
}


struct SignupView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignupView()
    }
}
