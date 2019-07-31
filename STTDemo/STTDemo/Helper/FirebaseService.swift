//
//  FirebaseService.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Firebase
import SwiftyJSON

class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    
    func write(message: String) {
        let model = MessageModel(time: Date(), content: message)
        db.collection("messages").addDocument(data: model.dictValue())
    }
    
    func addObserverRead(changes: @escaping ([MessageModel]) -> Void) {
        db.collection("messages").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var models: [MessageModel] = []
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    let model = MessageModel(json: JSON(diff.document.data()))
                    print("New message \(model)")
                    models.append(model)
                }
            }
            models.sort(by: { $0.time < $1.time })
            changes(models)
        }
    }
    
}
