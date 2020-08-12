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
                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue:0.1))

                if !self.presentationMode.wrappedValue.isPresented {
                    AudioItemViewButton(uid: self.uid, show: self.$show)
                }
            }
            .frame(height: 100)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
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
                            Image(systemName: "play.fill").resizable()
                                .frame(width: 18, height: 20)
                                .padding(.horizontal, 25)
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                            VStack(alignment: .leading) {
                                Text(self.metadata.data.title)
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                    .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                Text(self.metadata.data.description)
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                            }
                            Spacer()
                            Text(self.metadata.data.length)
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                        }
                        .padding(.trailing, 25)
                    }
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

    @Environment(\.colorScheme) var colorScheme
}
