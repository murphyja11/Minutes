//
//  PlayButton.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var audioFile: AudioFile
    
    @State var errorString: String?
    @State var showAlert: Bool = false
    
    @State var isLoading = false
    
    var body: some View {
        Group {
            if self.audioFile.status == .playing {
                Button(action: self.pause) {
                    ZStack {
                        Circle()
                            .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.05, green: 0.05, blue:0.05))
                            .frame(width: 120, height: 120)
                        Image(systemName: "pause.fill").resizable()
                        .frame(width: self.iconSize, height: self.iconSize)
                        .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                        .padding(45)
                    }
                }
            } else if self.audioFile.status == .paused {
                Button(action: self.play) {
                    ZStack {
                        Circle()
                            .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.05, green: 0.05, blue:0.05))
                            .frame(width: 120, height: 120)
                        Image(systemName: "play.fill").resizable()
                        .frame(width: self.iconSize, height: self.iconSize)
                        .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                        .padding(45)
                    }
                }
            } else {
                Circle()
                .trim(from: 0, to: 0.4)
                .stroke(Color.blue)
                .frame(width: 80, height: 80)
                    .rotationEffect(Angle(degrees: self.isLoading ? 360 : 0))
                .animation(Animation.default.repeatForever(autoreverses: false))
                .onAppear {
                    self.isLoading = true
                }
                .onDisappear {
                    self.isLoading = false
                }
            }
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Error Playing Audio"), message: Text(self.errorString ?? "Unable to play/pause audio at this time"), dismissButton: .default(Text("Ok")))
        }
    }
 
    @Environment(\.colorScheme) var colorScheme
    private let iconSize: CGFloat = 40
    
    private func play () {
        do {
            try self.audioFile.play()
        } catch {
            self.errorString = error.localizedDescription
            self.showAlert = true
        }
    }
    
    private func pause () {
        do {
            try self.audioFile.pause()
        } catch {
            self.errorString = error.localizedDescription
            self.showAlert = true
        }
    }
}
