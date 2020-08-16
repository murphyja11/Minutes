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
    case AssetIsNil
    case DurationIsNil
    case cantAddObserver
    case UnableToPlay
}

extension AudioFileError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .urlIsNil:
            return NSLocalizedString("URL is Nil", comment: "")
        case .playerIsNil:
            return NSLocalizedString("AVPlayer is Nil", comment: "")
        case .AssetIsNil:
            return NSLocalizedString("AVAsset is Nil", comment: "")
        case .DurationIsNil:
            return NSLocalizedString("AVAsset Duration is Nil", comment: "")
        case .cantAddObserver:
            return NSLocalizedString("For some reason can't add observer", comment: "")
        case .UnableToPlay:
            return NSLocalizedString("Unable to start playing the audio", comment: "")
        }
    }
}
