//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Yohan Jhaveri on 7/15/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: String?
    @NSManaged public var done: Bool
    @NSManaged public var name: String?
    @NSManaged public var date: String?

}
