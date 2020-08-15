//
//  FBRecommendations.swift
//  Minutes
//
//  Created by Jack Murphy on 8/15/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

struct FBRecommendations {
    var array: [String]
    
    init(array: [String]) {
        self.array = array
    }
}

extension FBRecommendations {
    init?(documentData: [String : Any]) {
        let array = documentData[FBKeys.Recommendations.array] as? [String] ?? []

        self.init(array: array)
    }
}
