//
//  CDTransaction+CoreDataProperties.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 31/03/22.
//
//

import Foundation
import CoreData


extension CDTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransaction> {
        return NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var transactionDate: Date?

    func convertToTransaction() -> Transaction {
        return Transaction(id: self.id,
                           title: self.title,
                           type: self.type,
                           category: self.category,
                           amount: self.amount,
                           note: self.note,
                           transactionDate:self.transactionDate,
                           createdAt: self.createdAt,
                           updatedAt: self.updatedAt)
    }
    
}

extension CDTransaction : Identifiable {

}
