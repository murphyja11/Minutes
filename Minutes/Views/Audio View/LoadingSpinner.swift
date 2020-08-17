//
//  LoadingSpinner.swift
//  Minutes
//
//  Created by Jack Murphy on 8/16/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct LoadingSpinner: View {
    @State var isLoading = false
    
    var body: some View {
        Circle()
        .trim(from: 0, to: 0.4)
        .stroke(Color.blue, lineWidth: 5)
        .frame(width: 80, height: 80)
        .rotationEffect(Angle(degrees: self.isLoading ? 360 : 0))
            .animation(Animation.default.repeatForever(autoreverses: false).speed(0.35))
        .onAppear {
            self.isLoading = true
        }
        .onDisappear {
            self.isLoading = false
        }
    }
}

struct LoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinner()
    }
}
