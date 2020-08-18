//
//  TopicsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct GenresView: View {
    @EnvironmentObject var userInfo: UserInfo

    var body: some View {
        GeometryReader { geometry in
            RefreshableScrollView(height: 100, refreshing: self.$userInfo.reloadingGenres) {
                ForEach(self.userInfo.genres, id: \.self) { genre in
                    GenreItemView(genre: genre)
                        .frame(width: geometry.size.width * 0.9, height: 100)
                        .padding(.horizontal, geometry.size.width * 0.1)
                }
                
                // So that the ScrollView doesn't initialize empty:
                if self.userInfo.genres.count == 0 {
                    HStack {
                        Spacer()
                    }
                }
            }
        }
    }
}

