//
//  FBGenres.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FBGenre {
    var genre: String
    var references: [DocumentReference]
    
    init(genre: String, reference: [DocumentReference]) {
        self.genre = genre
        self.references = reference
    }
}

extension FBGenre {
    init?(documentData: [String : Any]) {
        self.genre = documentData[FBKeys.Genre.genre] as? String ?? ""
        self.references = documentData[FBKeys.Genre.reference] as? DocumentReference? ?? nil
        
        self.init(genre: genre, reference: reference)
    }
}
