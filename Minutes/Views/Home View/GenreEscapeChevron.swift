//
//  GenreEscapeChevron.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct GenreEscapeChevron: View {
    @ObservedObject var viewModel: GenreViewModel
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.viewModel.selectGenre(for: "")
            }
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
}
