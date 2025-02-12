//
//  TopicsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI


struct GenresView: View {
    @EnvironmentObject var viewModel: GenreViewModel
    @Binding var showAudioView: Bool
    
    //@ViewBuilder
    var body: some View {
        let genres = self.viewModel.genres ?? []
        
        return GeometryReader { geometry in
            if self.viewModel.selectedGenreEnum == .none {
                RefreshableScrollView(height: 100, refreshing: self.$viewModel.reloading) {
                    ForEach(genres, id: \.self) { genre in
                        GenreItemView(genre: genre, viewModel: self.viewModel)
                            .frame(width: geometry.size.width * 0.9, height: 100)
                            .padding(.horizontal, geometry.size.width * 0.1)
                    }

                    // So that the ScrollView doesn't initialize empty:
                    if genres.count == 0 {
                        HStack {
                            Spacer()
                        }
                    }
                }
            } else {
                AudioSubView(showAudioView: self.$showAudioView)
            }
        }
        .onAppear {
            self.viewModel.selectedGenreEnum = .none
            self.viewModel.selectedGenre = nil
        }
    }
}



struct AudioSubView: View {
    @EnvironmentObject var viewModel: GenreViewModel
    @Binding var showAudioView: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                GenreEscapeChevron(viewModel: self.viewModel)
                Spacer()
                RefreshableScrollView(height: 100, refreshing: self.$viewModel.reloading) {
                    ForEach(self.viewModel.getMetadataArray(), id: \.self) { metadata in
                        VStack {
                            Text(metadata.title)
                            AudioItemView(metadata: metadata, show: self.$showAudioView)
                                .frame(width: geometry.size.width * 0.9, height: 100)
                                .padding(.horizontal, geometry.size.width * 0.1)
                        }
                    }

                    //So that the ScrollView doesn't initialize empty:
                    if self.viewModel.genres == nil {
                        HStack {
                            Spacer()
                        }
                    } else if self.viewModel.genres!.count == 0 {
                        HStack {
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.setMetadataArray(self.viewModel.selectedGenre)
        }
    }
}
