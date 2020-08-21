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
    var viewModel = MetricsViewModel()
    @Binding var showSettings: Bool
    

    @State var errorString: String?
    @State var showAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text("")
                        .frame(width: geometry.size.width * 0.15)
                    Spacer()
                    Text("Profile")
                        .font(.system(size: 16)).fontWeight(.medium)
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
                MetricsView(uid: self.userInfo.user.uid)
                    .environmentObject(self.viewModel)
                Spacer()
            }
        }
        
    }
}


struct MeView_Previews: PreviewProvider {
    @State static var showSettings: Bool = false
    
    static var previews: some View {
        MeView(showSettings: self.$showSettings)
            .environmentObject(UserInfo())
    }
}
