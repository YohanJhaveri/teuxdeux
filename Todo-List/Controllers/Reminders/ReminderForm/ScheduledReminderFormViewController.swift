//
//  ScheduledReminderFormViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/13/21.
//

import UIKit

class ScheduledReminderFormViewController: UIViewController {
    var selectedTask: Task?
    var selectedReminder: ScheduledReminder?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedReminder = selectedReminder {
            datePicker.date = Date(timeIntervalSince1970: selectedReminder.timestamp)
        }
    }

    @IBAction func onSavePressed(_ sender: UIButton) {
        var reminder: ScheduledReminder
        
        if let selectedReminder = selectedReminder {
            reminder = ScheduledReminder(
                id: selectedReminder.id,
                taskID: selectedReminder.taskID,
                createdAt: selectedReminder.createdAt,
                timestamp: datePicker.date.timeIntervalSince1970
            )
        } else {
            reminder = ScheduledReminder(
                id: UUID().uuidString,
                taskID: selectedTask?.id ?? "",
                createdAt: Date().timeIntervalSince1970,
                timestamp: datePicker.date.timeIntervalSince1970
            )
        }
        
        ReminderHandler.writeReminder(reminder: reminder, task: selectedTask!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
