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
    
    var body: some View {
        VStack {
            Slider(value: self.$audioFile.currentTime, in: 0...self.audioFile.duration, onEditingChanged: { _ in
                let targetTime = self.audioFile.currentTime
                self.seek(to: targetTime)
            })
            HStack {
                Text(self.toMinutesSeconds(audioFile.currentTime))
                Spacer()
                Text(self.toMinutesSeconds(audioFile.duration))
            }
        }
        .padding(.horizontal, 30)
    }
    
    
    private func seek(to time: Double) {
        do {
            try self.audioFile.seek(to: time)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func toMinutesSeconds (_ number: Double) -> String {
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        let seconds = "\((int % 3600) % 60)"
        return minutes + ":" + (seconds.count == 1 ? "0" + seconds : seconds)
    }
}
