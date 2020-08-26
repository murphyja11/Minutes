//
//  BarChartView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/24/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct BarChartView: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    var key: String
    var height: CGFloat
    var day: Int
    
    var body: some View {
        var timeScale: Int = 7
        if self.day == 1 { timeScale = 12 }
        let array = self.viewModel.getHourlyData(days: self.day, key: self.key, timeScale: timeScale)
        
        return GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<2) { index in
                            Rectangle()
                                .foregroundColor(self.colorScheme == .light ? self.lightColor : self.darkColor).frame(height: 1)
                            Spacer()
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<timeScale) { index in
                            VerticalBarView(array[index], max: self.getMax(array))
                                .padding(.trailing, 5)
                                .frame(width: (geometry.size.width - self.trailingPadding) / CGFloat(timeScale), height: self.height)
                        }
                    }
                    .padding(.trailing, self.trailingPadding)
                }
                Rectangle()
                    .foregroundColor(self.colorScheme == .light ? self.lightColor : self.darkColor)
                    .frame(height: 2)
                    .padding(.trailing, self.trailingPadding)
                BarLabelsView(day: self.day)
            }
            .frame(width: geometry.size.width, height: self.height)
        }
    }
    
    private func getMax(_ array: [[String: Double]]) -> Double {
        var max = 1.0
        for item in array {
            var count = 0.0
            for (_, value) in item {
                count = count + Double(value)
            }
            if count > max {
                max = count
            }
        }
        return max
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let lightColor: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    private let darkColor: Color = Color(red: 0.2, green: 0.2, blue: 0.8)
    private let fontSize: CGFloat = 12
    private let trailingPadding: CGFloat = 0
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(key: "secondsListened", height: 100, day: 1)
        .environmentObject(MetricsViewModel())
    }
}

struct VerticalBarView: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    var arrayOfValues: [Double]
    var arrayOfGenres: [String]
    var count: Int
    var max: Double
    
    init(_ dict: [String: Double], max: Double) {
        var valuesArray: [Double] = []
        var stringArray: [String] = []
        
        for (key, value) in dict {
            valuesArray.append(Double(value))
            stringArray.append(key)
        }
        
        self.arrayOfValues = valuesArray
        self.arrayOfGenres = stringArray
        self.count = valuesArray.count
        self.max = max
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                ForEach(0..<self.count) { index in
                    //ZStack {
                        Rectangle()
                            .foregroundColor(self.viewModel.colorOfGenre[self.arrayOfGenres[index]])
                            .frame(width: geometry.size.width, height: CGFloat(self.arrayOfValues[index] / self.max * Double(geometry.size.height)))
//                        VStack {
//                            Text("\(Int(self.arrayOfValues[index]))")
//                            Spacer()
//                        }
//                    }
                }
            }
        }
    }
}

struct BarLabelsView: View {
    var day: Int
    
    var body: some View {
        var array: [String] = []
        if self.day == 1 {
            array = ["00", "06", "12", "18"]
        } else if self.day == 7 {
            array = ["1", "2", "3", "4", "5", "6", "7"]
        }
        
        return HStack(spacing: 2) {
            if self.day == 7 {
                Spacer()
            }
            ForEach(0..<array.count) { index in
                Spacer()
                Text(array[index])
                    .font(.system(size: self.fontSize))
                    .foregroundColor(self.colorScheme == .light ? self.lightColor : self.darkColor)
                Spacer()
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let lightColor: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    private let darkColor: Color = Color(red: 0.2, green: 0.2, blue: 0.8)
    private let fontSize: CGFloat = 12
}
