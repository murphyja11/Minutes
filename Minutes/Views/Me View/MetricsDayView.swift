//
//  MetricsDayView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsDayView: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    
    enum MetricsStatus {
        case number, seconds
    }
    
    @State var state: MetricsStatus = .seconds
    
    var body: some View {
       GeometryReader { geometry in
            VStack(spacing: 0) {
                if self.state == .seconds {
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Today, \(self.getDate())")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text("\(self.toMinutes(self.viewModel.getDataSum(days: 1, key: "secondsListened")))")
                                    .font(.system(size: 25))
                            }
                            Spacer()
                        }
                        .frame(height: 80)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        HorizontalBar(data: self.viewModel.getDataRange(days: 1), key: "secondsListened")
                            .frame(height: 120)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 0)
                        BarChartView(key: "secondsListened", height: 125, day: 1)
                            .frame(height: 200)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 5)
                    }
                    .frame(height: self.frameHeight - 50)
                    .background(self.colorScheme == .light ? Color.white : Color.black)
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Today, \(self.getDate())")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text(self.numberOfMeditations())
                                    .font(.system(size: 25))
                            }
                            Spacer()
                        }
                        .frame(height: 80)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        HorizontalBar(data: self.viewModel.getDataRange(days: 1), key: "numberOfMeditations")
                            .frame(height: 120)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 0)
                        BarChartView(key: "numberOfMeditations", height: 125, day: 1)
                            .frame(height: 200)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 5)
                    }
                    .frame(height: self.frameHeight - 50)
                    .background(self.colorScheme == .light ? Color.white : Color.black)
                }
                DayViewButtons(state: self.$state)
                    .environmentObject(self.viewModel)
            }
            .frame(height: self.frameHeight)
        }
    }
    
    private func getDate() -> String {
        let dateFormatter = DateFormatter()
        let date = Date()
         
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        return dateFormatter.string(from: date)
    }
    
    private func toMinutes (_ number: Double) -> String {
        if number < 60 {
            return "\(Int(number))s"
        }
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        return minutes + "m"
    }
    
    private func numberOfMeditations() -> String {
        let number = Int(self.viewModel.getDataSum(days: 1, key: "numberOfMeditations"))
        if number == 1 {
            return "\(number) meditation"
        } else {
            return "\(number) meditations"
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let frameHeight: CGFloat = 450
}


//struct MetricsDayView_Previews: PreviewProvider {
//    @ObservedObject static var userInfo = UserInfo()
//    
//    static let date = ISO8601DateFormatter.string(from: Date(), timeZone: TimeZone.current, formatOptions: [.withFullDate, .withDashSeparatorInDate])
//    static let day: MetricsObject.DailyMetric = userInfo.metrics.daily[date] ?? MetricsObject.DailyMetric()
//    
//    static var previews: some View {
//        MetricsDayView()
//        .environmentObject(userInfo)
//    }
//}

//struct MetricsDaySeconds: View {
//    @EnvironmentObject var viewModel: GenreViewModel
//
//    var body: some View {
//
//    }
//}


