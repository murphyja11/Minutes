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
    let likes: [String] // UIDs for liked meditations
    let recommendations: [String] // Recommendations stored as and Array of AudioMetadata UIDs
    let accountCreated: Date
        
    init(uid: String, name: String, email: String, likes: [String], recommendations: [String], accountCreated: Date) {
        self.uid = uid
        self.name = name
        self.email = email
        self.likes = likes
        self.recommendations = recommendations
        self.accountCreated = accountCreated
    }

}

extension FBUser {
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let name = documentData[FBKeys.User.name] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        let likes = documentData[FBKeys.User.likes] as? [String] ?? []
        let recommendations = documentData[FBKeys.User.recommendations] as? [String] ?? []
        let accountCreated = documentData[FBKeys.User.accountCreated] as? Date ?? Date()

        
        self.init(uid: uid,
            name: name,
            email: email,
            likes: likes,
            recommendations: recommendations,
            accountCreated: accountCreated
        )
    }
    
    static func dataDict(uid: String, name: String, email: String) -> [String: Any] {
        var data: [String: Any]
        
        // If name is not "" this must be a new entry so add all first time data
        if name != "" {
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.name: name,
                FBKeys.User.email: email,
                FBKeys.User.likes: [],
                FBKeys.User.recommendations: [],
                FBKeys.User.accountCreated: Date()
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

