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
            } else {
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
            }
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Error Playing Audio"), message: Text(self.errorString ?? "Unable to play/pause audio at this time"), dismissButton: .default(Text("Ok")))
        }
    }
 
    @Environment(\.colorScheme) var colorScheme
    private let iconSize: CGFloat = 40
    
    private func play () {
        self.audioFile.play { result in
            switch result {
            case .failure(let error):
                print("error playing audio")
                self.errorString = error.localizedDescription
                self.showAlert = true
            case .success( _):
                break
            }
        }
    }
    
    private func pause () {
        self.audioFile.pause { result in
            switch result {
            case .failure(let error):
                print("error pausing audio")
                self.errorString = error.localizedDescription
                self.showAlert = true
            case .success( _):
                break
            }
        }
    }
}
