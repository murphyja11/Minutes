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
    
    @ViewBuilder
    var body: some View {
        Group {
            if self.viewModel.status == .undefined {
                VStack {
                    Spacer()
                    Text("loading")
                    Spacer()
                }
            } else if self.viewModel.status == .failure {
                VStack {
                    Spacer()
                    Text("failed.  Uh oh")
                    Spacer()
                }
            } else {
                GenresSubView(showAudioView: self.$showAudioView)
                    .environmentObject(self.viewModel)
            }
        }
        .onAppear {
            self.viewModel.selectedGenre = .none
        }
    }
}


struct GenresSubView: View {
    @EnvironmentObject var viewModel: GenreViewModel
    @Binding var showAudioView: Bool
    
    @ViewBuilder
    var body: some View {
        if self.viewModel.selectedGenreEnum != .none {
            AudioSubView(showAudioView: self.$showAudioView)
        } else {
            GeometryReader { geometry in
                RefreshableScrollView(height: 100, refreshing: self.$viewModel.reloading) {
                    ForEach(self.viewModel.genres, id: \.self) { genre in
                        GenreItemView(genre: genre, viewModel: self.viewModel)
                            .frame(width: geometry.size.width * 0.9, height: 100)
                            .padding(.horizontal, geometry.size.width * 0.1)
                    }
                    
                    // So that the ScrollView doesn't initialize empty:
                    if self.viewModel.genres.count == 0 {
                        HStack {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}




struct AudioSubView: View {
    @EnvironmentObject var viewModel: GenreViewModel
    @Binding var showAudioView: Bool
    
    @ViewBuilder
    var body: some View {
//        if self.viewModel.audioSubviewStatus == .undefined {
//            return VStack {
//                GenreEscapeChevron(viewModel: self.viewModel)
//                Spacer()
//                Text("loading")
//                Spacer()
//            }
//        } else if self.viewModel.audioSubviewStatus == .failure {
//            return VStack {
//                GenreEscapeChevron(viewModel: self.viewModel)
//                Spacer()
//                Text("failed.  Uh oh")
//                Spacer()
//            }
//        } else {
            return GeometryReader { geometry in
                VStack {
                    GenreEscapeChevron(viewModel: self.viewModel)
                    Spacer()
                    RefreshableScrollView(height: 100, refreshing: self.$viewModel.reloading) {
                        ForEach(self.viewModel.getMetadataArray(nil), id: \.self) { metadata in
                            Text(metadata.title)
                            AudioItemView(metadata: metadata, show: self.$showAudioView)
                                .frame(width: geometry.size.width * 0.9, height: 100)
                                .padding(.horizontal, geometry.size.width * 0.1)
                        }

                         //So that the ScrollView doesn't initialize empty:
                        if self.viewModel.genres.count == 0 {
                            HStack {
                                Spacer()
                            }
                        }
                    }
                //}
            }
        }
    }
}
