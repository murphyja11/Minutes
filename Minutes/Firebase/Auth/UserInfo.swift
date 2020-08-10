//
//  UserInfo.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/1/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserInfo: ObservableObject {
    
    // Is the user logged in, logged out, or undefined
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    // auth state is undefined when the user first launches the app
    // Published to monitor changes
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = .init(uid: "", name: "", email: "", metrics: FBUserMetrics(minutesMeditated: 0.0, topGenres: [], meditationsPerDay: 0.0), recommendations: [])
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        print("starting function configureFirebaseDidChange()")
        let currentUser = Auth.auth().currentUser
        print("Current User: \(String(describing: currentUser))")
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            print("starting Listener Handle execution")
            // TODO: - User can stay logged in even after account is deleted
            if user == nil {
                self.isUserAuthenticated = .signedOut
                print("User is nil. User is signed out. Ending Listener Handle execution")
                return
            }
            print("User is not nil.  Marking user to signed in")
            self.isUserAuthenticated = .signedIn
        })
    }
}
