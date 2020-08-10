//
//  ContinueWith.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/2/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct ContinueWith: View {
    var logo: Image
    var text: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
                HStack {
                    self.logo
                        .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                    Spacer()
                    Text(self.text)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                    Spacer()
                }
                .padding()
            }
            .frame(width: geometry.size.width * 0.85, height: 50)
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let cornerRadius: CGFloat = 5
}
