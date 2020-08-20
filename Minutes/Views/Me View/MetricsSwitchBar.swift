//
//  MetricsSwitchBar.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsSwitchBar: View {
    @Binding var view: MetricsView.ViewStatus
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(width: geometry.size.width * self.scale, height: self.height)
                HStack(spacing: 0) {
                    Button(action: {
                        self.view = .total
                    }) {
                        if self.view == .total {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4.5)
                                    .frame(width: geometry.size.width * self.scale / 3, height: self.height)
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                Text("Total")
                                    .font(.system(size: self.fontSize))
                                    .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                            }
                            .animation(Animation.easeInOut.speed(0.75))
                        } else {
                            Text("Total")
                                .font(.system(size: self.fontSize))
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                .frame(width: geometry.size.width * self.scale / 3)
                        }
                    }
                    Button(action: {
                        self.view = .week
                    }) {
                        if self.view == .week {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4.5)
                                    .frame(width: geometry.size.width * self.scale / 3, height: self.height)
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                Text("Week")
                                    .font(.system(size: self.fontSize))
                                    .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                            }
                            .animation(Animation.easeInOut.speed(0.75))
                        } else {
                            Text("Week")
                                .font(.system(size: self.fontSize))
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                .frame(width: geometry.size.width * self.scale / 3)
                        }
                    }
                    Button(action: {
                        self.view = .day
                    }) {
                        if self.view == .day {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4.5)
                                    .frame(width: geometry.size.width * self.scale / 3, height: self.height)
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                Text("Day")
                                    .font(.system(size: self.fontSize))
                                    .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                    .frame(width: geometry.size.width * self.scale / 3)
                            }
                            .animation(Animation.easeInOut.speed(0.75))
                        } else {
                            Text("Day")
                                .font(.system(size: self.fontSize))
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                .frame(width: geometry.size.width * self.scale / 3)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width * self.scale)
        }
        .frame(height: self.height)
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let height: CGFloat = 30
    private let fontSize: CGFloat = 15
    private let scale: CGFloat = 0.8
}

struct MetricsSwitchBar_Previews: PreviewProvider {
    @State static var view = MetricsView.ViewStatus.day
    
    static var previews: some View {
        MetricsSwitchBar(view: $view)
    }
}
