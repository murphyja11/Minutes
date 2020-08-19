//
//  MetricsSwitchBar.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsSwitchBar: View {
    @Binding var view: MetricsView.View
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                HStack {
                    Button(action: {
                        self.view = .total
                    }) {
                        if self.view == .total {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4.5)
                                    .frame(width: geometry.size.width / 2, height: 24)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                Text("Total")
                            }
                            .animation(Animation.easeInOut.speed(0.75))
                        } else {
                            Text("Total")
                        }
                    }
                    Button(action: {
                        self.view = .week
                    }) {
                        if self.view == .week {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4.5)
                                    .frame(width: geometry.size.width / 2, height: 24)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                Text("Week")
                            }
                            .animation(Animation.easeInOut.speed(0.75))
                        } else {
                            Text("Week")
                        }
                    }
                    Button(action: {
                        self.view = .day
                    }) {
                        if self.view == .day {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4.5)
                                    .frame(width: geometry.size.width / 2, height: 24)
                                .foregroundColor(self.colorScheme == .light ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                Text("Day")
                            }
                            .animation(Animation.easeInOut.speed(0.75))
                        } else {
                            Text("Day")
                        }
                    }
                }
            }
            .frame(width: geometry.size.width * 0.8, height: 25)
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
}


struct MetricsSwitchBar_Previews: PreviewProvider {
    static var previews: some View {
        MetricsSwitchBar()
    }
}
