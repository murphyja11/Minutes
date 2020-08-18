//
//  MetricsObject.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI
struct MetricsObject {
    var numberOfMeditations: Int
    var secondsListened: Double
    var genres: [String: Stats] //genre to stats
    var daily: [String: DailyMetric] // data to daily metrics
    
    init(dictionary dict: [String : Any]) {
        self.numberOfMeditations = dict["numberOfMeditations"] as? Int ?? 0
        self.secondsListened = dict["secondsListened"] as? Double ?? 0.0
        self.genres = MetricsObject.getGenres(dict["genres"])
        self.daily = MetricsObject.getDaily(dict["daily"])
    }
    
    init() {
        self.numberOfMeditations = 0
        self.secondsListened = 0
        self.genres = MetricsObject.self.getGenres(nil)
        self.daily = MetricsObject.self.getDaily(nil)
    }
   
    private static func getGenres(_ dict: Any?) -> [String: Stats] {
        guard let dict = dict as? [String : Any] else {
            return ["": Stats()]
        }
        var dictionary: [String: Stats] = [:]
        for (key, value) in dict {
            dictionary[key] = self.getStats(value)
        }
        return dictionary
    }
    
    private static func getStats(_ dict: Any?) -> Stats {
        guard let dict = dict as? [String : Any] else {
            return Stats(numberOfMeditations: 0, secondsListened: 0.0)
        }
        return Stats(numberOfMeditations: dict["numberOfMeditations"] as? Int ?? 0, secondsListened: dict["secondsListened"] as? Double ?? 0.0)
    }
    
    private static func getDaily(_ dict: Any?) -> [String: DailyMetric] {
        guard let dict = dict as? [String: Any] else {
            return ["": DailyMetric()]
        }
        var dictionary: [String: DailyMetric] = [:]
        for (key, value) in dict { // loop of date keys
            dictionary[key] = self.getStatsAndGenre(value) // returns a daily metric
        }
        return dictionary
    }
    
    private static func getStatsAndGenre(_ dict: Any?) -> DailyMetric {
        guard let dict = dict as? [String: Any] else {
            return DailyMetric()
        }
        return DailyMetric(numberOfMeditations: dict["numberOfMeditations"] as? Int ?? 0, secondsListened: dict["secondsListened"] as? Double ?? 0.0, genres: self.getGenres(dict["genres"]))
    }
    
    
    
    struct Stats: Codable {
        var numberOfMeditations: Int
        var secondsListened: Double
        
        init() {
            self.numberOfMeditations = 0
            self.secondsListened = 0.0
        }
        
        init(numberOfMeditations: Int, secondsListened: Double) {
            self.numberOfMeditations = numberOfMeditations
            self.secondsListened = secondsListened
        }
    }
    
    struct DailyMetric: Codable {
        var numberOfMeditations: Int
        var secondsListened: Double
        var genres: [String: Stats]
        
        init() {
            self.numberOfMeditations = 0
            self.secondsListened = 0.0
            self.genres = ["": Stats()]
        }
        
        init(numberOfMeditations: Int, secondsListened: Double, genres: [String: Stats]) {
            self.numberOfMeditations = numberOfMeditations
            self.secondsListened = secondsListened
            self.genres = genres
        }
    }
}
