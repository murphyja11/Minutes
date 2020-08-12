//
//  AudioView.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct AudioView: View {
    @EnvironmentObject var audioFile: AudioFile
    
    @State var errorString: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        Group {
            if audioFile.status == .undefined {
                Text("")
            } else {
                VStack {
                    AudioEscapeButton()
                    Spacer()
                    HStack {
                        Spacer()
                        RewindView()
                            .padding(.trailing, 15)
                        PlayButton()
                        FastForwardView()
                            .padding(.leading, 15)
                        Spacer()
                    }
                    Spacer()
                    //PlayBar()
                }
            }
        }
    }
}

struct FastForwardView: View {
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        Button(action: { self.audioFile.fastForward(10) }) {
            Image(systemName: "goforward.10").resizable()
            .frame(width: self.iconSize, height: self.iconSize)
        }
    }
    
    private let iconSize: CGFloat = 35
}

struct RewindView: View {
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        Button(action: { self.audioFile.rewind(10) }) {
            Image(systemName: "gobackward.10").resizable()
            .frame(width: self.iconSize, height: self.iconSize)
        }
    }
    private let iconSize: CGFloat = 35
}


struct AudioEscapeButton: View {
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        Button(action: {
            self.audioFile.end()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark").resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                .padding(25)
        }
            .position(x: 23, y: 35)
            .frame(height: 30)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
}
