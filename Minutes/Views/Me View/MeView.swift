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
    @Binding var showSettings: Bool
    
    enum SubView {
        case metrics, activity
    }
    
    @State var subView: SubView = .metrics
    
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
                MetricsView()
            }
        }
//        .onAppear {
//            if self.userInfo.user.uid == nil || self.userInfo.user.uid == "" { return }
//        }
    }
    
//    private func retrieveMetrics(uid: String) {
//        self.userInfo.configureMetricsSnapshotListener()
//        print("retrieving Metrics COntentView")
//        // retrieve metrics
//        FBFirestore.retrieveMetrics(uid: uid) { result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let metrics):
//                self.userInfo.metrics.secondsListened = metrics.secondsListened
//                self.userInfo.metrics.numberOfMeditations = metrics.numberOfMeditations
//            }
//        }
//    }
}


struct MeView_Previews: PreviewProvider {
    @State static var showSettings: Bool = false
    
    static var previews: some View {
        MeView(showSettings: self.$showSettings)
            .environmentObject(UserInfo())
    }
}
