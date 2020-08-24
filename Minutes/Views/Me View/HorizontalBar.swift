//
//  HorizontalBar.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct HorizontalBar: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    var array: [(String, Double)]
    var count: CGFloat = 0
    
    
    init(data: [MetricsObject.SingleItem], key: String) {
        
        var dict: [String: Double] = [:]
        for item in data {
            if let val = dict[item.genre] {
                dict[item.genre] = val + item.getKeysValue(key: key)
            } else {
                dict[item.genre] = Double(item.getKeysValue(key: key))
            }
        }
        
        var tempArray: [(String, Double)] = []
        var count: Double = 0.0
        for (key, value) in dict {
            tempArray.append((key, value))
            count = count + value
        }
        self.array = tempArray
        self.count = count == 0.0 ? CGFloat(1) : CGFloat(count)
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
                            ZStack {
                                RoundedRectangle(cornerRadius: 1)
                                    .frame(width: CGFloat(self.array[index].1) / self.count * geometry.size.width, height: self.height)
                                    .foregroundColor(self.viewModel.colorOfGenre[self.array[index].0])
                                HStack {
                                    Text(self.toMinutes(self.array[index].1))
                                    .font(.system(size: 15))
                                        .padding(.leading, 5)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                HStack {
                    ForEach(0..<self.array.count) {index in
                        VStack(alignment: .leading) {
                            Text(self.array[index].0)
                                .font(.system(size: 15))
                                .foregroundColor(self.viewModel.colorOfGenre[self.array[index].0])
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
