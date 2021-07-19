//
//  TaskHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/12/21.
//

import Foundation
import Firebase

class TaskHandler {
    static let auth = Auth.auth()
    static let firestore = Firestore.firestore()
    static let reference = firestore.collection("tasks")
    
    static func listener(_ completion: @escaping ([Task]?, Error?) -> Void) {
        if let email = auth.currentUser?.email {
            reference
                .whereField("user", isEqualTo: email)
                .whereField("done", isEqualTo: false)
                .order(by: "date")
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    if let documents = snapshot?.documents {
                        let tasks: [Task] = documents.map({ document in
                            let id = document.documentID
                            let data = document.data()
                            
                            let name = data["name"] as? String
                            let date = data["date"] as? String
                            
                            return Task(
                                id: id,
                                done: false,
                                name: name ?? "",
                                date: date ?? ""
                            )
                        })
                        
                        completion(tasks, nil)
                    }
                }
        } else {
            print("User is not logged in!")
        }
    }
    
    static func createTask(createdFields: [String: Any], completion: @escaping (Error?) -> Void) {
        reference.addDocument(data: createdFields, completion: completion)
    }
    
    static func updateTask(id: String, updatedFields: [String: Any], completion: @escaping  (Error?) -> Void) {
        reference.document(id).updateData(updatedFields, completion: completion)
    }
    
    static func completeTask(id: String, completion: @escaping  (Error?) -> Void) {
        reference.document(id).updateData(["done": true], completion: completion)
        ReminderHandler.deleteRemindersOfTask(id: id)
    }
    
    static func deleteTask(id: String, completion: @escaping  (Error?) -> Void) {
        reference.document(id).delete(completion: completion)
        ReminderHandler.deleteRemindersOfTask(id: id)
    }
}
