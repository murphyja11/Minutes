//
//  ContentView.swift
//  Minutes beta
//
//  Created by Jack Murphy on 8/9/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var audioFile: AudioFile
    
    @State private var selection = 0
    
    @State var errorString: String?
    @State var showAlert = false
    
    @State var showAudioView: Bool = false
 
    var body: some View {
        Group {
            if userInfo.isUserAuthenticated == .undefined {
                Text("loading...")
            } else if userInfo.isUserAuthenticated == .signedOut {
                SignupView()
            } else {
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
                    MeView()
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
            }
        }
        .onAppear {
            self.userInfo.configureFirebaseStateDidChange()
            guard let uid = Auth.auth().currentUser?.uid else { return }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
