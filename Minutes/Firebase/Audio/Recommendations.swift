//
//  Recommendations.swift
//  Minutes
//
//  Created by Jack Murphy on 8/13/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

class Recommendations: ObservableObject {
    @Published var data: [FBAudioMetadata] = []
    @Published var status: RecommendationsStatus = .undefined
    
    enum RecommendationsStatus {
        case undefined, success, failed
    }
    
    init() {}
    
    func initialize (_ array: [String]?) {
        guard let array = array else { return }
        self.data = []
        for uid in array {
            retrieveMetadata(uid: uid) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let metadata):
                    self.data.append(metadata)
                }
            }
        }
        self.status = .success
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
