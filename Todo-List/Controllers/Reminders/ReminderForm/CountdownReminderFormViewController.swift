//
//  ReminderFormViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/12/21.
//

import UIKit

class CountdownReminderFormViewController: UIViewController {
    var selectedTask: Task?
    var selectedReminder: CountdownReminder?
    
    @IBOutlet weak var countdownPicker: UIDatePicker!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedReminder = selectedReminder {
            countdownPicker.countDownDuration = selectedReminder.countdown
        }
    }

    @IBAction func onSavePressed(_ sender: UIButton) {
        var reminder: CountdownReminder
        
        if let selectedReminder = selectedReminder {
            reminder = CountdownReminder(
                id: selectedReminder.id,
                taskID: selectedReminder.taskID,
                createdAt: selectedReminder.createdAt,
                countdown: countdownPicker.countDownDuration
            )
        } else {
            reminder = CountdownReminder(
                id: UUID().uuidString,
                taskID: selectedTask?.id ?? "",
                createdAt: Date().timeIntervalSince1970,
                countdown: countdownPicker.countDownDuration
            )
        }
        
        ReminderHandler.writeReminder(reminder: reminder, task: selectedTask!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
