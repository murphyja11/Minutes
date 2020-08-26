//
//  MetricsTotalView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/25/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsTotalView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var viewModel: MetricsViewModel
    
    @State var state: MetricsDayView.MetricsStatus = .seconds
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if self.state == .seconds {
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(self.getAccountTime())")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text("\(self.toMinutes(self.viewModel.metrics.secondsListened))")
                                    .font(.system(size: 25))
                            }
                            Spacer()
                        }
                        .frame(height: 80)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        TotalHorizontalBar(key: "secondsListened")
                            .frame(height: 120)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 0)
                        Spacer()
                    }
                    .frame(height: self.frameHeight - 50)
                    .background(self.colorScheme == .light ? Color.white : Color.black)
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(self.getAccountTime())")
                                    .font(.system(size: 15))
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .padding(.top, 10)
                                Text(self.numberOfMeditations(self.viewModel.metrics.numberOfMeditations))
                                    .font(.system(size: 25))
                            }
                            Spacer()
                        }
                        .frame(height: 80)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        TotalHorizontalBar(key: "numberOfMeditations")
                            .frame(height: 120)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 0)
                        Spacer()
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
    
    private func getAccountTime() -> String {
        let dateCreated = self.userInfo.user.accountCreated
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfYear, .day]
        
        return formatter.string(from: dateCreated, to: Date()) ?? ""
    }
    
    private func toMinutes (_ number: Double) -> String {
        if number < 60 {
            return "\(Int(number))s"
        }
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        return minutes + "m"
    }
    
    private func numberOfMeditations(_ number: Int) -> String {
        if number == 1 {
            return "\(number) meditation"
        } else {
            return "\(number) meditations"
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let frameHeight: CGFloat = 300
}




struct TotalHorizontalBar: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    var key: String
    
    
    var body: some View {
        var array: [(String, Double)] = []
        var tempCount: Double = 0.0
        for (key, value) in self.viewModel.metrics.genres {
            array.append((key, value.getKeysValue(self.key)))
            tempCount = tempCount + value.getKeysValue(self.key)
        }
        let count = tempCount == 0.0 ? CGFloat(1) : CGFloat(tempCount)
        
        
        return GeometryReader { geometry in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: geometry.size.width, height: self.height)
                        .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
                    HStack(spacing: 0) {
                        ForEach(0..<array.count) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 1)
                                    .frame(width: CGFloat(array[index].1) / count * geometry.size.width, height: self.height)
                                    .foregroundColor(self.viewModel.colorOfGenre[array[index].0])
                                HStack {
                                    if self.key == "secondsListened" {
                                        Text(self.toMinutes(array[index].1))
                                        .font(.system(size: 15))
                                        .padding(.leading, 5)
                                    } else {
                                        Text(self.toNumber(array[index].1))
                                        .font(.system(size: 15))
                                        .padding(.leading, 5)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                HStack {
                    ForEach(0..<array.count) {index in
                        VStack(alignment: .leading) {
                            Text(array[index].0)
                                .font(.system(size: 15))
                                .foregroundColor(self.viewModel.colorOfGenre[array[index].0])
                            if self.key == "secondsListened" {
                                Text(self.toMinutes(array[index].1))
                                .font(.system(size: 15))
                            } else {
                                Text(self.toNumber(array[index].1))
                                .font(.system(size: 15))
                            }
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
    
    private func toNumber(_ number: Double) -> String {
        return "\(Int(number))"
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let height: CGFloat = 60
}
