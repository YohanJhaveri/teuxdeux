////
////  TaskHandler.swift
////  Todo-List
////
////  Created by Yohan Jhaveri on 7/12/21.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//protocol TasksViewControllerDelegate {
//    func createTaskInView(task: Task)
//    func updateTaskInView(task: Task)
//    func deleteTaskInView(task: Task)
//}
//
//class TaskHandler {
//    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    static var delegate: TasksViewControllerDelegate!
//    
//    static func fetchTasks() -> [Task] {
//        var tasks: [Task] = []
//        
//        do {
//            let request: NSFetchRequest<Task> = Task.fetchRequest()
//            tasks = try context.fetch(request)
//        } catch {
//            print("There was an error loading context")
//        }
//        
//        return tasks
//    }
//    
//    private static func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("There was an error saving context")
//        }
//    }
//    
//    static func createTask(title: String, date: String) {
//        let newTask = Task(context: context)
//        
//        newTask.id = UUID().uuidString
//        newTask.title = title
//        newTask.date = date
//        newTask.done = false
//        
//        saveContext()
//        
//        delegate.createTaskInView(task: newTask)
//    }
//    
//    static func editTask(task: Task, title: String, date: String) {
//        task.title = title
//        task.date = date
//        
//        saveContext()
//        
//        delegate.updateTaskInView(task: task)
//    }
//    
//    static func completeTask(task: Task) {
//        task.done = true
//        
//        saveContext()
//        
//        delegate.deleteTaskInView(task: task)
//        ReminderHandler.deleteRemindersOfTask(id: task.id!)
//    }
//    
//    static func deleteTask(task: Task) {
//        context.delete(task)
//        saveContext()
//        
//        delegate.deleteTaskInView(task: task)
//        ReminderHandler.deleteRemindersOfTask(id: task.id!)
//    }
//}
