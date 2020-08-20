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
    var genreViewModel = GenreViewModel()
    
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
                    GenresView(showAudioView: self.$showAudioView)
                        .environmentObject(self.genreViewModel)
                } else {
                    Spacer()
                    Text("UH oh")
                    Spacer()
                }
            }
        }
    }
}
