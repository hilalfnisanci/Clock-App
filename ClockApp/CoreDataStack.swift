//
//  CoreDataStack.swift
//  ClockApp
//
//  Created by Hilal on 28.02.2024.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AlarmModelCoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAlarms() -> [Alarm] {
        let fetchRequest: NSFetchRequest<Alarm> = NSFetchRequest<Alarm>(entityName: "AlarmEntity")
        do {
            let alarms = try context.fetch(fetchRequest)
            return alarms
        } catch {
            print("Error fetching alarms: \(error.localizedDescription)")
            return []
        }
    }

    func createAlarm(hours: Int16, minutes: Int16, time: String, days: [String], isActive: Bool) -> Alarm {
        let newAlarm = Alarm(context: context)
        newAlarm.id = UUID()
        newAlarm.hours = hours
        newAlarm.minutes = minutes
        newAlarm.time = time
        newAlarm.days = days
        newAlarm.isActive = isActive
        
        saveContext()
        
        return newAlarm
    }
}

