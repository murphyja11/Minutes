//
//  MetricsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var viewModel: MetricsViewModel
    var uid: String
    
    enum ViewStatus {
        case day, week, total
    }
    
    @State var view: ViewStatus = .day
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                MetricsSwitchBar(view: self.$view)
                .frame(height: 30)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                if self.view == .day {
                    if self.viewModel.status == .success {
                        MetricsDayView()
                    } else {
                        VStack {
                            Spacer()
                            Text("loading")
                            Spacer()
                        }
                    }
                } else if self.view == .week {
                    if self.viewModel.status == .success {
                        Text("Week View")
                    } else {
                        VStack {
                            Spacer()
                            Text("loading")
                            Spacer()
                        }
                    }
                } else {
                    if self.viewModel.status == .success {
                        Text("Total View")
                    } else {
                        VStack {
                            Spacer()
                            Text("loading")
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .frame(height: geometry.size.height)
            .background(self.colorScheme == .light ? Color(red: 0.95, green: 0.95, blue: 0.95) : Color(red: 0.05, green: 0.05, blue: 0.05))
        }
        .onAppear {
            self.viewModel.getMetrics(uid: self.uid)
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
}


//struct MetricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MetricsView()
//            .environmentObject(UserInfo())
//    }
//}
