//
//  AudioItemView.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct AudioItemView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var audioFile: AudioFile
    
    var uid: String
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                /*Group {
                    if self.metadata.state == .undefined {
                        return Text("loading")
                    } else if self.metadata.state == .failed {
                        return Text("")
                    } else {*/
                AudioItemViewButton(uid: self.uid, show: self.$show)
                    //}
                //}
            }
            .frame(height: 100)
        }
    }
}

struct AudioItemViewButton: View {
    @EnvironmentObject var audioFile: AudioFile
    
    @ObservedObject var metadata: AudioMetadata
    @Binding var show: Bool
    
    init(uid: String, show: Binding<Bool>) {
         print("audio item view starting")
        self._show = show
        self.metadata = AudioMetadata(uid: uid)

    }
    
    @State var errorString: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        Group {
            if metadata.state == .undefined {
                Text("")
            } else if metadata.state == .failed {
                Text("Error retrieving information")
            } else {
                HStack {
                    Button(action: self.startPlaying) {
                        HStack {
                            Image(systemName: "play.fill")
                            VStack {
                                Text(self.metadata.data.title)
                                Text(self.metadata.data.description)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                    }
                    Spacer()
                }
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("Error playing audio"), message: Text(self.errorString), dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
    
    private func startPlaying () {
        self.show = true
        print("calling startPlaying function")
        self.audioFile.startPlaying(filename: self.metadata.data.filename) { result in
            switch result {
            case .failure(let error):
                self.errorString = error.localizedDescription
                self.showAlert = true
            case .success( _):
                break
            }
        }
    }

}
