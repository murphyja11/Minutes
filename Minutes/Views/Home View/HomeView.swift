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
                } else {
                    GenresView()
                }
            }
            .onAppear {
                if self.userInfo.genres == [] {
                    self.setGenres()
                }
            }
        }
    }
    
    private func setGenres() {
        FBFirestore.retrieveGenres { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let genres):
                self.userInfo.genres = genres
            }
        }
    }
}
