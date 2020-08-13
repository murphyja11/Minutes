//
//  FBMetrics.swift
//  Minutes
//
//  Created by Jack Murphy on 8/13/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

struct FBMetrics {
    var uid: String
    var secondsListened: Double
    var numberOfMeditations: Int
    
    init(uid: String, secondsListened: Double, numberOfMeditations: Int) {
        print("initializing FBUserMetrics : FBUser")
        self.uid = uid
        self.secondsListened = secondsListened
        self.numberOfMeditations = numberOfMeditations
    }
}

extension FBMetrics {
    init?(documentData: [String : Any]) {
        print("initializing FBUserMetrics using failable initializer : FBUser")
        let uid = documentData[FBKeys.Metrics.uid] as? String ?? ""
        let secondsListened = documentData[FBKeys.Metrics.secondsListened] as? Double ?? 0.0
        let numberOfMeditations = documentData[FBKeys.Metrics.numberOfMeditations] as? Int ?? 0
        
        // Make sure you also initialize any app specific properties if you have them

        self.init(uid: uid, secondsListened: secondsListened,
                  numberOfMeditations: numberOfMeditations
                  // Dont forget any app specific ones here too
        )
    }
}
