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
    
    func fetchTransactions() -> [Transaction]? {
        return transactionDataRepository.getAll()
    }
    
    func fetchTransaction(by id: UUID) -> Transaction? {
        return transactionDataRepository.get(by: id)
    }
    
    func fetchTransaction(by type:ExpenseTypeCollectionViewCell.ExpenseType) -> [Transaction]? {
        return transactionDataRepository.get(by: type)
    }
    
    func fetchTotalBalance() -> Double {
        return transactionDataRepository.getTotalBalance()
    }
    
    func fetchBalance(of type:ExpenseTypeCollectionViewCell.ExpenseType) -> Double {
        return transactionDataRepository.getBalance(of: type)
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
}
