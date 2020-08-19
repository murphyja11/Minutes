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
    
    enum Status {
        case undefined, success, failure
    }
    @Published var status: Status = .success
    @Published var audioSubviewStatus: Status = .success
    
    enum SelectedGenreEnum {
        case none, breath, body_scan
    }

    @Published var selectedGenre: FBGenre?
    @Published var selectedGenreEnum: SelectedGenreEnum = .none
    
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
        if genres.count == 0 {
            FBFirestore.retrieveGenres { result in
                switch result {
                case .failure(let error):
                    self.status = .failure
                    completion(.failure(error))
                    return
                case .success(let genres):
                    self.genres = genres
                    self.status = .success
                    completion(.success(true))
                    return
                }
            }
        } else {
            completion(.success(true))
            return
        }
    }
    
    // add completion
    func setMetadataArray(_ gen: FBGenre?) {
        var genre: FBGenre
        if gen == nil {
            if self.selectedGenre == nil { return }
            genre = self.selectedGenre!
        } else {
            genre = gen!
        }
        if let metadataArray = self.dictOfMetadataArrays[genre.genre] { return }
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
                            self.audioSubviewStatus = .success
                        }
                    }
                }
            }
        }
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
