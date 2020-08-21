//
//  Barchart.swift
//  Minutes
//
//  Created by Jack Murphy on 8/21/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct Barchart: View {
    var data: [MetricsObject.SingleItem]
    var key: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HorizontalGraphLines(num: 5)
                VerticalGraphLines(num: 5)
            }
            .frame(width: geometry.size.width, height: self.height)
        }
    }
    
    
    @Environment(\.colorScheme) var colorScheme
    private let height: CGFloat = 200
}

struct HorizontalGraphLines: View {
    var num: Int
    var array: [String] = ["20m", "", "10m", "", "0m"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0..<self.num) { index in
                    VStack {
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
            .frame(width: geometry.size.width, height: geometry.size.height - self.offset)
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
            .frame(width: geometry.size.width - self.offset, height: geometry.size.height)
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let lineHeight: CGFloat = 2
    private let offset: CGFloat = 35
}
