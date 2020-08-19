//
//  MetricsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    enum View {
        case total, week, day
    }
    @State var view: View = .day
    
    var body: some View {
        VStack {
            MetricsSwitchBar(view: self.$view)
            if self.view == .day {
                MetricsDayView(data: self.userInfo.metrics.daily[self.todaysDate()])
            } else {
                Text("Total Minutes Meditated: " + self.toMinutesSeconds(self.userInfo.metrics.secondsListened))
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text("Number of Meditations: \(self.userInfo.metrics.numberOfMeditations)")
                    .font(.system(size: 20))
                BarChart(data: self.userInfo.metrics.genres)
                Spacer()
            }
        }
    }
    
    private func todaysDate() {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: Date(), timeZone: TimeZone.current, formatOptions: [.withFullDate, .withDashSeparatorInDate])
    }
    
    private func toMinutesSeconds (_ number: Double) -> String {
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        let seconds = "\((int % 3600) % 60)"
        return minutes + ":" + (seconds.count == 1 ? "0" + seconds : seconds)
    }
}

