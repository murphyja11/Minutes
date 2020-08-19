//
//  MetricsGenreView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/19/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct MetricsGenreView: View {
    var totalData: [String: MetricsObject.Stats]
    @State private var showDetail = false
    
    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text("Your Top Genres")
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showDetail.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding()
                }
            }
            if showDetail {
                MetricsGenreDetail(totalData: self.totalData)
            }
        }
    }
}


struct MetricsGenreDetail: View {
    var array: [(String, MetricsObject.Stats)]
    
    init(totalData: [String: MetricsObject.Stats]) {
        var array: [(String, MetricsObject.Stats)] = []
        for (key, value) in totalData {
            array.append((key, value))
        }
        self.array = array
    }
    
    var body: some View {
        VStack {
            
        }
    }
}
