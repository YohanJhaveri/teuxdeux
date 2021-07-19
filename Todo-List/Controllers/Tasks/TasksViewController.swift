//
//  TasksViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {
    @IBOutlet weak var taskList: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var tasks: [Task] = []
    var selectedTask: Task? = nil
    
    let auth = Auth.auth()
    let firestore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskList.delegate = self
        taskList.dataSource = self
        taskList.register(UINib(nibName: CellIdentifiers.TasksTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.TasksTableViewCell)
        addTaskButton.layer.cornerRadius = 30
        
        TaskHandler.listener { tasks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let tasks = tasks {
                self.tasks = tasks
                
                DispatchQueue.main.async {
                    self.taskList.reloadData()
                }
            }
        }
    }
}

/* swiping actions */

extension TasksViewController {
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let complete = UIContextualAction(style: .normal, title: "Complete") { (action, view, completionHandler) in
            let checkedTask = self.tasks.remove(at: indexPath.row)
            
            TaskHandler.completeTask(id: checkedTask.id) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                print("Task with id \(checkedTask.id) marked complete")
            }
            
            completionHandler(true)
        }
        
        complete.backgroundColor = .systemGreen
        complete.image = Icons.checkmark
        
        return complete
    }
    
    func remindersAction(at indexPath: IndexPath) -> UIContextualAction {
        let reminders = UIContextualAction(style: .normal, title: "Reminders") { (action, view, completionHandler) in
            self.selectedTask = self.tasks[indexPath.row]
            self.performSegue(withIdentifier: Segues.viewReminders, sender: self)
            completionHandler(true)
        }
        
        reminders.backgroundColor = .systemOrange
        reminders.image = Icons.bell
        
        return reminders
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.selectedTask = self.tasks[indexPath.row]
            self.performSegue(withIdentifier: Segues.editTask, sender: self)
            completionHandler(true)
        }
        
        edit.backgroundColor = .systemBlue
        edit.image = Icons.calendar
        
        return edit
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let removedTask = self.tasks.remove(at: indexPath.row)
            
            TaskHandler.deleteTask(id: removedTask.id) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                print("Task with id \(removedTask.id) deleted")
            }
            
            completion(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = Icons.trash
        
        return delete
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskList.dequeueReusableCell(withIdentifier: CellIdentifiers.TasksTableViewCell, for: indexPath) as! TasksTableViewCell
        let task = tasks[indexPath.row]
        
        let firebaseDate = task.date
        let friendlyDate = DateHandler.getFriendlyDateString(from: firebaseDate)
                
        cell.taskID = task.id
        cell.taskLabel.text = task.name
        cell.dateLabel.text = friendlyDate
                
        if DateHandler.isOverdue(deadline: firebaseDate) {
            cell.mainView.backgroundColor = CustomColors.error
            cell.dateLabel.textColor = CustomColors.darkError
            cell.checkboxImage.tintColor = CustomColors.darkError
        } else {
            cell.mainView.backgroundColor = CustomColors.background
            cell.dateLabel.textColor = .lightGray
            cell.checkboxImage.tintColor = CustomColors.darkGreen
        }
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        let reminders = remindersAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit, reminders])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: Segues.editTask, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.editTask {
            let destination = segue.destination as! TaskFormViewController
            destination.selectedTask = selectedTask!
        }
        
        if segue.identifier == Segues.viewReminders {
            let destination = segue.destination as! RemindersViewController
            destination.selectedTask = selectedTask!
        }
    }
}
