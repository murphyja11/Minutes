//
//  MetricsWeekView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/24/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsWeekView: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    
    
    @State var state: MetricsDayView.MetricsStatus = .seconds
    
    var body: some View {
       GeometryReader { geometry in
            VStack(spacing: 0) {
                if self.state == .seconds {
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Average")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text("\(self.toMinutes(self.viewModel.getDataSum(days: 7, key: "secondsListened") / 7))")
                                    .font(.system(size: 25))
                            }
                            VStack(alignment: .leading) {
                                Text("Total")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text("\(self.toMinutes(self.viewModel.getDataSum(days: 7, key: "secondsListened")))")
                                    .font(.system(size: 25))
                            }
                            Spacer()
                        }
                        .frame(height: 80)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        HorizontalBar(data: self.viewModel.getDataRange(days: 7), key: "secondsListened")
                            .frame(height: 120)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 0)
                        BarChartView(key: "secondsListened", height: 125, day: 7)
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
                                Text("Daily Average")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text(self.numberOfMeditations(true))
                                    .font(.system(size: 25))
                            }
                            VStack(alignment: .leading) {
                                Text("Total")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text(self.numberOfMeditations(avg: true))
                                    .font(.system(size: 25))
                            }
                            Spacer()
                        }
                        .frame(height: 80)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        HorizontalBar(data: self.viewModel.getDataRange(days: 7), key: "numberOfMeditations")
                            .frame(height: 120)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 0)
                        BarChartView(key: "numberOfMeditations", height: 125, day: 7)
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
        let number = Int(self.viewModel.getDataSum(days: 7, key: "numberOfMeditations"))
        if number == 1 {
            return "\(number) meditation"
        } else {
            return "\(number) meditations"
    }
        
        private func avgMeditations(_ avg: Bool) -> String {
            let number = Int(self.viewModel.getDataSum(days: 7, key: "numberOfMeditations"))
            if avg {
                return "\(number / 7)"
            }
        }
    
    @Environment(\.colorScheme) var colorScheme
    private let frameHeight: CGFloat = 450
}

