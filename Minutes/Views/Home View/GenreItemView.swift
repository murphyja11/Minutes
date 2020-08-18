//
//  GenreItemView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct GenreItemView: View {
    var genre: FBGenre
    
    var body: some View {
        HStack {
            Button(action: {
                self.show = true
                self.startPlaying()
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.metadata.title)
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                        Text(self.metadata.description)
                            .font(.system(size: 12))
                            .fontWeight(.light)
                            .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                    }
                    Spacer()
                    Text(self.metadata.length)
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                        .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                }
                .padding(.trailing, 25)
                .frame(height: 100)
            }
        }
    }
}

struct GenreItemView_Previews: PreviewProvider {
    static var previews: some View {
        GenreItemView()
    }
}
