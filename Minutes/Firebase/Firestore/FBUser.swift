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
    let recommendations: [String] // Recommendations stored as and Array of AudioMetadata UIDs
    
    // App Specific properties can be added here
    
    init(uid: String, name: String, email: String, recommendations: [String]) {
        print("initializing FBUser : FBUser")
        self.uid = uid
        self.name = name
        self.email = email
        self.recommendations = recommendations
    }

}

extension FBUser {
    init?(documentData: [String : Any]) {
        print("initializing FBUser using failable initializer : FBUser")
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let name = documentData[FBKeys.User.name] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        let recommendations = documentData[FBKeys.User.recommendations] as? [String] ?? []

        
        self.init(uid: uid,
            name: name,
            email: email,
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

struct FBMetrics {
    let secondsListened: Double
    let numberOfMeditations: Int
    
    init(secondsListened: Double, numberOfMeditations: Int) {
        print("initializing FBUserMetrics : FBUser")
        self.secondsListened = secondsListened
        self.numberOfMeditations = numberOfMeditations
    }
}

extension FBMetrics {
    init?(documentData: [String : Any]) {
        print("initializing FBUserMetrics using failable initializer : FBUser")
        let secondsListened = documentData[FBKeys.Metrics.secondsListened] as? Double ?? 0.0
        let numberOfMeditations = documentData[FBKeys.Metrics.numberOfMeditations] as? Int ?? 0
        
        // Make sure you also initialize any app specific properties if you have them

        self.init(secondsListened: secondsListened,
                  numberOfMeditations: numberOfMeditations
                  // Dont forget any app specific ones here too
        )
    }
}
