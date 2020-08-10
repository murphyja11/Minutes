//
//  PlayBar.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct PlayBar: View {
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        HStack {
            Text("Time: ")
            Text("\(self.audioFile.currentTime)")
        }
    }
}
