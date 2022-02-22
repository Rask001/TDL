//
//  Tasks+CoreDataProperties.swift
//  
//
//  Created by Антон on 05.02.2022.
//
//

import Foundation
import CoreData
import UIKit


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var text: String
	  @NSManaged public var timeLabel: String?
  	@NSManaged public var timeLabelDate: Date?
  	@NSManaged public var check: Bool
	
	  //@NSManaged public var timeLabelBool: Bool
	  @NSManaged public var alarmLabelBool: Bool
	  //@NSManaged public var repeatLabelBool: Bool
	  //@NSManaged public var tag: String
}
