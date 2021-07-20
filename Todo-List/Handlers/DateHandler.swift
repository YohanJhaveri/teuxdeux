//
//  DateHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/12/21.
//

import Foundation

class DateHandler {
    static var firebaseDateFormatter = DateFormatter(format: "yyyy-MM-dd")
    static var friendlyDateFormatter = DateFormatter(format: "MMMM dd")
    static var fullDateFormatter = DateFormatter(format: "MMMM dd, y")
    static var fullTimeFormatter = DateFormatter(format: "h:mm a")
    
    static func getFirebaseDateString(from date: Date) -> String {
        return firebaseDateFormatter.string(from: date)
    }
    
    static func getFirebaseDateValue(from string: String) -> Date? {
        return firebaseDateFormatter.date(from: string)
    }
    
    static func getFriendlyDateString(from firebaseDate: String) -> String {
        if let firebaseDate = getFirebaseDateValue(from: firebaseDate) {
            return friendlyDateFormatter.string(from: firebaseDate)
        }
        
        return ""
    }
    
    static func getDateTime(from time: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: time)
        let dateString = fullDateFormatter.string(from: date)
        let timeString = fullTimeFormatter.string(from: date)
        return "\(dateString) at \(timeString)"
    }
    
    static func getDate(from time: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: time)
        return fullDateFormatter.string(from: date)
    }
    
    static func getTime(from time: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: time)
        return fullTimeFormatter.string(from: date)
    }
    
    static func isOverdue(deadline: String) -> Bool {
        let now = Date()
        
        if let deadlineDate = firebaseDateFormatter.date(from: deadline) {
            let deadline = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: deadlineDate)!
            return now > deadline
        }
        
        return false
    }
}
