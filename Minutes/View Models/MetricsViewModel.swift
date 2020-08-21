//
//  MetricsViewModel.swift
//  Minutes
//
//  Created by Jack Murphy on 8/20/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import Combine

class MetricsViewModel: ObservableObject {
    //var objectWillChange = ObservableObjectPublisher()
    @Published var metrics: MetricsObject = .init() //{willSet {objectWillChange.send()}}
    @Published var status: MetricsStatus = .undefined
    
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
        let dateInCurrentTimeZone = Date(timeIntervalSinceNow: secondsFromGMT)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = .current
        let stringDate = formatter.string(Date())
        
        var year: String?
        var month: String?
        var day: String?
        
        let regex = NSRegularExpression(pattern: "(?<year>\\d){4}-(?<month>\\d){2}-(?<day>\\d){2}", options: [])
        if let match = regex.firstMatch(in: stringDate, options: [], range: NSRange(location: 0, length: stringDate.utf16.count)) {
            if let yearRange = Range(match.range(withName: "year")) {
                year = Int(stringDate[yearRange])
            }
            if let monthRange = Range(match.range(withName: "month")) {
                month = Int(stringDate[monthRange])
            }
            if let dayRange = Range(match.range(withName: "day")) {
                let day = Int(stringDate[monthRange])
            }
        }
        var midnightInGMT = Date?
        if year != nil, month != nil, day != nil {
            let midnightString = "\(year)-\(month)-\(day) 00:00:00 +0000"
            if let midnight = formatter.date(from: midnightString) {
                let secondsInThisDay = Double(midnight.timeIntervalSince(dateInCurrentTimeZone))
                let secondsInDay = Double(86400)
                midnightInGMT = Date() - secondsInThisDay - secondsInDay * (days - 1)
            }
        }
        let array: [MetricsObject.SingleItem] = []
        if midnightInGMT != nil {
            let count = self.metrics.timeData.count
            for 0..<count { int in
                let index = count - 1 - int
                let item = self.metrics.timeData[index]
                if item.time < midnightInGMT {
                    array.append(item)
                }
            }
        }
        return array
    }
    
    func getDataSum(days: Int, key: String, genre: String?) -> Double {
        var sum = 0.0
        let array = getDataRange(days: days)
        
        for item in array {
            if let genre = genre {
                if item.genre = genre {
                    sum = sum + item.getKeysValue(key: key)
                }
            } else {
                sum = sum + item.getKeysValue(key: key)
            }
        }
        
        return sum
    }
}
