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
    
    func getTodaysData() -> [MetricsObject.SingleItem] {
        let secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let dateInCurrentTimeZone = Date(timeIntervalSinceNow: secondsFromGMT)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = .current
        let stringDate = formatter.string(Date())
        
        var year: String?
        var month: String?
        var day: String?
        
        let regex = NSRegularExpression(pattern: "(?<year>\d){4}-(?<month>\d){2}-(?<day>\d){2}", options: [])
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
        
        let beginningOfThisDay =
        for item in self.metrics.timeData {
            if item.time
        }
    }
    
    
    
    func getDailyMetrics() -> MetricsObject.DailyMetric {
        let gmt = TimeZone(abbreviation: "GMT")!
        let date = ISO8601DateFormatter.string(from: Date(), timeZone: gmt, formatOptions: [.withFullDate, .withDashSeparatorInDate]) //timeZone: TimeZone.current,
        return self.metrics.daily[date] ?? MetricsObject.DailyMetric()

    }
}
