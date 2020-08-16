//
//  AudioEscapeButton.swift
//  Minutes
//
//  Created by Jack Murphy on 8/16/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct AudioEscapeButton: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var audioFile: AudioFile
    
    var body: some View {
        Button(action: {
            self.audioFile.sendAudioEvent(user_uid: self.userInfo.user.uid)
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
