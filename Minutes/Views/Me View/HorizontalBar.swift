//
//  HorizontalBar.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct HorizontalBar: View {
    
    var array: [(String, Double)] = []
    var count: CGFloat = 0
    var colorArray: [Color] = []
    
    
    init(day: MetricsObject.DailyMetric?, key k: String) {
        var metrics = MetricsObject.DailyMetric()
        if day != nil {
            metrics = day!
        }
        var tempArray: [(String, Double)] = []
        var count: Double = 0.0
        for (key, value) in metrics.genres {
            if k == "numberOfMeditations" {
                let val = value.get(k) as? Int ?? 0
                count = count + Double(val)
                if key != "" {
                    tempArray.append((key, Double(val)))
                }
            } else {
                let val = value.get(k) as? Double ?? 0.0
                count = count + val
                if key != "" {
                    tempArray.append((key, val))
                }
            }
        }
        self.array = tempArray
        self.count = count == 0.0 ? CGFloat(1) : CGFloat(count)
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
                                .frame(width: CGFloat(self.array[index].1) / self.count * geometry.size.width, height: self.height)
                                .foregroundColor(self.colorArray[index])
                        }
                    }
                }
                HStack {
                    ForEach(0..<self.array.count) {index in
                        VStack(alignment: .leading) {
                            Text(self.array[index].0)
                                .font(.system(size: 15))
                                .foregroundColor(self.colorArray[index])
                            Text(self.toMinutes(self.array[index].1))
                                .font(.system(size: 15))
                        }
                    }
                    Spacer()
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
    private let height: CGFloat = 60
}
