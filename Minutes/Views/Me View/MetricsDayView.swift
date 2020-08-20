//
//  MetricsDayView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsDayView: View {
    var day: MetricsObject.DailyMetric
    
    enum Status {
        case number, seconds
    }
    
    @State var state: Status = .number
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                Section {
                    Form {
                        if self.state == .number {
                            VStack {
                                Text("Today, \(self.getDate())")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(self.toMinutes(self.day.secondsListened))")
                                    .font(.system(size: 25))
                                HorizontalBar(day: self.day.genres, key: "secondsListened")
                            }
                            .frame(width: geometry.size.width * 0.9)
                        } else {
                            VStack {
                               Text("Today, \(self.getDate())")
                                   .font(.system(size: 15))
                                   .foregroundColor(self.colorScheme == .light ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(self.day.numberOfMeditations, specifier:" %.1f") meditations")
                                   .font(.system(size: 25))
                               HorizontalBar(day: self.day.genres, key: "numberOfMeditations")
                           }
                           .frame(width: geometry.size.width * 0.9)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                self.state = .number
                            }) {
                                if self.state == .number {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: geometry.size.width / 4, height: 20)
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 1.0))
                                        Text("Number")
                                            .font(.system(size: 15))
                                    }
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: geometry.size.width / 4, height: 20)
                                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                        Text("Number")
                                                .font(.system(size: 15))
                                    }
                                }
                            }
                            Button(action: {
                                self.state = .seconds
                            }) {
                                if self.state == .seconds {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: geometry.size.width / 4, height: 20)
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 1.0))
                                        Text("Minutes")
                                            .font(.system(size: 15))
                                    }
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: geometry.size.width / 4, height: 20)
                                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                        Text("Minutes")
                                            .font(.system(size: 15))
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
            let int = Int(number)
            let minutes = "\((int % 3600) / 60)"
            return minutes + "m"
    }
    
    @Environment(\.colorScheme) var colorScheme
}
