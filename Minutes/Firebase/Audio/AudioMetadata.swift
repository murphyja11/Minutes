//
//  AudioMetadata.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/5/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

class AudioMetadata: ObservableObject {
    @Published var data: FBAudioMetadata = .init(uid: "", title: "", genre: "", description: "", length: "", filename: "", tags: [])
    @Published var state: State = .undefined
    
    enum State {
        case undefined, failed, success
    }
    
    init(uid: String) {
        FBFirestore.retrieveAudioMetadata(uid: uid) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.state = .failed
            case .success(let data):
                self.data = data
                self.state = .success
            }
        }
    }
}

