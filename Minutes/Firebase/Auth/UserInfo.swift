//
//  UserInfo.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/1/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserInfo: ObservableObject {
    
    // Is the user logged in, logged out, or undefined
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    // auth state is undefined when the user first launches the app
    // Published to monitor changes
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = .init(uid: "", name: "", email: "", recommendations: [])
    @Published var metrics: FBMetrics = .init(secondsListened: 0, numberOfMeditations: 0)
    @Published var recommendations: [FBAudioMetadata] = []
    
    @Published var reloading: Bool = false {
        didSet {
            if !oldValue && reloading {
                print(self.reloading)
                self.getNewRecommendations() { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.reloading = false
                    case .success( _):
                        self.reloading = false
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
    
    func configureMetricsSnapshotListener() {
        if self.user.uid == "" { return }
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.metrics)
            .document(self.user.uid)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let document = documentSnapshot else {
                    print("Metrics document was empty")
                    return
                }
                guard let data = document.data() else {
                    print("Metrics document was empty")
                    return
                }
                guard let metrics = FBMetrics(documentData: data) else {
                    print("Metrics document was empty")
                    return
                }
                self.metrics = metrics
        }
    }
    
    func getRecommendations (completion: @escaping (Result<Bool, Error>) -> ()) {
        self.initializeRecommendationMetadata(user: user) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                completion(.success(true))
            }
        }
    }
    
    // called on reload, to re-fetch all user info to get new recommendations
    func getNewRecommendations (completion: @escaping (Result<Bool, Error>) -> ()) {
        self.reloadUserInfo { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                self.initializeRecommendationMetadata(user: user) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success( _):
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    private func reloadUserInfo(completion: @escaping (Result<FBUser, Error>) -> ()) {
        if self.user.uid == "" {
            completion(.failure(FireStoreError.noUser))
            self.reloading = false
            return
        }
        FBFirestore.retrieveFBUser(uid: self.user.uid) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                completion(.success(user))
            }
        }
    }
    
    private func initializeRecommendationMetadata(user: FBUser, completion: @escaping (Result<Bool, Error>) -> ()) {
        let array = user.recommendations
        self.recommendations = []
        var error: Error?
        let group = DispatchGroup()
        for uid in array {
            group.enter()
            retrieveMetadata(uid: uid) { result in
                switch result {
                case .failure(let err):
                    error = err
                    group.leave()
                case .success(let metadata):
                    self.recommendations.append(metadata)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
    private func retrieveMetadata (uid: String, completion: @escaping (Result<FBAudioMetadata, Error>) -> ()) {
        FBFirestore.retrieveAudioMetadata(uid: uid) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let metadata):
                completion(.success(metadata))
            }
        }
    }
}
