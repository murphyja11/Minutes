//
//  EscapeButton.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/2/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct EscapeButton: View {
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark").resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                .padding(25)
        }
            .position(x: 23, y: 35)
            .frame(height: 30)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
}
