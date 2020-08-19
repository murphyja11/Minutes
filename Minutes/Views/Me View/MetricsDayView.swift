//
//  MetricsDayView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsDayView: View {
    var day: MetricsObject.DailyMetric
    var key: String
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                Section {
                    Form {
                        VStack {
                            Text("Today, \(self.getDate())")
                                .font(.system(size: 15))
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                            Text("\(self.toMinutes(self.day.secondsListened))")
                                .font(.system(size: 25))
                            HorizontalBar(day: self.day.genres, key: self.key)
                        }
                        .frame(width: geometry.size.width * 0.9)
                    }
                }
            }
        }
    }
    
    private func getDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date()
         
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        return dateFormatter.string(from: date)
    }
    
    private func toMinutes (_ number: Double) -> String {
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        return minutes + "m"
    }
    
    @Environment(\.colorScheme) var colorScheme
}

struct HorizontalBar: View {
    var array: [(String, Double)]
    var count: CGFloat
    var colorArray: [Color]
    
    init(day: [String: MetricsObject.Stats], key: String) {
        var tempArray: [(String, Double)] = []
        var count: Double = 0.0
        for (key, value) in day {
            let doubleValue = value.get(key) as? Double ?? 0.0
            count = count + doubleValue
            tempArray.append((key, doubleValue))
        }
        self.array = tempArray
        self.count = CGFloat(count)
        self.colorArray = [Color.blue, Color(red: 1.0, green: 0.6, blue: 0), Color(red: 0, green: 0.9, blue: 1), Color(red: 0, green: 0.5, blue: 1), Color(red: 1.0, green: 0.6, blue: 1.0)]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: geometry.size.width, height: self.height)
                        .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
                    HStack(spacing: 0) {
                        ForEach(0..<self.array.count) { index in
                            RoundedRectangle(cornerRadius: 1)
                                .frame(width: CGFloat(self.array[index].1) * geometry.size.width / self.count, height: self.height)
                                .foregroundColor(self.colorArray[index])
                        }
                    }
                }
                HStack {
                    ForEach(0..<self.array.count) {index in
                        VStack {
                            Text(self.array[index].0)
                                .font(.system(size: 15))
                                .foregroundColor(self.colorArray[index])
                            Text(self.toMinutes(self.array[index].1))
                                .font(.system(size: 15))
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
    
    @Environment(\.colorScheme) var colorScheme
    private let height: CGFloat = 40
}
