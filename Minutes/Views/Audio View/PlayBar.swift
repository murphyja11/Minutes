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
    
    @State private var currentTime: Float64 = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Time: ")
                Text("\(self.currentTime)")
            }
        }
    }
}
