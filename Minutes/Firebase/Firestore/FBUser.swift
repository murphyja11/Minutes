//
//  FBUser.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

struct FBUser {
    let uid: String
    let name: String
    let email: String
    let metrics: FBUserMetrics
    let recommendations: [String] // Recommendations stored as and Array of AudioMetadata UIDs
    
    // App Specific properties can be added here
    
    init(uid: String, name: String, email: String, metrics: FBUserMetrics, recommendations: [String]) {
        print("initializing FBUser : FBUser")
        self.uid = uid
        self.name = name
        self.email = email
        self.metrics = metrics
        self.recommendations = recommendations
    }

}

extension FBUser {
    init?(documentData: [String : Any]) {
        print("initializing FBUser using failable initializer : FBUser")
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let name = documentData[FBKeys.User.name] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        let metrics = documentData[FBKeys.User.metrics] as? FBUserMetrics ?? FBUserMetrics(documentData: [String: Any]())
        let recommendations = documentData[FBKeys.User.recommendations] as? [String] ?? []

        
        self.init(uid: uid,
            name: name,
            email: email,
            metrics: metrics ?? FBUserMetrics(documentData: [String: Any]())!,
            recommendations: recommendations
        )
    }
    
    static func dataDict(uid: String, name: String, email: String) -> [String: Any] {
        var data: [String: Any]
        
        // If name is not "" this must be a new entry so add all first time data
        if name != "" {
            print("initializing User Data : FBUser.dataDict")
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.name: name,
                FBKeys.User.email: email,
                FBKeys.User.metrics: ["secondsListened": 0.0, "topGenres": [], "meditationsPerDay": 0.0],
                FBKeys.User.recommendations: [],
                // Again, include any app specific properties that you want stored on creation
            ]
        } else {
            // This is a subsequent entry so only merge uid and email so as not
            // to overrwrite any other data.
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.email: email
            ]
        }
        return data
    }
}

struct FBUserMetrics {
    let secondsListened: Double
    let topGenres: [String]
    let numberOfMeditations: Int
    
    init(secondsListened: Double, topGenres: [String], numberOfMeditations: Int) {
        print("initializing FBUserMetrics : FBUser")
        self.secondsListened = secondsListened
        self.topGenres = topGenres
        self.numberOfMeditations = numberOfMeditations
    }
}

extension FBUserMetrics {
    init?(documentData: [String : Any]) {
        print("initializing FBUserMetrics using failable initializer : FBUser")
        let secondsListened = documentData[FBKeys.Metrics.secondsListened] as? Double ?? 0.0
        let topGenres = documentData[FBKeys.Metrics.topGenres] as? [String] ?? ["none"]
        let numberOfMeditations = documentData[FBKeys.Metrics.numberOfMeditations] as? Int ?? 0
        
        // Make sure you also initialize any app specific properties if you have them

        self.init(secondsListened: secondsListened,
                  topGenres: topGenres,
                  numberOfMeditations: numberOfMeditations
                  // Dont forget any app specific ones here too
        )
    }
}
