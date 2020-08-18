//
//  SwitchBar.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct SwitchBar: View {
    @Binding var subView: HomeView.SubView
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.subView = .forYou
                }) {
                    if self.subView == .forYou {
                        Text("For You")
                            .font(.system(size: 20)).fontWeight(.bold)
                            .foregroundColor(self.colorScheme == .light ? self.selectedLightModeColor : self.selectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    } else {
                        Text("For You")
                            .font(.system(size: 20)).fontWeight(.regular)
                            .foregroundColor(self.colorScheme == .light ? self.unselectedLightModeColor : self.unselectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    }
                }
                Button(action: {
                    self.subView = .topics
                }) {
                    if self.subView == .topics {
                        Text("Topics")
                            .font(.system(size: 20)).fontWeight(.bold)
                            .foregroundColor(self.colorScheme == .light ? self.selectedLightModeColor : self.selectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    } else {
                        Text("Topics")
                            .font(.system(size: 20)).fontWeight(.regular)
                            .foregroundColor(self.colorScheme == .light ? self.unselectedLightModeColor : self.unselectedDarkModeColor)
                            .frame(width: self.textWidth, alignment: .center)
                    }
                }
            }
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(self.colorScheme == .light ? self.selectedLightModeColor : self.selectedDarkModeColor)
                .frame(width: 40, height: 3, alignment: .center)
                .padding(.top, 3)
                .offset(x: self.underlineOffset())
                .animation(Animation.easeInOut.speed(1))
        }
        .frame(width: 240)
        .padding(.top, 20)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    
    private let textWidth: CGFloat = 80
    private let selectedLightModeColor: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
    private let selectedDarkModeColor: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    private let unselectedLightModeColor: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    private let unselectedDarkModeColor: Color = Color(red: 0.7, green: 0.7, blue: 0.7)
    
    private func underlineOffset () -> CGFloat {
        if self.subView == .topics {
            return self.textWidth / 2
        } else {
            return -self.textWidth / 2
        }
    }
}
