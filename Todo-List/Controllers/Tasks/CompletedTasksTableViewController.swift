//
//  CompletedTasksTableViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/20/21.
//

import UIKit

class CompletedTasksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifiers.TasksTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.TasksTableViewCell)
        
        // loads initial tasks
        update()
    }
    
    var tasks: [Task] = []
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NotificationNames.update, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func update() {
        tasks = TaskHandler.fetchTasks(complete: true, searchText: nil)

        DispatchQueue.main.async {  [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "    Completed Tasks"
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let task = tasks[indexPath.row]
        
        let complete = UIContextualAction(style: .normal, title: "Complete") { (action, view, completion) in
            TaskHandler.toggleTask(task: task)
            completion(true)
        }
        
        complete.backgroundColor = .systemGray
        complete.image = Icons.undo
        
        return complete
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let task = tasks[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            TaskHandler.deleteTask(task: task)
            completion(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = Icons.trash
        
        return delete
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TasksTableViewCell, for: indexPath) as! TasksTableViewCell
        let task = tasks[indexPath.row]
        
        let firebaseDate = task.date!
        let friendlyDate = DateHandler.getFriendlyDateString(from: firebaseDate)
                
        cell.task = task
        cell.taskLabel.text = task.title!
        cell.dateLabel.text = friendlyDate
        cell.checkboxImage.image = Icons.checkmarkCircle
        cell.mainView.backgroundColor = CustomColors.background
        cell.dateLabel.textColor = .lightGray
        cell.checkboxImage.tintColor = CustomColors.darkGreen
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
    }
}
