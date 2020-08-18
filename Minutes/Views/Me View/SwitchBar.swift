//
//  SwitchBar.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct SwitchBar: View {
    @Binding var subView: MeView.SubView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.subView = .metrics
                }) {
                    if self.subView == .metrics {
                        Text("Metrics")
                            .font(.system(size: 20)).fontWeight(.bold)
                            .foregroundColor(self.colorScheme == .light ? self.selectedLightModeColor : self.selectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    } else {
                        Text("Metrics")
                            .font(.system(size: 20)).fontWeight(.regular)
                            .foregroundColor(self.colorScheme == .light ? self.unselectedLightModeColor : self.unselectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    }
                }
                Button(action: {
                    self.subView = .activity
                }) {
                    if self.subView == .activity {
                        Text("Activity")
                            .font(.system(size: 20)).fontWeight(.bold)
                            .foregroundColor(self.colorScheme == .light ? self.selectedLightModeColor : self.selectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    } else {
                        Text("Activity")
                            .font(.system(size: 20)).fontWeight(.regular)
                            .foregroundColor(self.colorScheme == .light ? self.unselectedLightModeColor : self.unselectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    }
                }
            }
            //.frame(width: 240)
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(self.colorScheme == .light ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.9, green: 0.9, blue: 0.9))
                .frame(width: 40, height: 5, alignment: .center)
                .offset(x: self.underlineOffset())
                .animation(Animation.easeInOut.speed(1))
        }
        .frame(width: 240)
        .padding(.top, 30)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    
    private let textWidth: CGFloat = 80
    private let selectedLightModeColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
    private let selectedDarkModeColor: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    private let unselectedLightModeColor: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    private let unselectedDarkModeColor: Color = Color(red: 0.7, green: 0.7, blue: 0.7)
    
    private func underlineOffset () -> CGFloat {
        if self.subView == .activity {
            return self.textWidth / 2
        } else {
            return -self.textWidth / 2
        }
    }
}
