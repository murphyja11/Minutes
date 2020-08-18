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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Image("LogoText").resizable()
                    .frame(width: 150, height: 35)
                    .padding(0)
                    .padding(.top, 15)
                RefreshableScrollView(height: 100, refreshing: self.$userInfo.reloading) {
                    ForEach(self.userInfo.recommendations, id: \.self) { rec in
                        AudioItemView(metadata: rec, show: self.$showAudioView)
                            .frame(width: geometry.size.width * 0.9, height: 100)
                            .padding(.horizontal, geometry.size.width * 0.1)
                    }
                    
                    // So that the ScrollView doesn't initialize empty:
                    if self.userInfo.user.recommendations.count == 0 {
                        HStack {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
