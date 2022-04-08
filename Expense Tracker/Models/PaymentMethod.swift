//
//  PaymentMethod.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 08/04/22.
//

import Foundation

enum PaymentMethod: CaseIterable {
    case all
    case cash
    case online
    
    var title:String {
        switch self {
        case .all:
            return "All"
        case .cash:
            return "Cash"
        case .online:
            return "Online"
        }
    }
}
