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
    @EnvironmentObject var userInfo: UserInfo
    
    @State var errorString: String = ""
    @State var showAlert: Bool = false
    
    @ViewBuilder
    var body: some View {
        if audioFile.status == .completed {
            Text("").onAppear {
                self.audioFile.end(user_uid: self.userInfo.user.uid)
                self.presentationMode.wrappedValue.dismiss()
            }
        } else if audioFile.status == .error {
            Text("Error\nThis happens if the player is nil and the play function is called\n\nLMK if this happened because it shouldn't")
        } else {
            VStack {
                AudioEscapeButton()
                Spacer()
                HStack {
                    Spacer()
                    if self.audioFile.status == .undefined || self.audioFile.status == .stalled {
                        LoadingSpinner()
                    } else {
                        RewindView()
                            .padding(.trailing, 15)
                        PlayButton()
                        FastForwardView()
                            .padding(.leading, 15)
                    }
                    Spacer()
                }
                Spacer()
                PlayBar()
                    .padding(.bottom, 50)
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
}

struct FastForwardView: View {
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        Button(action: { self.fastForward() }) {
            Image(systemName: "goforward.10").resizable()
            .frame(width: self.iconSize, height: self.iconSize)
        }
    }
    
    private func fastForward () {
        do {
            try self.audioFile.fastForward(10)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private let iconSize: CGFloat = 35
}

struct RewindView: View {
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        Button(action: { self.rewind() }) {
            Image(systemName: "gobackward.10").resizable()
            .frame(width: self.iconSize, height: self.iconSize)
        }
    }
    
    private func rewind () {
        do {
            try self.audioFile.rewind(10)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private let iconSize: CGFloat = 35
}
