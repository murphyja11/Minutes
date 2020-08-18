//
//  FBMetrics.swift
//  Minutes
//
//  Created by Jack Murphy on 8/13/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

//struct FBMetrics: Codable { // Hashable, Identifiable
//    var numberOfMeditations: Int
//    var secondsListened: Double
//    var genres: [String: Stats] // Genre string to the two number stats
//    var daily: [String: DailyMetric] // Date string to daily metrics
//
//    init(numberOfMeditations: Int, secondsListened: Double, genres: Genres, daily: DailyMetrics) {
//        self.secondsListened = secondsListened
//        self.numberOfMeditations = numberOfMeditations
//        self.genres = genres
//        self.daily = daily
//    }
//
//    struct Stats: Codable {
//        var numberOfMeditations: Int
//        var secondsListened: Double
//    }
//
//    struct DailyMetric: Codable {
//        var numberOfMeditations: Int
//        var secondsListened: Double
//        var genres: Dictionary<Genre, Stats>
//    }
//
//extension FBMetrics {
//    init?(documentData: [String : Any]) {
//        let numberOfMeditations = documentData[FBKeys.Metrics.numberOfMeditations] as? Int ?? 0
//        let secondsListened = documentData[FBKeys.Metrics.secondsListened] as? Double ?? 0.0
//        let genres = documentData[FBKeys.Metrics.genres] as? Dictionary<Genre, Stats> ?? [:]
//        // Make sure you also initialize any app specific properties if you have them
//
//        self.init(secondsListened: secondsListened,
//                  numberOfMeditations: numberOfMeditations
//        )
//    }
//}

