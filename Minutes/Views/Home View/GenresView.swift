//
//  TopicsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct GenresView: View {
    @ObservedObject var viewModel: GenreViewModel
    @Binding var showAudioView: Bool
    
    //@ViewBuilder
    var body: some View {
        if self.viewModel.selectedGenreEnum == .none {
            return GeometryReader { geometry in
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
        } else {
            GeometryReader { geometry in
                VStack {
                    GenreEscapeChevron(viewModel: self.viewModel)
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
                }
            }
        }
    }
}

//struct GenreSubview: View {
//    @ObservedObject var viewModel: GenreViewModel
//
//    var body: some View {
//        if self.viewModel.audioItemStatus == .undefined {
//            VStack {
//                Spacer()
//                Text("loading")
//                Spacer()
//            }
//        } else if self.viewModel.audioItemStatus == .failure {
//
//        } else {
//            GeometryReader { geometry in
//                            VStack {
//                                GenreEscapeChevron(viewModel: self.viewModel)
//                                RefreshableScrollView(height: 100, refreshing: self.$viewModel.reloading) {
//                                    ForEach(self.viewModel.getMetadataArray(), id: \.self) { metadata in
//                                        Text(metadata.title)
//            //                            AudioItemView(metadata: metadata, show: self.$showAudioView)
//            //                                .frame(width: geometry.size.width * 0.9, height: 100)
//            //                                .padding(.horizontal, geometry.size.width * 0.1)
//                                    }
//
//                                    // So that the ScrollView doesn't initialize empty:
//            //                        if self.userInfo.genres.count == 0 {
//            //                            HStack {
//            //                                Spacer()
//            //                            }
//            //                        }
//                                }
//                            }
//                        }
//        }
//    }
//}

