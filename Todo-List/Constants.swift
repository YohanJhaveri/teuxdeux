//
//  K.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/7/21.
//

import Foundation
import UIKit

struct CustomColors {
    static let inputError = UIColor.init(named: "inputError")
    static let lightGreen = UIColor.init(named: "lightGreen")
    static let darkGreen = UIColor.init(named: "darkGreen")
    static let error = UIColor.init(named: "error")
    static let darkError = UIColor.init(named: "darkError")
    static let background = UIColor.init(named: "background")
}

struct Segues {
    static let entryToLogin = "entryToLogin"
    static let startToList = "startToList"
    static let loginToList = "loginToList"
    static let editTask = "editTask"
    static let viewReminders = "viewReminders"
    static let editCountdownReminder = "editCountdownReminder"
    static let editScheduledReminder = "editScheduledReminder"
    static let editLocationReminder = "editLocationReminder"
}

struct Icons {
    static let checkmark = UIImage(systemName: "checkmark")
    static let checkmarkCircle = UIImage(systemName: "checkmark.circle.fill")
    static let bell = UIImage(systemName: "bell.fill")
    static let calendar = UIImage(systemName: "calendar")
    static let trash = UIImage(systemName: "trash.fill")
    static let circle = UIImage(systemName: "circle")
    static let clock = UIImage(systemName: "clock.fill")
    static let location = UIImage(systemName: "location.fill")
    static let undo = UIImage(systemName: "arrow.counterclockwise")
}

struct CellIdentifiers {
    static let TasksTableViewCell = "TasksTableViewCell"
    static let ViewReminderTableViewCell = "ViewReminderTableViewCell"
    static let AddReminderTableViewCell = "AddReminderTableViewCell"
}

struct Defaults {
    static let hasAccount = "hasAccount"
    static let accountEmail = "accountEmail"
}

struct NotificationNames {
    static let update = Notification.Name("update")
}
