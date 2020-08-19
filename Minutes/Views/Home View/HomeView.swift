//
//  HomeView.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var audioFile: AudioFile
    @ObservedObject var genreViewModel = GenreViewModel()
    
    @Binding var showAudioView: Bool
    
    enum SubView {
        case forYou, topics
    }
    
    @State var subView: SubView = .forYou
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    SwitchBar(subView: self.$subView)
                    Spacer()
                }
                if self.subView == .forYou {
                    ForYouView(showAudioView: self.$showAudioView)
                } else if self.subView == .topics {
                    GenresView(viewModel: self.genreViewModel, showAudioView: self.$showAudioView)
                } else {
                    Spacer()
                    Text("UH oh")
                    Spacer()
                }
            }
            .onAppear {
                if self.genreViewModel.genres.count == 0 {
                    self.genreViewModel.setGenres { result in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success( _):
                            break
                        }
                    }
                }
            }
        }
    }
    
    
}
