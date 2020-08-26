//
//  ForYouView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct ForYouView: View {
    @EnvironmentObject var userInfo: UserInfo
    @Binding var showAudioView: Bool
    
    var body: some View {
        GeometryReader { geometry in
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
