//
//  FBMetrics.swift
//  Minutes
//
//  Created by Jack Murphy on 8/13/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

struct FBMetrics {
    var secondsListened: Double
    var numberOfMeditations: Int
    var activity: [FBActivity]
    
    init(secondsListened: Double, numberOfMeditations: Int, activity: [FBActivity]) {
        self.secondsListened = secondsListened
        self.numberOfMeditations = numberOfMeditations
        self.activity = activity
    }
}

extension FBMetrics {
    init?(documentData: [String : Any]) {
        let secondsListened = documentData[FBKeys.Metrics.secondsListened] as? Double ?? 0.0
        let numberOfMeditations = documentData[FBKeys.Metrics.numberOfMeditations] as? Int ?? 0
        let activity = documentData[FBKeys.Metrics.activity] as? [FBActivity] ?? []
        // Make sure you also initialize any app specific properties if you have them

        self.init(secondsListened: secondsListened,
                  numberOfMeditations: numberOfMeditations,
                  activity: activity
                  // Dont forget any app specific ones here too
        )
    }
}

struct FBActivity: Hashable {
    var time: Date
    var metadata: FBAudioMetadata
    
    init(time: Date, metadata: FBAudioMetadata) {
        self.time = time
        self.metadata = metadata
    }
}

//extension FBActivity {
//    init?(documentData: [String : Any]) {
//        let time = documentData[FBKeys.Metrics.activity.time] as? Date ?? Date()
//        let metadata = documentData[FBKeys.Metrics.activity.metadata] as? FBAudioMetadata ?? nil
//    }
//}

