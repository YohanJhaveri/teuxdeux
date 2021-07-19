//
//  Reminder.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/13/21.
//

import Foundation

class Reminder {
    let id: String
    let type: String
    let taskID: String
    let createdAt: TimeInterval
    
    init(id: String, type: String, taskID: String, createdAt: TimeInterval) {
        self.id = id
        self.type = type
        self.taskID = taskID
        self.createdAt = createdAt
    }
}

class CountdownReminder: Reminder {
    let countdown: TimeInterval
    
    init(id: String, taskID: String, createdAt: TimeInterval, countdown: TimeInterval) {
        self.countdown = countdown
        super.init(id: id, type: "Countdown", taskID: taskID, createdAt: createdAt)
    }
    
    var dictionary: [String: Any] {
        return [
            "type": self.type,
            "taskID": self.taskID,
            "createdAt": self.createdAt,
            "countdown": self.countdown
        ]
    }
}

class ScheduledReminder: Reminder {
    let timestamp: TimeInterval
    
    init(id: String, taskID: String, createdAt: TimeInterval, timestamp: TimeInterval) {
        self.timestamp = timestamp
        super.init(id: id, type: "Scheduled", taskID: taskID, createdAt: createdAt)
    }
    
    var dictionary: [String: Any] {
        return [
            "type": self.type,
            "taskID": self.taskID,
            "createdAt": self.createdAt,
            "timestamp": self.timestamp
        ]
    }
}

class LocationReminder: Reminder {
    let location: Location
    
    init(id: String, taskID: String, createdAt: TimeInterval, location: Location) {
        self.location = location
        super.init(id: id, type: "Location", taskID: taskID, createdAt: createdAt)
    }
    
    var dictionary: [String: Any] {
        return [
            "type": self.type,
            "taskID": self.taskID,
            "createdAt": self.createdAt,
            "location": [
                "address": self.location.address,
                "latitude": self.location.latitude,
                "longitude": self.location.longitude
            ]
        ]
    }
}

struct Location {
    let address: String
    let latitude: Double
    let longitude: Double
    let radius = 500.0 // sets a radius of 500 meters by default
}

