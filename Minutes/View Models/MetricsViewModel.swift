//
//  MetricsViewModel.swift
//  Minutes
//
//  Created by Jack Murphy on 8/20/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//
import SwiftUI
import Foundation
import Combine

class MetricsViewModel: ObservableObject {
    //var objectWillChange = ObservableObjectPublisher()
    @Published var metrics: MetricsObject = .init() //{willSet {objectWillChange.send()}}
    @Published var status: MetricsStatus = .undefined
    @Published var colorOfGenre: [String: Color] = ["Breathing": Color.blue, "Body Scan": Color(red: 0, green: 0.9, blue: 1)]
    //[Color(red: 1.0, green: 0.6, blue: 0), Color(red: 0, green: 0.9, blue: 1), Color(red: 0, green: 0.5, blue: 1), Color(red: 1.0, green: 0.6, blue: 1.0)]
    
    enum MetricsStatus {
        case undefined, success, failure
    }
    
    func getMetrics(uid: String) {
        FBFirestore.retrieveMetrics(uid: uid) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.status = .failure
            case .success(let metrics):
                self.status = .success
                self.metrics = metrics
            }
        }
    }
    
    func getDataRange(days: Int) -> [MetricsObject.SingleItem] {
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let dateInCurrentTimeZone = Date(timeIntervalSinceNow: Double(secondsFromGMT))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = .current
        let stringDate = formatter.string(from: Date())
        
        var year: String?
        var month: String?
        var day: String?
        
        let regex = try? NSRegularExpression(pattern: "(?<year>\\d{4})/(?<month>\\d{2})/(?<day>\\d{2})", options: [])
        guard let regx = regex else {
            print("Regex matched no dates")
            return []
        }
        if let match = regx.firstMatch(in: stringDate, options: [], range: NSRange(location: 0, length: stringDate.utf16.count)) {
            if let yearRange = Range(match.range(withName: "year"), in: stringDate) {
                year = String(stringDate[yearRange])
            }
            if let monthRange = Range(match.range(withName: "month"), in: stringDate) {
                month = String(stringDate[monthRange])
            }
            if let dayRange = Range(match.range(withName: "day"), in: stringDate) {
                day = String(stringDate[dayRange])
            }
        }
        var midnightInGMT: Date?
        if year != nil, month != nil, day != nil {
            let midnightString = "\(year!)-\(month!)-\(day!) 00:00:00"
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let midnight = formatter.date(from: midnightString) {
                let secondsInThisDay = Double(dateInCurrentTimeZone.timeIntervalSince(midnight))
                let secondsInDay = Double(86400)
                midnightInGMT = Date() - secondsInThisDay - secondsInDay * Double(days - 1)
            }
        }
        var array: [MetricsObject.SingleItem] = []
        if midnightInGMT != nil {
            let count = self.metrics.timeData.count
            for int in 0..<count {
                let index = (count - 1 - int)
                let item = self.metrics.timeData[index]
                if item.time > midnightInGMT! {
                    array.append(item)
                }
            }
        }
        return array
    }
    
    func getDataSum(days: Int, key: String) -> Double {
        var sum = 0.0
        let array = getDataRange(days: days)
        
        for item in array {
            sum = sum + item.getKeysValue(key: key)
        }
        return sum
    }
    
    func getDataSum(days: Int, key: String, genre: String) -> Double {
        var sum = 0.0
        let array = getDataRange(days: days)
        
        for item in array {
            if item.genre == genre {
                sum = sum + item.getKeysValue(key: key)
            }
        }
        return sum
    }
    
    func getHourlyData(days: Int, key: String, timeScale: Int) -> [[String : Double]] {
        let array = self.getDataRange(days: days)
        
        var dictArray: [[String : Double]] = Array(repeating: [:], count: timeScale)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = .current
        
        if days == 1 {
            let regex = try? NSRegularExpression(pattern: "(?<hour>\\d{2}):\\d{2}:\\d{2}", options: [])
            guard let regx = regex else {
                print("Regex matched no dates")
                return []
            }
            
            for item in array {
                let stringDate = formatter.string(from: item.time)
                
                if let match = regx.firstMatch(in: stringDate, options: [], range: NSRange(location: 0, length: stringDate.utf16.count)) {
                    if let hourRange = Range(match.range(withName: "hour"), in: stringDate) {
                        let hour = Int(stringDate[hourRange]) ?? 0
                        let index = Int(floor(Double(hour) * Double(timeScale) / Double(24)))
                        if let currentDictValue = dictArray[index][item.genre] {
                            dictArray[index][item.genre] = currentDictValue + item.getKeysValue(key: key)
                        } else {
                            dictArray[index][item.genre] = item.getKeysValue(key: key)
                        }
                    }
                }
            }
        } else if days == 7 {
            let regex = try? NSRegularExpression(pattern: "\\d{4}/\\d{2}/(?<day>\\d{2})", options: [])
            guard let regx = regex else {
                print("Regex matched no dates")
                return []
            }
            let stringDate = formatter.string(from: array[0].time)
            var max = 0
            if let match = regx.firstMatch(in: stringDate, options: [], range: NSRange(location: 0, length: stringDate.utf16.count)) {
                if let dayRange = Range(match.range(withName: "day"), in: stringDate) {
                    max = Int(stringDate[dayRange]) ?? 0
                }
            }
            var arrayOfBigDays: [Int] = []
            
            for item in array {
                let stringDate = formatter.string(from: item.time)
            
                if let match = regx.firstMatch(in: stringDate, options: [], range: NSRange(location: 0, length: stringDate.utf16.count)) {
                    if let dayRange = Range(match.range(withName: "day"), in: stringDate) {
                        let day = Int(stringDate[dayRange]) ?? 0
                        var index: Int = 0
                        if max - day >= 0 {
                            index = 6 - (max - day)
                        } else {
                            arrayOfBigDays.append(day)
                            index = 6 - (max + (arrayOfBigDays[0] - day))
                        }
                        if let currentDictValue = dictArray[index][item.genre] {
                            dictArray[index][item.genre] = currentDictValue + item.getKeysValue(key: key)
                        } else {
                            dictArray[index][item.genre] = item.getKeysValue(key: key)
                        }
                    }
                }
            }
        }
        
        return dictArray
    }
}
