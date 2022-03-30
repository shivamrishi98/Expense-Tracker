//
//  DatabaseManager.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import Foundation
import CoreData

final class DatabaseManager {
    
    private init() { }
    
    static let shared = DatabaseManager()
    
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

    lazy var context = persistentContainer.viewContext
    
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
}
