//
//  ExpenseType.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 11/04/22.
//

import Foundation

enum ExpenseType: CaseIterable {
    case income
    case expense

    var title:String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        }
    }
}
