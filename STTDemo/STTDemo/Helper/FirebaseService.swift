//
//  FirebaseService.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Firebase
import SwiftyJSON

final class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    
    func write(audioName: String, createdDate: String, message: String) {
        let model = MessageModel(time: Date(), content: message)
        db.collection("database").document(audioName).collection("messages").addDocument(data: model.dictValue())
        db.collection("database").document(audioName).setData([ "CreatedDate": createdDate], merge: true)
    }
    
    func addObserverRead(audioName: String, changes: @escaping ([MessageModel]) -> Void) {
        db.collection("database").document(audioName).collection("messages").addSnapshotListener { querySnapshot, error in
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
    
    func addObserverReadRoot(changes: @escaping ([(String, Date)]) -> Void) {
        db.collection("database").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            var listData: [(String, Date)] = []
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    let json = JSON(diff.document.data())
                    let createdDate = json["CreatedDate"].stringValue.dateBy(format: "dd-MM-yyyy") ?? Date()
                    listData.append((diff.document.documentID, createdDate))
                }
            }
            changes(listData)
        }
    }
}
