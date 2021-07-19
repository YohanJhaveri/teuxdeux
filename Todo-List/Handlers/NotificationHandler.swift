//
//  NotificationHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import Foundation
import UserNotifications
import CoreLocation


class NotificationHandler {
    private static func getContent(reminder: Reminder, task: Task) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = task.name
        content.body = "\(reminder.type) reminder for your task"
        return content
    }
    
    private static func getRequest(of identifier: String, with content: UNMutableNotificationContent, on trigger: UNNotificationTrigger) -> UNNotificationRequest {
        return UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
    }
    
    static func requestLocationAuthorization(completion: @escaping  (Bool) -> Void) {
        // TODO: Request location permission
        CLLocationManager().requestAlwaysAuthorization()
    }
    
    static func requestNotificationAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _  in
            // TODO: Fetch notification settings
            completion(granted)
        }
    }
    
    static func fetchNotificationSettings(completion: @escaping  (UNNotificationSettings) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings)
        }
    }
    
    static func createNotification(reminder: CountdownReminder, task: Task) {
        let content = getContent(reminder: reminder, task: task)
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: reminder.countdown,
            repeats: false
        )
        
        let request = getRequest(of: reminder.id, with: content, on: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    static func createNotification(reminder: ScheduledReminder, task: Task) {
        let content = getContent(reminder: reminder, task: task)
        
        let dateMatching = Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute],
            from: Date(timeIntervalSince1970: reminder.timestamp)
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateMatching,
            repeats: false
        )
        
        let request = getRequest(of: reminder.id, with: content, on: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    static func createNotification(reminder: LocationReminder, task: Task) {
        let content = getContent(reminder: reminder, task: task)
        
        let center = CLLocationCoordinate2D(
            latitude: reminder.location.latitude,
            longitude: reminder.location.longitude
        )

        let region = CLCircularRegion(
            center: center,
            radius: reminder.location.radius,
            identifier: reminder.id
        )
        
        let trigger = UNLocationNotificationTrigger(
            region: region,
            repeats: false
        )
        
        let request = getRequest(of: reminder.id, with: content, on: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    static func deleteNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
