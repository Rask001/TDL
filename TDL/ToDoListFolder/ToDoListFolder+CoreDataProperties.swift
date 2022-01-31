//
//  ToDoListFolder+CoreDataProperties.swift
//  
//
//  Created by Антон on 24.01.2022.
//
//

import Foundation
import CoreData


extension ToDoListFolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListFolder> {
        return NSFetchRequest<ToDoListFolder>(entityName: "ToDoListFolder")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}
