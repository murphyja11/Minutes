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
    
    var body: some View {
        let array = self.viewModel.getHourlyData(days: 1, key: self.key, timeScale: self.timeScale)
        let max = self.getMax(array)
        
        return GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    VStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5)).frame(height: 1)
                        Spacer()
                        Rectangle()
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5)).frame(height: 1)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<self.timeScale) { index in
                            VerticalBarView(array[index], max: self.getMax(array))
                                .padding(.trailing, 5)
                                .frame(width: (geometry.size.width - self.trailingPadding) / CGFloat(self.timeScale), height: self.height)
                        }
                    }
                    .padding(.trailing, self.trailingPadding)
                }
                Rectangle()
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .frame(height: 2)
                    .padding(.trailing, self.trailingPadding)
                BarLabelsView()
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
    private let timeScale: Int = 12
    private let fontSize: CGFloat = 12
    private let trailingPadding: CGFloat = 0
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(key: "secondsListened", height: 100)
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
    
    var body: some View {
        HStack(spacing: 2) {
            Text("00")
                .font(.system(size: self.fontSize))
            Spacer()
            Text("06")
                .font(.system(size: self.fontSize))
            Spacer()
            Text("12")
                .font(.system(size: self.fontSize))
            Spacer()
            Text("18")
                .font(.system(size: self.fontSize))
            Spacer()
        }
    }
    
    private let fontSize: CGFloat = 12
}
