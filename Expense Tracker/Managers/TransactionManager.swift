//
//  TransactionManager.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 31/03/22.
//

import Foundation

struct TransactionManager {
    
    private let transactionDataRepository:TransactionDataRepository = TransactionDataRepository()
    
    func create(transaction: Transaction) {
        transactionDataRepository.create(transaction: transaction)
    }
    
    func fetchTransactions(by paymentMethod:PaymentMethod) -> [Transaction]? {
        return transactionDataRepository.getAll(of: paymentMethod)
    }
    
    func fetchTransaction(by id: UUID) -> Transaction? {
        return transactionDataRepository.get(by: id)
    }
    
    func fetchTransaction(by type:ExpenseTypeCollectionViewCell.ExpenseType,
                          paymentMethod:PaymentMethod) -> [Transaction]? {
        return transactionDataRepository.get(by: type,paymentMethod: paymentMethod)
    }
    
    func fetchTotalBalance(of paymentMethod:PaymentMethod) -> Double {
        return transactionDataRepository.getTotalBalance(for: paymentMethod)
    }
    
    func fetchBalance(of type:ExpenseTypeCollectionViewCell.ExpenseType,
                      paymentMethod:PaymentMethod) -> Double {
        return transactionDataRepository.getBalance(of: type,paymentMethod: paymentMethod)
    }
    
    func update(transaction: Transaction) -> Bool {
        return transactionDataRepository.update(transaction: transaction)
    }
    
    func delete(with id: UUID) -> Bool {
        return transactionDataRepository.delete(with: id)
    }
    
    func deleteAllTransactions() {
        return transactionDataRepository.deleteAll()
    }
    
    func searchTransactions(by value:String,paymentMethod:PaymentMethod) -> [Transaction]? {
        return transactionDataRepository.search(by: value, paymentMethod: paymentMethod)
    }
}
