//
//  MeView.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI
import Foundation

struct MeView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @State var showSettings: Bool = false
    
    @State var errorString: String?
    @State var showAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack {
                    Button(action: {}) {
                        Text("")
                            .frame(width: geometry.size.width * 0.15)
                    }
                    Spacer()
                    Text("Profile")
                        .font(.system(size: 20))
                    Spacer()
                    Button(action: {
                        self.showSettings = true
                    }) {
                        ZStack {
                            Image(systemName: "gear").resizable()
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                .frame(width: 30, height: 30, alignment: .leading)
                                .padding(.trailing, 15)
                        }
                        .frame(width: geometry.size.width * 0.15)
                    }
                }
                .frame(height: 45)
                .padding(0)
                
                Divider()
                    .padding(0)
                Spacer()
                Text("Total Minutes Meditated: \(self.userInfo.metrics.secondsListened / 60, specifier: "%.1f")")
                    .font(.system(size: 20))
                Text("Number of Meditations: \(self.userInfo.metrics.numberOfMeditations)")
                    .font(.system(size: 20))
                Spacer()
            }
            
            if self.showSettings {
                 SettingsView(showThisView: self.$showSettings)
            }
        }
    }
}

struct MeView_Previews: PreviewProvider {
    
    static var previews: some View {
        MeView()
            .environmentObject(UserInfo())
    }
}
