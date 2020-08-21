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
    var timeData: [SingeItem]
    
    init(dictionary dict: [String : Any]) {
        self.numberOfMeditations = dict["numberOfMeditations"] as? Int ?? 0
        self.secondsListened = dict["secondsListened"] as? Double ?? 0.0
        self.genres = MetricsObject.getGenres(dict["genres"])
        self.timeData = dict["timeData"] as? [SingleItem] ?? []
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
    
    //private static func getSingleItems(_ array: Any?) ->
    
    struct SingleItem: Codable {
        var time: Date
        var secondsListened: Double
        var genre: String
        
        init(time: Date, secondsListened: Double, genre: String) {
            self.time = time
            self.secondsListened = secondsListened
            self.genre = genre
        }
    }
}
