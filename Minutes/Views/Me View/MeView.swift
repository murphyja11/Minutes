//
//  MeView.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MeView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Profile")
                    .font(.system(size: 20))
                    .frame(height: 45)
                    .padding(0)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "gear").resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .padding(.trailing, 20)
                }
            }
            Divider()
                .padding(0)
            Spacer()
            Text("Minutes Meditated: \(self.userInfo.user.metrics.minutesMeditated, specifier: "%.1f")")
                .font(.system(size: 20))
            Text("Number of Meditations: \(self.userInfo.user.metrics.numberOfMeditations)")
                .font(.system(size: 20))
            Spacer()
        }
    }
    
    //@Environment(\.colorScheme) var colorScheme
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
