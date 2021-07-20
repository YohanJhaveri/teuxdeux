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
    
    static func fetchTasks(complete: Bool, searchText: String?) -> [Task] {
        var format = "done == \(complete ? "TRUE" : "FALSE")"
        var argumentArray: [Any]?
        
        // if search text exists then send query
        if let searchText = searchText {
            format += " AND title CONTAINS[cd] %@"
            argumentArray = [searchText]
        }
        
        return sendRequest(format: format, argumentArray: argumentArray)
    }
    
    private static func triggerUpdateNotification() {
        NotificationCenter.default.post(name: NotificationNames.update, object: nil)
    }
    
    private static func sendRequest(format: String, argumentArray: [Any]?) -> [Task] {
        do {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let predicate = NSPredicate(format: format, argumentArray: argumentArray)
            let sorDescriptor = NSSortDescriptor(key: "date", ascending: true)
            
            request.predicate = predicate
            request.sortDescriptors = [sorDescriptor]
            
            return try context.fetch(request)
        } catch {
            return []
        }
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
        triggerUpdateNotification()
    }
    
    static func editTask(task: Task, title: String, date: String) {
        task.title = title
        task.date = date
        
        saveContext()
        triggerUpdateNotification()
    }
    
    static func toggleTask(task: Task) {
        task.done = !task.done
        
        saveContext()
        triggerUpdateNotification()
        
        ReminderHandler.deleteRemindersOfTask(id: task.id!)
    }
    
    static func deleteTask(task: Task) {
        ReminderHandler.deleteRemindersOfTask(id: task.id!)
        
        context.delete(task)
        saveContext()
        triggerUpdateNotification()
    }
}
