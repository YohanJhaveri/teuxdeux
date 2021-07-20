//
//  TasksViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit

class TasksViewController: UIViewController {
    @IBOutlet weak var taskList: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var tasks: [Task] = TaskHandler.fetchTasks()
    var selectedTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskList.delegate = self
        taskList.dataSource = self
        taskList.register(UINib(nibName: CellIdentifiers.TasksTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.TasksTableViewCell)
        addTaskButton.layer.cornerRadius = 30
    
        TaskHandler.delegate = self
    }
}

/* swiping actions */

extension TasksViewController {
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let complete = UIContextualAction(style: .normal, title: "Complete") { (action, view, completion) in
            let checkedTask = self.tasks.remove(at: indexPath.row)
            TaskHandler.completeTask(task: checkedTask)
            completion(true)
        }
        
        complete.backgroundColor = .systemGreen
        complete.image = Icons.checkmark
        
        return complete
    }
    
    func remindersAction(at indexPath: IndexPath) -> UIContextualAction {
        let reminders = UIContextualAction(style: .normal, title: "Reminders") { (action, view, completion) in
            self.selectedTask = self.tasks[indexPath.row]
            self.performSegue(withIdentifier: Segues.viewReminders, sender: self)
            completion(true)
        }
        
        reminders.backgroundColor = .systemOrange
        reminders.image = Icons.bell
        
        return reminders
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.selectedTask = self.tasks[indexPath.row]
            self.performSegue(withIdentifier: Segues.editTask, sender: self)
            completion(true)
        }
        
        edit.backgroundColor = .systemBlue
        edit.image = Icons.calendar
        
        return edit
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let removedTask = self.tasks.remove(at: indexPath.row)
            TaskHandler.deleteTask(task: removedTask)
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
        
        let firebaseDate = task.date!
        let friendlyDate = DateHandler.getFriendlyDateString(from: firebaseDate)
                
        cell.task = task
        cell.taskLabel.text = task.title!
        cell.dateLabel.text = friendlyDate
        
        if task.done {
            cell.checkboxImage.image = Icons.checkmarkCircle
        } else {
            cell.checkboxImage.image = Icons.circle
        }
                
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
        tableView.deselectRow(at: indexPath, animated: true)
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

//extension TasksViewController: TasksViewControllerDelegate {
//    func createTaskInView(task: Task) {
//        tasks.append(task)
//        reloadTable()
//    }
//
//    func updateTaskInView(task: Task) {
//        tasks = tasks.map { task.id == $0.id ? task : $0 }
//        reloadTable()
//    }
//
//    func deleteTaskInView(task: Task) {
//        tasks = tasks.filter { task.id != $0.id }
//        reloadTable()
//    }
//
//    func reloadTable() {
//        DispatchQueue.main.async {
//            self.taskList.reloadData()
//        }
//    }
//}
