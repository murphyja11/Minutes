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
    
    var body: some View {
        VStack {
            Spacer()
            Text("Total Minutes Meditated: " + self.toMinutesSeconds(self.userInfo.metrics.secondsListened))
                .font(.system(size: 20))
                .padding(.top, 10)
            Text("Number of Meditations: \(self.userInfo.metrics.numberOfMeditations)")
                .font(.system(size: 20))
            BarChart(data: self.userInfo.metrics.genres)
            Spacer()
        }
    }
    
    private func toMinutesSeconds (_ number: Double) -> String {
        let int = Int(number)
        let minutes = "\((int % 3600) / 60)"
        let seconds = "\((int % 3600) % 60)"
        return minutes + ":" + (seconds.count == 1 ? "0" + seconds : seconds)
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .environmentObject(UserInfo())
    }
}

struct BarChart: View {
    var data: [String: MetricsObject.Stats]
    var array: [(String, MetricsObject.Stats)]
    
    init(data: [String: MetricsObject.Stats]) {
        self.data = data
        var array: [(String, MetricsObject.Stats)] = []
        for (key, value) in data {
            array.append((key, value))
        }
        self.array = array
    }
    
    var body: some View {
        
        return GeometryReader { geometry in
            HStack {
                HStack {
                    ForEach(0..<self.array.count, id: \.self) { index in
                        VStack {
                            Text("\(Double(self.array[index].1.numberOfMeditations))")
                                .font(.system(size: 12))
                            GraphCapsule(value: Double(self.array[index].1.numberOfMeditations), height: self.height)
                            Text(self.array[index].0)
                                .font(.system(size: 12))
                        }
                        .frame( width: 40, height: self.height)
                    }
                }
            }
        }
    }
    private let height: CGFloat = 200
}

struct GraphCapsule: View {
    var value: Double
    var height: CGFloat
    
    var heightRatio: CGFloat {
        max(CGFloat(value) / height , 0.15)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Capsule()
            .fill(Color.blue)
                .frame(height: self.height * self.heightRatio)
        }
    }
}
