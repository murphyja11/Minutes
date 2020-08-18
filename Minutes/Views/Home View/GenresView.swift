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
    @State var status: Status = .undefined
    
    enum Status {
        case undefined, sucess, failure
    }
    
    var body: some View {
        Group {
            if self.status == .undefined {
                LoadingSpinner()
            } else if self.status == .failure {
                VStack {
                    Spacer()
                    Text("Error getting the genres\nIts bad if this happens so LMK")
                    Spacer()
                }
            } else {
                GeometryReader { geometry in
                    RefreshableScrollView(height: 100, refreshing: self.$userInfo.reloading) {
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
                self.status = .failure
            case .success(let genres):
                self.userInfo.genres = genres
                self.status = .success
            }
        }
    }
}

struct TopicsView_Previews: PreviewProvider {
    static var previews: some View {
        GenresView()
    }
}
