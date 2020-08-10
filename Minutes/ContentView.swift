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
    @State private var selection = 0
    
 
    var body: some View {
        Group {
            if userInfo.isUserAuthenticated == .undefined {
                Text("loading...")
            } else if userInfo.isUserAuthenticated == .signedOut {
                SignupView()
            } else {
                TabView(selection: $selection){
                    HomeView()
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
                        print(error.localizedDescription)
                        // Display some kind of alert that the users account is corrupted
                    case .success(let user):
                        self.userInfo.user = user
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
