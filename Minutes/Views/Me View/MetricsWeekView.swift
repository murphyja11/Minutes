//
//  MetricsWeekView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsWeekView: View {
    var daily: [String: MetricsObject.DailyMetric]
    
    enum Status {
        case seconds, number
    }
    
    @State var state: Status = .seconds
    
    var body: some View {
        let array = weekMetrics()
        
        return NavigationView {
            Section {
                Form {
                    if self.state == .seconds {
                        HStack {
                            VStack {
                                Text("Total")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(self.toMinutes(self.getTotal(array, key: "secondsListened")))")
                                .font(.system(size: 25))
                            }
                            VStack {
                                Text("Daily Average")
                                .font(.system(size: 15))
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(self.toMinutes(self.getAverage(array, key: "secondsListened")))")
                                .font(.system(size: 25))
                            }
                            BarChart(data: array, key: "secondsListened")
                        }
                    } else {
                        HStack {
                            VStack {
                                Text("Total")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(self.getTotal(array, key: "numberOfMeditations"))")
                                .font(.system(size: 25))
                            }
                            VStack {
                                Text("Daily Average")
                                .font(.system(size: 15))
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(self.getAverage(array, key: "numberOfMeditations"))")
                                .font(.system(size: 25))
                            }
                            BarChart(data: array, key: "numberOfMeditations")
                        }
                    }
                }
            }
        }
    }
    
    private func toMinutes (_ number: Double) -> String {
           let int = Int(number)
           let minutes = "\((int % 3600) / 60)"
           return minutes + "m"
    }
    
    private func weekMetrics() -> [(String, MetricsObject.DailyMetric)] {
        var array: [String] = []
        let timeInterval: Double = 86400
        for index in 0..<7 {
            array.append(ISO8601DateFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval(timeInterval * Double(index))), timeZone: TimeZone.current, formatOptions: [.withFullDate, .withDashSeparatorInDate]))
        }
        var metricsArray: [(String, MetricsObject.DailyMetric)] = []
        for date in array {
            metricsArray.append((date, self.daily[date] ?? MetricsObject.DailyMetric()))
        }
        return metricsArray
    }
    
    private func getTotal(_ array: [(String, MetricsObject.DailyMetric)], key: String) -> Double {
        if key == "secondsListened" {
            var total: Double = 0.0
            for item in array {
                total = item.1.secondsListened
            }
            return total
        } else if key == "numberOfMeditations" {
            var total: Double = 0.0
            for item in array {
                total = Double(item.1.numberOfMeditations)
            }
            return total
        } else {
            return 0.0
        }
    }
    
    private func getAverage(_ array: [(String, MetricsObject.DailyMetric)], key: String) -> Double {
        return self.getTotal(array, key: key) / Double(array.count)
    }
    
    @Environment(\.colorScheme) var colorScheme
}
