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
    
    @State var showAudioView: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Home")
                    .font(.system(size: 20))
                    .frame(height: 45)
                    .padding(0)
                Divider()
                    .padding(0)
                ForEach(0..<self.userInfo.user.recommendations.count, id: \.self) {
                    AudioItemView(uid: self.userInfo.user.recommendations[$0], show: self.$showAudioView)
                        .frame(width: geometry.size.width * 0.9, height: 100)
                        .padding(.horizontal, geometry.size.width * 0.1)
                }
                Spacer()
            }
        }
        .onAppear {
            
        }
        .sheet(isPresented: self.$showAudioView) {
            AudioView()
                .environmentObject(self.userInfo)
                .environmentObject(self.audioFile)
        }
    }
}
