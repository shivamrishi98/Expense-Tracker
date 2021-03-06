//
//  DatabaseManager.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import Foundation
import CoreData

final class PersistentStorage {
    
    private init() { }
    
    static let shared:PersistentStorage = PersistentStorage()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Expense_Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    lazy var context:NSManagedObjectContext = persistentContainer.viewContext
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(
                managedObject.fetchRequest()) as? [T] else {
                return nil
            }
            return result
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
}
