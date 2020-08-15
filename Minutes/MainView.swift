//
//  MainView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/14/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI
import FirebaseAuth


struct MainView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var audioFile: AudioFile
    
    @State private var selection = 0
    @State var showAudioView: Bool = false
    @State var showSettings: Bool = false
    
    @State var errorString: String?
    @State var showAlert = false
    
    var body: some View {
        TabView(selection: $selection){
            HomeView(showAudioView: self.$showAudioView)
                .font(.title)
                .tabItem {
                    VStack {
                        if (self.selection == 0) {
                            Image(systemName: "circle.fill")
                        } else {
                            Image(systemName: "circle")
                        }
                        Text("Home")
                    }
                }
                .tag(0)
            MeView(showSettings: self.$showSettings)
                .font(.title)
                .tabItem {
                    VStack {
                        if (self.selection == 2) {
                            Image(systemName: "person.circle.fill")
                        } else {
                            Image(systemName: "person.circle")
                        }
                        Text("Me")
                    }
                }
                .tag(1)
        }
        .sheet(isPresented: self.$showAudioView) {
            AudioView()
                .environmentObject(self.userInfo)
                .environmentObject(self.audioFile)
        }
        .sheet(isPresented: self.$showSettings) {
            SettingsView(showThisView: self.$showSettings)
        }
        .onAppear {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("retrieving User")
            FBFirestore.retrieveFBUser(uid: uid) { (result) in
                switch result {
                    case .failure(let error):
                        self.errorString = error.localizedDescription
                        self.showAlert = true
                    case .success(let user):
                        self.userInfo.user = user
                        self.userInfo.getRecommendations { result in
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
            self.userInfo.configureMetricsSnapshotListener()
            print("retrieving Metrics COntentView")
            FBFirestore.retrieveFBMetrics(uid: uid) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let metrics):
                    self.userInfo.metrics.secondsListened = metrics.secondsListened
                    self.userInfo.metrics.numberOfMeditations = metrics.numberOfMeditations
                }
            }
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Retrieval Error"), message: Text(self.errorString ?? ""), dismissButton: .default(Text("Ok")))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
