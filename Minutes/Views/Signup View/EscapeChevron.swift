//
//  EscapeChevron.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/2/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct EscapeChevron: View {
    @Binding var showView: Bool
    
    var body: some View {
        Button(action: {
            self.hideKeyboard()
            self.showView = false
        }) {
            Image(systemName: "chevron.left").resizable()
                .frame(width: 12, height: 17)
                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                .padding(25)
        }
            .position(x: 23, y: 35)
            .frame(height: 30)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
