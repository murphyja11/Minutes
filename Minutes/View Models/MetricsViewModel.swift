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
    
    func getDailyMetrics() -> MetricsObject.DailyMetric {
        let gmt = TimeZone(abbreviation: "GMT")!
        let date = ISO8601DateFormatter.string(from: Date(), timeZone: gmt, formatOptions: [.withFullDate, .withDashSeparatorInDate]) //timeZone: TimeZone.current,
        return self.metrics.daily[date] ?? MetricsObject.DailyMetric()

    }
}
