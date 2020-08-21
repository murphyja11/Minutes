//
//  FBFirestore.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//
import FirebaseFirestore

enum FBFirestore {
    
    static func retrieveFBUser(uid: String, completion: @escaping (Result<FBUser, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        getDocument(for: reference) { (result) in
            switch result {
            case .success(let data):
                guard let user = FBUser(documentData: data) else {
                    completion(.failure(FirestoreError.noUser))
                    return
                }
                completion(.success(user))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func retrieveAudioMetadata(uid: String, completion: @escaping (Result<FBAudioMetadata, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.audioMetadata)
            .document(uid)
        getDocument(for: reference) { result in
            switch result {
            case .success(let data):
                guard let metadata = FBAudioMetadata(documentData: data) else {
                    completion(.failure(FirestoreError.noAudioMetadata))
                    return
                }
                completion(.success(metadata))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func retrieveRecommendations(uid: String, completion: @escaping (Result<FBRecommendations, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.recommendations)
            .document(uid)
        getDocument(for: reference) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let recs = FBRecommendations(documentData: data) else {
                    completion(.failure(FirestoreError.noRecommendations))
                    return
                }
                completion(.success(recs))
            }
        }
    }

    
    static func retrieveGenres(completion: @escaping (Result<[FBGenre], Error>) -> ()){
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.genres)
            .document("genres")
        getDocument(for: reference) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                var array: [FBGenre] = []
                for (key, value) in data {
                    if let value = value as? [String: Any] {
                        array.append(FBGenre(genre: key, references: value["references"] as? [DocumentReference?] ?? []))
                    }
                }
                completion(.success(array))
            }
        }
    }
    
    static func retrieveMetrics(uid: String, completion: @escaping (Result<MetricsObject, Error>) -> ()) {
        let reference = Firestore
                    .firestore()
                    .collection(FBKeys.CollectionPath.metrics)
                    .document(uid)
        getDocument(for: reference) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let dictionary):
                completion(.success(MetricsObject(dictionary: dictionary)))
            }
        }
    }
    
    //static func mapMetricsDictionaryToObject
    
    static func mergeFBUser(_ data: [String: Any], uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        reference.setData(data, merge: true) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            print("Merged User:\n\(data)\n")
            completion(.success(true))
        }
    }
    
    static func sendAudioEvent(user_uid: String, audio_metadata: FBAudioMetadata?, secondsListened: Double, percListened: Double, data: [Bool], completion: @escaping (Result<Bool, Error>) -> ()) {
        print("Sending Audio Event")
        var ref: DocumentReference? = nil
        guard let metadata = audio_metadata else {
            completion(.failure(FirestoreError.noMetadata))
            return
        }
        ref = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.events)
            .addDocument(data: [
                    "type": "audio_event",
                    "user_uid": user_uid,
                    "audio_metadata": [
                        "uid": metadata.uid,
                        "title": metadata.title,
                        "description": metadata.description,
                        "genre": metadata.genre,
                        "length": metadata.length,
                        "tags": metadata.tags
                    ],
                    "secondsListened": secondsListened,
                    "percListened": percListened,
                    "didPause": data[0],
                    "didStall": data[1],
                    "didRewind": data[2],
                    "didFastForward": data[3],
                    "didSeek": data[4],
                    "time": Date(),
                    "usersCurrentTime": Date().description(with: .current)
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    }
    
    static func sendLikeEvent(user_uid: String, audio_uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        print("Sending Like Event")
        var ref: DocumentReference? = nil
        ref = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.events)
            .addDocument(data: [
                "type": "like_event",
                "user_uid": user_uid,
                "audio_uid": audio_uid,
                "time": Date(timeIntervalSinceNow: Double(TimeZone.current.secondsFromGMT()))
            ]) { error in
                
        }
    }
    
    static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        print("starting network call for \(reference.path)")
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                print("ending network call for " + reference.path)
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                print("ending network call for " + reference.path)
                completion(.failure(FirestoreError.noDocumentSnapshot))
                return
            }
            guard let data = documentSnapshot.data() else {
                print("ending network call for " + reference.path)
                completion(.failure(FirestoreError.noSnapshotData))
                return
            }
            if let data = documentSnapshot.data() {
                print("ending network call for " + reference.path)
                print("got data:\n\(data)\n")
                completion(.success(data))
                return
            }
            print("ending network call for " + reference.path)
            completion(.failure(FirestoreError.noSnapshotData))
            return
        }
    }
}
