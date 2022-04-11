//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 11/04/22.
//

import Foundation

struct Transaction {
    let id:UUID
    let title:String
    let paymentMethod:String
    let type:String
    let category:String
    let amount:Double
    let note:String?
    let transactionDate:Date
    let createdAt:Date
    let updatedAt:Date
}
