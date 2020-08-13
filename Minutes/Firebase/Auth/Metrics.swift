//
//  Metrics.swift
//  Minutes
//
//  Created by Jack Murphy on 8/13/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Metrics: ObservableObject {
    @Published var secondsListened = 0.0
    @Published var numberOfMeditations = 0
    
    func addSnapshotListener(reference: DocumentReference) {
        reference
        .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let document = documentSnapshot else {
                    print("Metrics document was empty")
                    return
                }
                guard let data = document.data() else {
                    print("Metrics document was empty")
                    return
                }
                guard let metrics = FBMetrics(documentData: data) else {
                    print("Metrics document was empty")
                    return
                }
            self.secondsListened = metrics.secondsListened
            self.numberOfMeditations = metrics.numberOfMeditations
        }
    }
}
