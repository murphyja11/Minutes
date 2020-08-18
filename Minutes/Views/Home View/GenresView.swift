//
//  TopicsView.swift
//  Minutes
//
//  Created by Jack Murphy on 8/17/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import SwiftUI

struct GenresView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var loadingStatus: LoadingStatus = .undefined
    
    enum LoadingStatus {
        case undefined, success, failure
    }
    
    //@ViewBuilder
    var body: some View {
        Group {
            if self.loadingStatus == .undefined {
                LoadingSpinner()
            } else if self.loadingStatus == .failure {
                VStack {
                    Spacer()
                    Text("Error getting the genres\nIts bad if this happens so LMK")
                    Spacer()
                }
            } else {
                GeometryReader { geometry in
                    RefreshableScrollView(height: 100, refreshing: self.$userInfo.reloadingGenres) {
                        ForEach(self.userInfo.genres, id: \.self) { genre in
                            GenreItemView(genre: genre)
                                .frame(width: geometry.size.width * 0.9, height: 100)
                                .padding(.horizontal, geometry.size.width * 0.1)
                        }
                        
                        // So that the ScrollView doesn't initialize empty:
                        if self.userInfo.user.recommendations.count == 0 {
                            HStack {
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.getGenres()
        }
    }
    
    private func getGenres() {
        FBFirestore.retrieveGenres { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.loadingStatus = .failure
            case .success(let genres):
                self.userInfo.genres = genres
                self.loadingStatus = .success
            }
        }
    }
}

