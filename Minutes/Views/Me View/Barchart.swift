//
//  Barchart.swift
//  Minutes
//
//  Created by Jack Murphy on 8/21/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct Barchart: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    var data: [MetricsObject.SingleItem]
    var key: String
    
    var body: some View {
        let array = self.viewModel.getHourlyData(days: 1, key: self.key, timeScale: self.timeScale)
        let max = self.getMax(array)
        
        return GeometryReader { geometry in
            ZStack {
                HorizontalGraphLines(num: 3)
                VStack(spacing: 0) {
                    ForEach(0..<self.timeScale) { index in
                        VerticalBar(array[index], max: max)
                            .frame(height: geometry.size.height)
                    }
                }
            }
            .frame(width: geometry.size.width, height: self.height)
        }
    }
    
    private func getMax(_ array: [[String: Double]]) -> Double {
        var max = 0.0
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
    private let height: CGFloat = 150
}

struct VerticalBar: View {
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
                Spacer()
                ForEach(0..<self.count, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(self.viewModel.colorOfGenre[self.arrayOfGenres[index]])
                        .frame(width: self.width, height: CGFloat(self.arrayOfValues[index]) * geometry.size.height / CGFloat(self.max))
                }
            }
            .frame(height: geometry.size.height)
        }
    }
    
    private let width: CGFloat = 20
}


struct HorizontalGraphLines: View {
    var num: Int
    var array: [String] = ["20m", "10m", "0m"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<self.num) { index in
                    VStack(spacing: 0) {
                        HStack {
                            Rectangle()
                                .frame(width: geometry.size.width - self.offset, height: self.lineHeight)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
                            Text(self.array[index])
                                .font(.system(size: 10))
                        }
                        if index != self.num {
                            Spacer()
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: 100)
            .padding(0)
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let lineHeight: CGFloat = 2
    private let offset: CGFloat = 25
}

struct VerticalGraphLines: View {
    var num: Int
    var array: [String] = ["0", "6", "12", "18", ""]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.num) { index in
                    HStack {
                        VStack {
                            Rectangle()
                                .frame(width: self.lineHeight, height: geometry.size.height - self.offset)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
                            Text(self.array[index])
                                .font(.system(size: 10))
                        }
                        if index != self.num - 1 {
                            Spacer()
                        }
                    }
                }
            }
            .frame(width: geometry.size.width - self.offset, height: 100 + self.offset)
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let lineHeight: CGFloat = 2
    private let offset: CGFloat = 35
}
