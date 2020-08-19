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
    
    enum Status {
        case undefined, failure, success
    }
    
    @State var status: Status = .undefined
    

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
                if self.status == .undefined {
                    VStack {
                        Spacer()
                        Text("loading")
                        Spacer()
                    }
                } else if self.status == .failure {
                    VStack {
                        Spacer()
                        Text("netowrk error, could not get metrics")
                    }
                } else {
                    MetricsView()
                }
            }
        }
        .onAppear {
            //self.userInfo.configureMetricsSnapshotListener()
            self.retrieveData { result in
                switch result {
                case .failure(let error):
                    self.status = .failure
                    self.errorString = error.localizedDescription
                    self.showAlert = true
                case .success( _):
                    self.status = .success
                }
            }
        }
    }
    
    private func retrieveData(completion: @escaping (Result<Bool, Error>) -> ()) {
        if self.userInfo.user.uid == "" { return }
        print("retrieving Metrics COntentView")
        // retrieve metrics
        FBFirestore.retrieveMetrics(uid: self.userInfo.user.uid) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let metrics):
                self.userInfo.metrics = metrics
                completion(.success(true))
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
