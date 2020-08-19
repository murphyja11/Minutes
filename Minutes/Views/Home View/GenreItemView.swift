//
//  GenreItemView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct GenreItemView: View {
    var genre: FBGenre
    @ObservedObject var viewModel: GenreViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    self.viewModel.setMetadataArray(self.genre)
                    self.viewModel.selectGenre(for: self.genre.genre)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(self.getDisplayColor(self.genre.genre))
                        HStack {
                            Text(self.getDisplayTitle(self.genre.genre))
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                .padding(.leading, 25)
                            Spacer()
                            ZStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(self.colorScheme == .light ? Color(red: 0.95, green: 0.95, blue: 0.95) : Color(red: 0.05, green: 0.05, blue:0.05))
                                Image(systemName: "chevron.right").resizable()
                                    .foregroundColor(self.colorScheme == .light ? Color.black : Color.white)
                                    .frame(width: 10, height: 15)
                            }
                            .padding(.trailing, 15)
                        }
                        .frame(height: 100)
                    }
                }
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    func getDisplayTitle(_ genre: String) -> String {
        if genre == "breath" {
            return "Breathing"
        } else if genre == "body_scan" {
            return "Body Scan"
        } else {
            return ""
        }
    }
    
    func getDisplayColor(_ genre: String) -> Color {
        if genre == "breath" {
            return self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1)
        } else if genre == "body_scan" {
            return self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1)
        } else {
            return self.colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.1, green: 0.1, blue: 0.1)
        }
    }
}

