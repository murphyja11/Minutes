//
//  ActivityView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var userInfo: UserInfo
//    var activity: [FBActivity]
//
//    init() {
//        self.activity = userInfo.metrics.activity
//    }
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(self.userInfo.metrics.activity, id: \.self) { activity in
                SingleActivityView(activity: activity)
            }
            Spacer()
        }
    }
}


struct SingleActivityView: View {
    var activity: FBActivity
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1))
                HStack {
                    Text("\(self.activity.metadata.title)")
                    Text("\(self.activity.metadata.length)")
                }
            }
            Text("\(self.activity.time)")
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
