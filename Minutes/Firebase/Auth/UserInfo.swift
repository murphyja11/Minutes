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
    @Published var user: FBUser = .init(uid: "", name: "", email: "", metrics: FBUserMetrics(minutesMeditated: 0.0, topGenres: [], numberOfMeditations: 0), recommendations: [])
    @Published var reloading: Bool = false {
        didSet {
            if !oldValue && reloading {
                self.reloadUser { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let user):
                        self.user = user
                    }
                }
            }
        }
    }

    
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
    
    
    func reloadUser(completion: @escaping (Result<FBUser, Error>) -> ()) {
        if self.user == nil {
            completion(.failure(FireStoreError.noUser))
            self.reloading = false
            return
        }
        FBFirestore.retrieveFBUser(uid: self.user.uid) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                self.reloading = false
            case .success(let user):
                completion(.success(user))
                self.reloading = false
            }
        }
    }
}
