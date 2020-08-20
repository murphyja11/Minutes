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
    
    enum ViewStatus {
        case day, week, total
    }
    @State var view: ViewStatus = .day
    
    
    var body: some View {
        let date = todaysDate()
        let day: MetricsObject.DailyMetric = self.userInfo.metrics.daily[date] ?? MetricsObject.DailyMetric()
        
        return GeometryReader { geometry in
            VStack {
                MetricsSwitchBar(view: self.$view)
                if self.view == .day {
                    MetricsDayView(day: day)
                } else if self.view == .week {
                     MetricsWeekView(daily: self.userInfo.metrics.daily)
                } else {
                     Spacer()
                }
            }
        }
    }
    
    private func todaysDate() -> String {
        return ISO8601DateFormatter.string(from: Date(), timeZone: TimeZone.current, formatOptions: [.withFullDate, .withDashSeparatorInDate])
    }
    
    private func toMinutes (_ number: Double) -> String {
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        return minutes + "m"
    }
}


struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .environmentObject(UserInfo())
    }
}
