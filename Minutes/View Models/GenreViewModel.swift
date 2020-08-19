//
//  GenreViewModel.swift
//  Minutes
//
//  Created by Jack Murphy on 8/18/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GenreViewModel: ObservableObject {
    @Published var genres: [FBGenre] = []
    @Published var dictOfMetadataArrays: [String : [FBAudioMetadata]] = [:]
    
    enum SelectedGenreEnum {
        case none, breath, body_scan
    }
    enum AudioItemStatus {
        case undefined, failure, sucsess
    }
    
    @Published var selectedGenre: FBGenre?
    @Published var selectedGenreEnum: SelectedGenreEnum = .none
    @Published var audioItemStatus: AudioItemStatus = .undefined
    
    @Published var reloading: Bool = false {
           didSet {
               if !oldValue && reloading {
                   self.setGenres { result in
                       switch result {
                       case .failure(let error):
                           print(error.localizedDescription)
                           self.reloading = false
                       case .success( _):
                           self.reloading = false
                       }
                   }
               }
           }
       }
    
    func setGenres(completion: @escaping (Result<Bool, Error>) -> ()) {
        FBFirestore.retrieveGenres { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let genres):
                self.genres = genres
            }
        }
    }
    
    // add completion
    func getMetadataArray(_ gen: FBGenre?) -> ([FBAudioMetadata]) {
        var genre: FBGenre
        if gen == nil {
            var genre = self.selectedGenre
        } else {
            genre = gen!
        }
        if let metadataArray = self.dictOfMetadataArrays[genre.genre] {
            return metadataArray
        }
        var array: [FBAudioMetadata] = []
        var count = genre.references.count
        for reference in genre.references {
            if let reference = reference {
                FBFirestore.getDocument(for: reference) { result in
                    switch result {
                    case .failure(let error):
                        count = count - 1
                        if array.count == count {
                            self.dictOfMetadataArrays[genre.genre] = array
                            return array
                        }
                        print(error.localizedDescription)
                    case .success(let data):
                        if let metadata = FBAudioMetadata(documentData: data) {
                            array.append(metadata)
                        } else {
                            count = count - 1
                        }
                        if array.count == count {
                            self.dictOfMetadataArrays[genre.genre] = array
                            return array
                        }
                    }
                }
            }
        }
        return []
    }
    
    func selectGenre(for genre: String) {
        if genre == "breath" {
            self.selectedGenreEnum = .breath
        } else if genre == "body_scan" {
            self.selectedGenreEnum = .body_scan
            
        } else {
            self.selectedGenreEnum = .none
            self.selectedGenre = nil
            return
        }
        for fbgenre in self.genres {
            if fbgenre.genre == genre {
                self.selectedGenre = fbgenre
                return
            }
        }
    }
}
