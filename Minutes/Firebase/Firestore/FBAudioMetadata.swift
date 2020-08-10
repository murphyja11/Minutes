//
//  FBAudioMetadata.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/4/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

struct FBAudioMetadata {
    let uid: String
    let title: String
    let genre: String
    let description: String
    let length: String  // This is used to display the approximate time (ie 4m), so it does not need to be exact
    let filename: String
    let tags: [String]
    
    init(uid: String, title: String, genre: String, description: String, length: String, filename: String, tags: [String]) {
        print("Initializing AudioMetadata : AudioMetadata")
        self.uid = uid
        self.title = title
        self.genre = genre
        self.description = description
        self.length = length // In seconds
        self.filename = filename
        self.tags = tags
    }
}

extension FBAudioMetadata {
    init?(documentData: [String: Any]) {
        print("Initializing AudioMetadata using failable initializer : AudioMetadata")
        let uid = documentData[FBKeys.AudioMetadata.uid] as? String ?? ""
        let title = documentData[FBKeys.AudioMetadata.title] as? String ?? ""
        let genre = documentData[FBKeys.AudioMetadata.genre] as? String ?? ""
        let description = documentData[FBKeys.AudioMetadata.description] as? String ?? ""
        let length = documentData[FBKeys.AudioMetadata.length] as? String ?? ""
        let filename = documentData[FBKeys.AudioMetadata.filename] as? String ?? ""
        let tags = documentData[FBKeys.AudioMetadata.tags] as? [String] ?? []
    
        self.init(uid: uid, title: title, genre: genre, description: description, length: length, filename: filename, tags: tags)
    }
}


