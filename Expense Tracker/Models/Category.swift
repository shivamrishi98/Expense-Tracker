//
//  Category.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 11/04/22.
//

import Foundation

enum Category {
    enum Income: CaseIterable  {
        case salary
        case refunds
        case rental
        case dividends
        case others
        case none
        
        var title:String {
            switch self {
            case .salary:
                return "Salary"
            case .refunds:
                return "Refunds"
            case .rental:
                return "Rental"
            case .dividends:
                return "Dividends"
            case .others:
                return "Others"
            case .none:
                return ""
            }
        }
        
        var iconName:String {
            switch self {
            case .salary:
                return "wallet.pass"
            case .refunds:
                return "arrow.triangle.2.circlepath.circle"
            case .rental:
                return "house.circle"
            case .dividends:
                return "chart.xyaxis.line"
            case .others:
                return "square.grid.2x2"
            case .none:
                return ""
            }
        }
    }
    enum Expense: CaseIterable  {
        case transportation
        case rent
        case food
        case bills
        case entertainment
        case shopping
        case insurance
        case tax
        case cigarette
        case health
        case sport
        case baby
        case pet
        case beauty
        case electronics
        case alcohol
        case grocery
        case gift
        case education
        case others
        case none
        
        var title:String {
            switch self {
            case .transportation:
                return "Transportation"
            case .rent:
                return "Rent"
            case .food:
                return "Food"
            case .bills:
                return "Bills"
            case .entertainment:
                return "Entertainment"
            case .shopping:
                return "Shopping"
            case .insurance:
                return "Insurance"
            case .tax:
                return "Tax"
            case .cigarette:
                return "Cigarette"
            case .health:
                return "Health"
            case .sport:
                return "Sports"
            case .baby:
                return "Baby"
            case .pet:
                return "Pet"
            case .beauty:
                return "Beauty"
            case .electronics:
                return "Electronics"
            case .alcohol:
                return "Alcohol"
            case .grocery:
                return "Grocery"
            case .gift:
                return "Gift"
            case .education:
                return "Education"
            case .others:
                return "Others"
            case .none:
                return ""
            }
        }
        
        var iconName:String {
            switch self {
            case .transportation:
                return "bus"
            case .rent:
                return "house.circle"
            case .food:
                return "fork.knife.circle"
            case .bills:
                return "creditcard.circle"
            case .entertainment:
                return "gamecontroller"
            case .shopping:
                return "bag.circle"
            case .insurance:
                return "checkmark.shield"
            case .tax:
                return "newspaper.circle"
            case .cigarette:
                return "pencil.circle"
            case .health:
                return "heart.text.square"
            case .sport:
                return "sportscourt"
            case .baby:
                return "bed.double.circle"
            case .pet:
                return "person.circle"
            case .beauty:
                return "eyebrow"
            case .electronics:
                return "tv.circle"
            case .alcohol:
                return "person.circle"
            case .grocery:
                return "cart.circle"
            case .gift:
                return "gift.circle"
            case .education:
                return "book.circle"
            case .others:
                return "square.grid.2x2"
            case .none:
                return ""
            }
        }
    }
}
