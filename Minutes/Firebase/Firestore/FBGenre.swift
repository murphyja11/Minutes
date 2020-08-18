//
//  FBGenres.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FBGenre: Hashable {
    var genre: String
    var references: [DocumentReference?]
    
    init(genre: String, references: [DocumentReference?]) {
        self.genre = genre
        self.references = references
    }
}

extension FBGenre {
    init?(documentData: [String : Any]) {
        let genre = documentData[FBKeys.Genre.genre] as? String ?? ""
        let references = documentData[FBKeys.Genre.references] as? [DocumentReference?] ?? []
        
        self.init(genre: genre, references: references)
    }
}
