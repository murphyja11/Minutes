//
//  FBKeys.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation
enum FBKeys {
    
    enum CollectionPath {
        static let users = "users"
        static let audioMetadata = "audio_metadata"
    }
    
    enum User {
        static let uid = "uid"
        static let name = "name"
        static let email = "email"
        static let metrics = "metrics"
        static let recommendations = "recommendations"
        // Add app specific keys here
    }
    
    enum Metrics {
        static let minutesMeditated = "minutesMeditated"
        static let topGenres = "topGenres"
        static let numberOfMeditations = "numberOfMeditations"
    }
    
    enum AudioMetadata {
        static let uid = "uid"
        static let title = "title"
        static let genre = "genre"
        static let description = "description"
        static let length = "length"
        static let filename = "filename"
        static let tags = "tags"
    }
}
