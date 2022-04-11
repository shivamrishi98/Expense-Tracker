//
//  TransactionDataRepository.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 30/03/22.
//

import Foundation
import CoreData

protocol TransactionRepository {
    func create(transaction:Transaction) 
    func getAll(of paymentMethod:PaymentMethod) -> [Transaction]?
    func get(by id: UUID) -> Transaction?
    func get(by type:ExpenseType,paymentMethod:PaymentMethod) -> [Transaction]?
    func getTotalBalance(for paymentMethod:PaymentMethod) -> Double
    func getBalance(of type:ExpenseType,paymentMethod:PaymentMethod) -> Double
    func update(transaction: Transaction) -> Bool
    func delete(with id: UUID) -> Bool
    func deleteAll()
    func search(by value:String,paymentMethod:PaymentMethod) -> [Transaction]?
}

struct TransactionDataRepository: TransactionRepository {
    
    func create(transaction:Transaction) {
        let cdTransaction:CDTransaction = CDTransaction(context: PersistentStorage.shared.context)
        cdTransaction.id = transaction.id
        cdTransaction.title = transaction.title
        cdTransaction.paymentMethod = transaction.paymentMethod
        cdTransaction.type = transaction.type
        cdTransaction.category = transaction.category
        cdTransaction.amount = transaction.amount
        cdTransaction.note = transaction.note
        cdTransaction.transactionDate = transaction.transactionDate
        cdTransaction.createdAt = transaction.createdAt
        cdTransaction.updatedAt = transaction.updatedAt
        PersistentStorage.shared.saveContext()
    }
    
//    func getAll() -> [Transaction]? {
//        let result = PersistentStorage.shared.fetchManagedObject(
//            managedObject: CDTransaction.self)
//
//        var transactions:[Transaction] = []
//
//        result?.forEach({ cdTransaction in
//            transactions.append(cdTransaction.convertToTransaction())
//        })
//        return transactions
//    }
    
    func getAll(of paymentMethod:PaymentMethod) -> [Transaction]? {
        let fetchRequest:NSFetchRequest<CDTransaction> = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        
        if paymentMethod != .all {
            let predicate:NSPredicate = NSPredicate(format: "paymentMethod==%@",paymentMethod.title)
            fetchRequest.predicate = predicate
        }
        
        let sortDescriptor:[NSSortDescriptor] = [NSSortDescriptor(key: "transactionDate",
                                                ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let result:[CDTransaction] = try PersistentStorage.shared.context.fetch(fetchRequest)
            
            var transactions:[Transaction] = []
            
            result.forEach({ cdTransaction in
                transactions.append(cdTransaction.convertToTransaction())
            })
            return transactions
        } catch {
            debugPrint(error)
            return []
        }
    }
    
    func get(by id: UUID) -> Transaction? {
        let result:CDTransaction? = getCDTransaction(by: id)
        
        guard result != nil else {
            return nil
        }
        return result?.convertToTransaction()
    }
    
    func get(by type: ExpenseType,
             paymentMethod:PaymentMethod) -> [Transaction]? {
        
        let fetchRequest:NSFetchRequest<CDTransaction> = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        let typePredicate:NSPredicate = NSPredicate(format: "type==%@",type.title)
        
        if paymentMethod != .all {
            let paymentMethodPredicate = NSPredicate(format: "paymentMethod==%@",paymentMethod.title)
            let compoundPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    typePredicate,
                    paymentMethodPredicate
                    
                ])
            fetchRequest.predicate = compoundPredicate
        } else {
            fetchRequest.predicate = typePredicate
        }
        
        let sortDescriptor:[NSSortDescriptor] =  [NSSortDescriptor(key: "transactionDate",
                                                ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let result:[CDTransaction] = try PersistentStorage.shared.context.fetch(fetchRequest)
            
            var transactions:[Transaction] = []
            
            result.forEach({ cdTransaction in
                transactions.append(cdTransaction.convertToTransaction())
            })
            return transactions
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    func getTotalBalance(for paymentMethod:PaymentMethod) -> Double {
        let transactions:[Transaction]? = getAll(of: paymentMethod)
        var balance:Double = 0.0
        transactions?.forEach({
            switch $0.type {
            case ExpenseType.expense.title:
                balance -= $0.amount
            case ExpenseType.income.title:
                balance += $0.amount
            default:
                break
            }
        })
        return balance
    }
    
    func getBalance(of type:ExpenseType,
                    paymentMethod:PaymentMethod) -> Double {
        let transactions:[Transaction]? = get(by: type,paymentMethod: paymentMethod)
        var balance:Double = 0.0
        transactions?.forEach({
            balance += $0.amount
        })
        return balance
    }
    
    func update(transaction: Transaction) -> Bool {
        
        let cdTransaction:CDTransaction? = getCDTransaction(by: transaction.id)
        
        guard cdTransaction != nil else {
            return false
        }
        
        cdTransaction?.title = transaction.title
        cdTransaction?.paymentMethod = transaction.paymentMethod
        cdTransaction?.type = transaction.type
        cdTransaction?.category = transaction.category
        cdTransaction?.amount = transaction.amount
        cdTransaction?.note = transaction.note
        cdTransaction?.transactionDate = transaction.transactionDate
        cdTransaction?.updatedAt = transaction.updatedAt
        
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func delete(with id: UUID) -> Bool {
        let cdTransaction:CDTransaction? = getCDTransaction(by: id)
        guard let cdTransaction = cdTransaction else {
            return false
        }
        PersistentStorage.shared.context.delete(cdTransaction)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func deleteAll() {
        let result:[CDTransaction]? = PersistentStorage.shared.fetchManagedObject(
            managedObject: CDTransaction.self)
        
        result?.forEach({ cdTransaction in
            PersistentStorage.shared.context.delete(cdTransaction)
            PersistentStorage.shared.saveContext()
        })
    }
    
    func search(by value:String,paymentMethod:PaymentMethod) -> [Transaction]? {
        let fetchRequest:NSFetchRequest<CDTransaction> = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        let titlePredicate:NSPredicate = NSPredicate(format: "title CONTAINS[c] %@", value as CVarArg)
        let categoryPredicate:NSPredicate = NSPredicate(format: "category ==[c] %@", value as CVarArg)
        let compoundPredicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: [
                titlePredicate,
                categoryPredicate
            ])
        
        if paymentMethod != .all {
            let paymentMethodPredicate:NSPredicate = NSPredicate(
                format: "paymentMethod==%@",
                paymentMethod.title)
            let compoundPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: [
                paymentMethodPredicate,
                compoundPredicate
            ])
            fetchRequest.predicate = compoundPredicates
        } else {
            fetchRequest.predicate = compoundPredicate
        }
        
        let sortDescriptor:[NSSortDescriptor] = [NSSortDescriptor(key: "transactionDate",
                                                ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let result:[CDTransaction] = try PersistentStorage.shared.context.fetch(fetchRequest)
            
            var transactions:[Transaction] = []
            
            result.forEach({ cdTransaction in
                transactions.append(cdTransaction.convertToTransaction())
            })
            return transactions
        } catch {
            debugPrint(error)
            return []
        }
    }
    
    private func getCDTransaction(by id:UUID) -> CDTransaction? {
        let fetchRequest:NSFetchRequest<CDTransaction> = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        let predicate:NSPredicate = NSPredicate(format: "id==%@", id as CVarArg )
        fetchRequest.predicate = predicate
        do {
            let result:CDTransaction? = try PersistentStorage.shared.context.fetch(fetchRequest).first
        
            guard result != nil else {
                return nil
            }
            
            return result
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
}
