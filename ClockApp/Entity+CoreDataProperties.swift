//
//  Entity+CoreDataProperties.swift
//  ClockApp
//
//  Created by Hilal on 21.02.2024.
//
//

import Foundation
import CoreData


extension AlarmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmEntity> {
        return NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var hours: Int16
    @NSManaged public var minutes: Int16
    @NSManaged public var time: String?
    @NSManaged public var days: NSObject?
    @NSManaged public var isActive: Bool

}
