//
//  PlayBar.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI
import AVFoundation

struct PlayBar: View {
    @EnvironmentObject var audioFile: AudioFile
    
    @State var currentTime: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Time: ")
                Text("\(audioFile.currentTime)")
                Text("\(self.currentTime)")
            }
            Text("Duration: \(self.audioFile.duration)")
            Slider(value: self.$audioFile.currentTime, in: 0...self.audioFile.duration, onEditingChanged: { _ in
                let targetTime = self.audioFile.currentTime * self.audioFile.duration
                self.audioFile.seek(to: targetTime)
            })
                .padding(.horizontal, 15)
        }
    }
}
