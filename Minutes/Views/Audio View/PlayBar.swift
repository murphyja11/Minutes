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
    
    let timeObserver = PlayerTimeObserver()
    
    @State private var currentTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Time: ")
                Text("\(self.audioFile.currentTime)")
            }
            Slider(value: self.$currentTime, in: 0...self.audioFile.duration,
            //onEditingChanged: sliderEditingChanged,
            minimumValueLabel: Text("0.0"),
            maximumValueLabel: Text("X")) {
             // I have no idea in what scenario this View is shown...
             Text("seek/progress slider")
            }
            .onReceive(self.timeObserver.publisher) { time in
                self.currentTime = time
            }
        }
    }
    
    /*private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            self.audioFile.pause()
        }
        else {
            // Editing finished, start the seek
            audioFile.state = .undefined
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            audioFile.seek player!.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
                self.state = .playing
            }
        }
    }*/
}
