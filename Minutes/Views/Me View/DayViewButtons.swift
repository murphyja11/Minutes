//
//  DayViewButtons.swift
//  Minutes
//
//  Created by Jack Murphy on 8/20/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct DayViewButtons: View {
    @EnvironmentObject var viewModel: GenreViewModel
    @Binding var state: MetricsDayView.MetricsStatus
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Button(action: {
                    self.state = .seconds
                }) {
                    if self.state == .seconds {
                        ZStack {
                            RoundedRectangle(cornerRadius: self.cornerRadius)
                                .frame(width: geometry.size.width / self.widthScale, height: self.height)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.9, blue: 1.0) : Color(red: 0.2, green: 0.2, blue: 0.2))
                            Text("Time")
                                .font(.system(size: 15))
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                        }
                    } else {
                        Text("Time")
                            .font(.system(size: 15))
                            .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                            .frame(width: geometry.size.width / self.widthScale, height: self.height)
                    }
                }
                .padding(.trailing, 20)
                Button(action: {
                    self.state = .number
                }) {
                    if self.state == .number {
                        ZStack {
                            RoundedRectangle(cornerRadius: self.cornerRadius)
                                .frame(width: geometry.size.width / self.widthScale, height: self.height)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.9, blue: 1.0) : Color(red: 0.2, green: 0.2, blue: 0.2))
                            Text("Number")
                                .font(.system(size: 15))
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                        }
                    } else {
                        Text("Number")
                            .font(.system(size: 15))
                            .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                            .frame(width: geometry.size.width / self.widthScale, height: self.height)
                    }
                }
                Spacer()
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 25
    private let widthScale: CGFloat = 3.5
}
