//
//  FBFirestoreError.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-21.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

// MARK: - Firstore errors
enum FirestoreError: Error {
    case noAuthDataResult
    case noCurrentUser
    case noDocumentSnapshot
    case noSnapshotData
    case noUser
    case noRecommendations
    case noAudioMetadata
    case noMetrics
    case noMetadata
    case metricsError
    case logoutError
}

extension FirestoreError: LocalizedError {
    // This will provide me with a specific localized description for the FirestoreError
    var errorDescription: String? {
        switch self {
        case .noAuthDataResult:
            return NSLocalizedString("No Auth Data Result", comment: "")
        case .noCurrentUser:
            return NSLocalizedString("No Current User", comment: "")
        case .noDocumentSnapshot:
            return NSLocalizedString("No Document Snapshot", comment: "")
        case .noSnapshotData:
            return NSLocalizedString("No Snapshot Data", comment: "")
        case .noUser:
            return NSLocalizedString("No User", comment: "")
        case .noRecommendations:
            return NSLocalizedString("No Recommendations were provided", comment: "")
        case .noAudioMetadata:
            return NSLocalizedString("No Audio Metadata", comment: "")
        case .noMetrics:
            return NSLocalizedString("No Metrics", comment: "")
        case .noMetadata:
            return NSLocalizedString("No Metadata", comment: "")
        case .metricsError:
            return NSLocalizedString("Some Metrics Error", comment: "")
        case .logoutError:
            return NSLocalizedString("Error logging out", comment: "")
        }
    }
}
