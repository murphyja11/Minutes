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
    init(secondsListened: Double, numberOfMeditations: Int) {
        self.secondsListened = secondsListened
        self.numberOfMeditations = numberOfMeditations
    }
}

extension FBMetrics {
    init?(documentData: [String : Any]) {
        let secondsListened = documentData[FBKeys.Metrics.secondsListened] as? Double ?? 0.0
        let numberOfMeditations = documentData[FBKeys.Metrics.numberOfMeditations] as? Int ?? 0
        // Make sure you also initialize any app specific properties if you have them

        self.init(secondsListened: secondsListened,
                  numberOfMeditations: numberOfMeditations
        )
    }
}

