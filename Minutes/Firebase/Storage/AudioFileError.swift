//
//  AudioFileError.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/4/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation

enum AudioFileError: Error {
    case urlIsNil
    case playerIsNil
}

extension AudioFileError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .urlIsNil:
            return NSLocalizedString("URL is Nil", comment: "")
        case .playerIsNil:
            return NSLocalizedString("AVPlayer is Nil", comment: "")
        }
    }
}
