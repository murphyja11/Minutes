//
//  SigninView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/15/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct SigninView: View {
    
    enum ShowView {
        case signup, login
    }
    
    @State var showView: ShowView = .signup
    
    var body: some View {
        ZStack {
            if self.showView == .signup {
                SignupMethodsView(showView: self.$showView)
            } else {
                LoginView(showView: self.$showView)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}
