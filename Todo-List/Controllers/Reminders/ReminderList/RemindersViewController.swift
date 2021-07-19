//
//  RemindersViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit



class RemindersViewController: UIViewController {
    @IBOutlet weak var reminderList: UITableView!
    
    var selectedTask: Task?
    var selectedType: String?
    var selectedReminder: Reminder?
    
    var reminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderList.delegate = self
        reminderList.dataSource = self
        
        reminderList.register(UINib(nibName: CellIdentifiers.AddReminderTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.AddReminderTableViewCell)
        reminderList.register(UINib(nibName: CellIdentifiers.ViewReminderTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.ViewReminderTableViewCell)
        
        ReminderHandler.listener(task: selectedTask!) { reminders, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let reminders = reminders {
                self.reminders = reminders
                
                DispatchQueue.main.async {
                    self.reminderList.reloadData()
                }
            }
        }
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onDonePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RemindersViewController: UITableViewDataSource, AddReminderTableViewCellDelegate {
    func triggerActionSheet() {
        let alert = UIAlertController(
            title: "Reminder Type",
            message: "What type of reminder would you like to set?",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "Countdown", style: .default, handler: handleReminderTypeSelectAction))
        alert.addAction(UIAlertAction(title: "Scheduled", style: .default, handler: handleReminderTypeSelectAction))
        alert.addAction(UIAlertAction(title: "Location", style: .default, handler: handleReminderTypeSelectAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count + 1
    }
    
    
    func handleReminderTypeSelectAction(action: UIAlertAction) {
        switch action.title {
        case "Countdown": performSegue(withIdentifier: Segues.editCountdownReminder, sender: self)
        case "Scheduled": performSegue(withIdentifier: Segues.editScheduledReminder, sender: self)
        case "Location": performSegue(withIdentifier: Segues.editLocationReminder, sender: self)
        default: break
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
                
        if index == reminders.count {
            let cell = reminderList.dequeueReusableCell(withIdentifier: CellIdentifiers.AddReminderTableViewCell, for: indexPath) as! AddReminderTableViewCell
            cell.delegate = self
                        
            return cell
        }
        
        let cell = reminderList.dequeueReusableCell(withIdentifier: CellIdentifiers.ViewReminderTableViewCell, for: indexPath) as! ViewReminderTableViewCell
        let reminder = reminders[index]
        
        cell.reminderIcon.image = getIcon(for: reminder)
        cell.reminderDetails.text = getTitle(for: reminder)
        
        
        return cell
    }
    
    func getIcon(for reminder: Reminder) -> UIImage? {
        if reminder is CountdownReminder {
            return Icons.clock
        }
        
        if reminder is ScheduledReminder {
            return Icons.calendar
        }
        
        if reminder is LocationReminder {
            return Icons.location
        }
        
        return Icons.bell
    }
    
    func secondsToHoursMinutesSeconds (seconds: Double) -> (Int, Int) {
      let (hr,  minf) = modf (seconds / 3600)
      let (min, _) = modf (60 * minf)
      return (Int(hr), Int(min))
    }
    
    func getTitle(for reminder: Reminder) -> String {
        if let reminder = reminder as? CountdownReminder {
            let (hours, minutes) = secondsToHoursMinutesSeconds(seconds: reminder.countdown)
            
            var titleComponents: [String] = []
            var titleCountdown: String = ""
                
            if hours != 0 {
                titleComponents.append("\(hours) hours")
            }
            
            if minutes != 0 {
                titleComponents.append("\(minutes) minutes")
            }
            
            if titleComponents.count == 1 {
                titleCountdown = titleComponents[0]
            }
            
            if titleComponents.count == 2 {
                titleCountdown = titleComponents[0] + " and " + titleComponents[1]
            }
            
            
            let titleTime = DateHandler.getTime(from: reminder.createdAt)!
            
            return "\(titleCountdown) from \(titleTime)"
        }
        
        if let reminder = reminder as? ScheduledReminder {
            return DateHandler.getDateTime(from: reminder.timestamp)!
        }
        
        if let reminder = reminder as? LocationReminder {
            return reminder.location.address
        }
        
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reminderList.deselectRow(at: indexPath, animated: true)
        selectedReminder = nil
        let index = indexPath.row
        
        if index == reminders.count {
            triggerActionSheet()
            return
        }
        
        selectedReminder = reminders[index]
        
        if selectedReminder != nil {
            print(type(of: selectedReminder))
            
            if selectedReminder is CountdownReminder {
                print("Countdown")
                performSegue(withIdentifier: Segues.editCountdownReminder, sender: self)
            }
            
            if selectedReminder is ScheduledReminder {
                print("Scheduled")
                performSegue(withIdentifier: Segues.editScheduledReminder, sender: self)
            }
            
            if selectedReminder is LocationReminder {
                print("Location")
                performSegue(withIdentifier: Segues.editLocationReminder, sender: self)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.editCountdownReminder:
            let destination = segue.destination as! CountdownReminderFormViewController
            destination.selectedTask = selectedTask
            destination.selectedReminder = selectedReminder as? CountdownReminder
            
        case Segues.editScheduledReminder:
            let destination = segue.destination as! ScheduledReminderFormViewController
            destination.selectedTask = selectedTask
            destination.selectedReminder = selectedReminder as? ScheduledReminder
            
        case Segues.editLocationReminder:
            let destination = segue.destination as! LocationReminderFormViewController
            destination.selectedTask = selectedTask
            destination.selectedReminder = selectedReminder as? LocationReminder
            
        default:
            break
        }
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let reminder = self.reminders[indexPath.row]
            ReminderHandler.deleteReminder(id: reminder.id) { error in
                completion(true)
            }
        }
        
        delete.backgroundColor = .systemRed
        delete.image = Icons.trash
        
        return delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension RemindersViewController: UITableViewDelegate {
    
}
