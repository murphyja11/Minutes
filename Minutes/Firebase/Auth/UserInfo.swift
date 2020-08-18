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
    
    enum FBAuthState {
        // Is the user logged in, logged out, or undefined
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenticated: FBAuthState = .undefined
    
    @Published var user: FBUser = .init(uid: "", name: "", email: "", likes: [], recommendations: [])
    @Published var metrics: FBMetrics = .init(secondsListened: 0.0, numberOfMeditations: 0, activity: [])
    @Published var recommendations: [FBAudioMetadata] = []
    
    @Published var reloading: Bool = false {
        didSet {
            if !oldValue && reloading {
                self.getRecommendationsMetadata { result in
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
        let currentUser = Auth.auth().currentUser
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            // TODO: - User can stay logged in even after account is deleted
            if user == nil {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
        })
        
        // TODO: - Add Metrics Snapshot Listener HERE!?!?!?
    }
    
    
    // called on appear and reaload, fetches recommendation uids and afterwards fetches the corresponding metadata
    func getRecommendationsMetadata (completion: @escaping (Result<Bool, Error>) -> ()) {
        var uid: String? = self.user.uid
        if uid == "" {
            guard let authUID = Auth.auth().currentUser?.uid else {
                completion(.failure(FirestoreError.noUser))
                self.reloading = false
                return
            }
            uid = authUID
        }
        if uid == nil {
            completion(.failure(FirestoreError.noUser))
        } else {
            FBFirestore.retrieveRecommendations(uid: uid!) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    // If there are no recommendations available, check the user collection
                    // NOTE -> Phasing out getting recommendations from User collection, instead from Recommendation Collection
                    self.reloadUserInfo { result in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let user):
                            self.initializeRecommendationMetadata(recs: user.recommendations) { result in
                                switch result {
                                case .failure(let error):
                                    completion(.failure(error))
                                case .success( _):
                                    completion(.success(true))
                                }
                            }
                        }
                    }
                case .success(let recs):
                    self.initializeRecommendationMetadata(recs: recs.array) { result in
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
    }
    
    // This function is super keys, turns recommendation UIDs into AudioMetadata Objects
    // But is it in the right play?????????
    func initializeRecommendationMetadata(recs array: [String], completion: @escaping (Result<Bool, Error>) -> ()) {
        // In case the array was full before
        self.recommendations = []
        var error: Error?
        let group = DispatchGroup()
        for uid in array {
            group.enter()
            FBFirestore.retrieveAudioMetadata(uid: uid) { result in
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
    
    // Backup -> if recommendations collection doesn't have recommendations, check here.
    // This Method will get phased out!!!!
    private func reloadUserInfo(completion: @escaping (Result<FBUser, Error>) -> ()) {
        if self.user.uid == "" {
            completion(.failure(FirestoreError.noUser))
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
}
