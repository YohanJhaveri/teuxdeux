//
//  TaskHandler.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/12/21.
//

import Foundation
import CoreData
import UIKit


class TaskHandler {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var tasks = fetchTasks()
        
    static func fetchTasks() -> [Task] {
        var tasks: [Task] = []
        
        do {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            tasks = try context.fetch(request)
        } catch {
            print("There was an error loading context")
        }
        
        return tasks
    }
    
    private static func saveContext() {
        do {
            try context.save()
        } catch {
            print("There was an error saving context")
        }
    }
    
    static func createTask(title: String, date: String) {
        let newTask = Task(context: context)
        
        newTask.id = UUID().uuidString
        newTask.title = title
        newTask.date = date
        newTask.done = false
        
        saveContext()
    }
    
    static func editTask(task: Task, title: String, date: String) {
        task.title = title
        task.date = date
        
        saveContext()
    }
    
    static func completeTask(task: Task) {
        task.done = true
        
        saveContext()
        
        ReminderHandler.deleteRemindersOfTask(id: task.id!)
    }
    
    static func makeIncompleteTask(task: Task) {
        task.done = false
        
        saveContext()
        
        ReminderHandler.deleteRemindersOfTask(id: task.id!)
    }
    
    static func deleteTask(task: Task) {
        ReminderHandler.deleteRemindersOfTask(id: task.id!)
        
        context.delete(task)
        saveContext()
    }
}
