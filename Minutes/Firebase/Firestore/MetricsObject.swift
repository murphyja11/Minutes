//
//  MetricsObject.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct MetricsObject {
    var numberOfMeditations: Int
    var secondsListened: Double
    var genres: [String: Stats] //genre to stats
    var timeData: [SingleItem]
    
    init(dictionary dict: [String : Any]) {
        self.numberOfMeditations = dict["numberOfMeditations"] as? Int ?? 0
        self.secondsListened = dict["secondsListened"] as? Double ?? 0.0
        self.genres = MetricsObject.getGenres(dict["genres"])
        self.timeData = MetricsObject.getTimeData(dict["timeData"])
    }
    
    init() {
        self.numberOfMeditations = 0
        self.secondsListened = 0
        self.genres = MetricsObject.self.getGenres(nil)
        self.timeData = []
    }
   
    private static func getGenres(_ dict: Any?) -> [String: Stats] {
        guard let dict = dict as? [String : Any] else {
            return [:]
        }
        var dictionary: [String: Stats] = [:]
        for (key, value) in dict {
            dictionary[key] = self.getStats(value)
        }
        return dictionary
    }
    
    private static func getTimeData(_ array: Any?) -> [SingleItem] {
        guard let array = array as? [Any] else {
            print("Error typecasting Metrics Time Data")
            return []
        }
        
        var arr: [SingleItem] = []
        for itemInArray in array {
            if let item = itemInArray as? [String: Any] {
                //let time = item["time"]
                let timestamp = item["time"] as? Timestamp ?? Timestamp(seconds:0, nanoseconds:0)
                let date = timestamp.dateValue()
                let secondsListened = item["secondsListened"] as? Double ?? -1.0
                let genre = item["genre"] as? String ?? ""
                let singleItem = SingleItem(time: date, secondsListened: secondsListened, genre: genre)
                arr.append(singleItem)
            }
        }
        return arr
    }
    
    private static func getStats(_ dict: Any?) -> Stats {
        guard let dict = dict as? [String : Any] else {
            return Stats(numberOfMeditations: 0, secondsListened: 0.0)
        }
        return Stats(numberOfMeditations: dict["numberOfMeditations"] as? Int ?? 0, secondsListened: dict["secondsListened"] as? Double ?? 0.0)
    }
    
    //private static func getSingleItems(_ array: Any?) ->
    
    struct SingleItem { //Codable?
        var time: Date
        var secondsListened: Double
        var genre: String
        
        init(time: Date, secondsListened: Double, genre: String) {
            self.time = time
            self.secondsListened = secondsListened
            self.genre = genre
        }
        
        func getKeysValue(key: String) -> Double {
            if key == "secondsListened"{
                return self.secondsListened
            } else if key == "numberOfMeditations" {
                return 1
            } else {
                return -1
            }
        }
    }
    
    struct Stats {
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
        
        func getKeysValue(_ key: String) -> Double {
            if key == "numberOfMeditations" {
                return Double(self.numberOfMeditations)
            } else if key == "secondsListened" {
                return self.secondsListened
            } else {
                return -1
            }
        }
    }
    
}
