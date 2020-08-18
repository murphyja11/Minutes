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
        static let events = "events"
        static let metrics = "metrics"
        static let recommendations = "recommendations"
    }
    
    enum User {
        static let uid = "uid"
        static let name = "name"
        static let email = "email"
        static let likes = "likes"
        static let recommendations = "recommendations"
        // Add app specific keys here
    }
    
    enum Recommendations {
        static let array = "array"
    }
    
    enum Metrics {
        static let secondsListened = "secondsListened"
        static let secondsOverTime = "secondsOverTime"
        static let numberOfMeditations = "numberOfMeditations"
        static let meditationsOverTime = "meditationsOverTime"
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
    
    enum Event {
        static let type = "type"
        static let user = "user"
        static let audio = "audio"
        static let secondsListened = "secondsListened"
        static let percListened = "percListened"
        static let time = "time"
    }
}
