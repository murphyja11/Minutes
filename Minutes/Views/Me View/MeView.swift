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
        GeometryReader { geometry in
            VStack {
                Text("Profile")
                    .font(.system(size: 20))
                    .frame(height: 45)
                    .padding(0)
                Divider()
                    .padding(0)
                Spacer()
                Text("Total Minutes Meditated: \(self.userInfo.metrics.secondsListened, specifier: "%.1f")")
                    .font(.system(size: 20))
                Text("Number of Meditations: \(self.userInfo.metrics.numberOfMeditations)")
                    .font(.system(size: 20))
                Spacer()
            }
        }
    }
    
    //@Environment(\.colorScheme) var colorScheme
}

struct MeView_Previews: PreviewProvider {
    
    static var previews: some View {
        MeView()
            .environmentObject(UserInfo())
    }
}
