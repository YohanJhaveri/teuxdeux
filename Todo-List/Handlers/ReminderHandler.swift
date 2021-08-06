//
//  ReminderHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/13/21.
//

import Foundation
import Firebase
import CoreData

class ReminderHandler {
    static let auth = Auth.auth()
    static let firestore = Firestore.firestore()
    static let reference = firestore.collection("reminders")
    
    static func buildDefaultReminder() -> Reminder {
        return Reminder(
            id: "???",
            type: "This reminder has the incorrect type",
            taskID: "Default taskID",
            createdAt: Date().timeIntervalSince1970
        )
    }
    
    static func buildCountdownReminder(id: String, data: [String: Any], taskID: String) -> CountdownReminder {
        let createdAt = data["createdAt"] as! TimeInterval
        let countdown = data["countdown"] as! TimeInterval
        
        return CountdownReminder(
            id: id,
            taskID: taskID,
            createdAt: createdAt,
            countdown: countdown
        )
    }
    
    static func buildScheduledReminder(id: String, data: [String: Any], taskID: String) -> ScheduledReminder {
        let createdAt = data["createdAt"] as! TimeInterval
        let timestamp = data["timestamp"] as! TimeInterval
                                        
        return ScheduledReminder(
            id: id,
            taskID: taskID,
            createdAt: createdAt,
            timestamp: timestamp
        )
    }
    
    static func buildLocationReminder(id: String, data: [String: Any], taskID: String) -> LocationReminder {
        let createdAt = data["createdAt"] as! TimeInterval
        let location = data["location"] as! Dictionary<String, Any>
        
        let address = location["address"] as! String
        let latitude = location["latitude"] as! Double
        let longitude = location["longitude"] as! Double
        
        return LocationReminder(
            id: id,
            taskID: taskID,
            createdAt: createdAt,
            location: Location(address: address, latitude: latitude, longitude: longitude)
        )
    }
    
    
    static func listener(task: Task, _ completion: @escaping ([Reminder]?, Error?) -> Void) {
        let taskID = task.id!
        
        reference
            .whereField("taskID", isEqualTo: taskID)
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let documents = snapshot?.documents {
                    let reminders: [Reminder] = documents.map({ document in
                        let id = document.documentID
                        let data = document.data()
                        let type = data["type"] as? String
                        
                        switch type {
                        case "Countdown": return buildCountdownReminder(id: id, data: data, taskID: taskID)
                        case "Scheduled": return buildScheduledReminder(id: id, data: data, taskID: taskID)
                        case "Location": return buildLocationReminder(id: id, data: data, taskID: taskID)
                        default: return buildDefaultReminder()
                        }
                    })
                    
                    completion(reminders, nil)
                }
            }
    }
    
    
    static func writeReminder(reminder: CountdownReminder, task: Task) {
        NotificationHandler.requestNotificationAuthorization { granted in
            NotificationHandler.deleteNotification(id: reminder.id)
            NotificationHandler.createNotification(reminder: reminder, task: task)
        }
        
        reference.document(reminder.id).setData(reminder.dictionary) { error in
            if error != nil {
                // save data offline
            }
        }
    }
    
    static func writeReminder(reminder: ScheduledReminder, task: Task) {
        NotificationHandler.requestNotificationAuthorization { granted in
            NotificationHandler.deleteNotification(id: reminder.id)
            NotificationHandler.createNotification(reminder: reminder, task: task)
        }
        
        reference.document(reminder.id).setData(reminder.dictionary) { error in
            if error != nil {
                // save data offline
            }
        }
    }
    
    static func writeReminder(reminder: LocationReminder, task: Task) {
        NotificationHandler.requestNotificationAuthorization { granted in
            NotificationHandler.deleteNotification(id: reminder.id)
            NotificationHandler.createNotification(reminder: reminder, task: task)
        }
        
        reference.document(reminder.id).setData(reminder.dictionary) { error in
            if error != nil {
                // save data offline
            }
        }
    }
    
    static func deleteReminder(id: String, completion: @escaping  (Error?) -> Void) {
        NotificationHandler.requestNotificationAuthorization { granted in
            NotificationHandler.deleteNotification(id: id)
        }
        
        reference.document(id).delete(completion: completion)
    }
    
    static func deleteRemindersOfTask(id: String) {
        firestore.collection("reminders").whereField("taskID", isEqualTo: id).getDocuments { snapshot, error in
            if error != nil {
                return
            }
            
            let documents = snapshot!.documents
            
            for document in documents {
                self.deleteReminder(id: document.documentID) { error in
                    if error != nil {
                        return
                    }
                }
            }
        }
    }
}
