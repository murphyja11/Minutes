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
            Text("Number of Meditations: \(self.userInfo.metrics.numberOfMeditations)")
                .font(.system(size: 20))
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
