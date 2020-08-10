//
//  FBFirestore.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//
import FirebaseFirestore

enum FBFirestore {
    
    static func retrieveAudioMetadata(uid: String, completion: @escaping (Result<FBAudioMetadata, Error>) -> ()) {
        print("retrieving FBAudioMetadata : FBFirestore")
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.audioMetadata)
            .document(uid)
        getDocument(for: reference) { result in
            switch result {
            case .success(let data):
                guard let metadata = FBAudioMetadata(documentData: data) else {
                    completion(.failure(FireStoreError.noAudioMetadata))
                    return
                }
                completion(.success(metadata))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func retrieveFBUser(uid: String, completion: @escaping (Result<FBUser, Error>) -> ()) {
        print("retrieving FBUser : FBFirestore.retrieveFBUser")
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        getDocument(for: reference) { (result) in
            switch result {
            case .success(let data):
                guard let user = FBUser(documentData: data) else {
                    completion(.failure(FireStoreError.noUser))
                    return
                }
                print("retrieved FBUser : FBFirestore.retrieveFBUser")
                completion(.success(user))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
    }
    
    static func mergeFBUser(_ data: [String: Any], uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        print("starting merge FBUser : FBFirestore.mergeFBUser")
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        reference.setData(data, merge: true) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            print("merged FBUser : FBFirestore.mergeFBUser")
            completion(.success(true))
        }
    }
    
    /*static func updateFBUserLikes(uid: String, data: [String: Any], completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        reference.setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }*/
    
    fileprivate static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        print("Getting Document : FBFirestore.getDocument")
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(FireStoreError.noDocumentSnapshot))
                return
            }
            guard let data = documentSnapshot.data() else {
                completion(.failure(FireStoreError.noSnapshotData))
                return
            }
            print("Got Document : FBFirestore.getDocument")
            completion(.success(data))
        }
    }
}
