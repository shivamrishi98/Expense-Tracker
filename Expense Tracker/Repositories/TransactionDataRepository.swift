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
    func getAll() -> [Transaction]?
    func get(by id: UUID) -> Transaction?
    func get(by type:ExpenseTypeCollectionViewCell.ExpenseType) -> [Transaction]?
    func getTotalBalance() -> Double
    func getBalance(of type:ExpenseTypeCollectionViewCell.ExpenseType) -> Double
    func update(transaction: Transaction) -> Bool
    func delete(with id: UUID) -> Bool
}

struct TransactionDataRepository: TransactionRepository {
    
    func create(transaction:Transaction) {
        let cdTransaction = CDTransaction(context: PersistentStorage.shared.context)
        cdTransaction.id = transaction.id
        cdTransaction.title = transaction.title
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
    
    func getAll() -> [Transaction]? {
        let fetchRequest = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        let sortDescriptor =  [NSSortDescriptor(key: "transactionDate",
                                                ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest)
            
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
    
    func get(by id: UUID) -> Transaction? {
        let result = getCDTransaction(by: id)
        
        guard result != nil else {
            return nil
        }
        return result?.convertToTransaction()
    }
    
    func get(by type: ExpenseTypeCollectionViewCell.ExpenseType) -> [Transaction]? {
        let fetchRequest = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        let predicate = NSPredicate(format: "type==%@",type.title)
        fetchRequest.predicate = predicate
        let sortDescriptor =  [NSSortDescriptor(key: "transactionDate",
                                                ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest)
            
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
    
    func getTotalBalance() -> Double {
        let transactions = getAll()
        var balance = 0.0
        transactions?.forEach({
            switch $0.type {
            case ExpenseTypeCollectionViewCell.ExpenseType.expense.title:
                balance -= $0.amount
            case ExpenseTypeCollectionViewCell.ExpenseType.income.title:
                balance += $0.amount
            default:
                break
            }
        })
        return balance
    }
    
    func getBalance(of type:ExpenseTypeCollectionViewCell.ExpenseType) -> Double {
        let transactions = get(by: type)
        var balance = 0.0
        transactions?.forEach({
            balance += $0.amount
        })
        return balance
    }
    
    func update(transaction: Transaction) -> Bool {
        
        let cdTransaction = getCDTransaction(by: transaction.id!)
        guard cdTransaction != nil else {
            return false
        }
        
        cdTransaction?.title = transaction.title
        cdTransaction?.type = transaction.type
        cdTransaction?.category = transaction.category
        cdTransaction?.amount = transaction.amount
        cdTransaction?.note = transaction.note
        cdTransaction?.createdAt = transaction.createdAt
        cdTransaction?.updatedAt = transaction.updatedAt
        
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func delete(with id: UUID) -> Bool {
        let cdTransaction = getCDTransaction(by: id)
        guard let cdTransaction = cdTransaction else {
            return false
        }
        PersistentStorage.shared.context.delete(cdTransaction)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    private func getCDTransaction(by id:UUID) -> CDTransaction? {
        let fetchRequest = NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg )
        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
        
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
