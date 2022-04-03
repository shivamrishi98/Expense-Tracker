//
//  Extensions.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

// MARK: - Extension - UIView

extension UIView {
    func addSubviews(_ views:UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
}

// MARK: - Extension - Dateformatter

extension DateFormatter {
    static let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.calendar = .current
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    static let displayDateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.calendar = .current
        formatter.locale = .current
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
}

// MARK: - Extension - String

extension String {
    static func formattedToOriginal(date:Date) -> String {
        return DateFormatter.dateFormatter.string(from: date)
    }
    static func formatted(date:Date) -> String {
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    static func formatted(number:Double) -> String {
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: number)) ?? "nil"
    }
}

// MARK: - Extension - Date

extension Date {
    static func formatString(date:String) -> Date {
        return DateFormatter.dateFormatter.date(from: date) ?? Date()
    }
}

// MARK: - Extension - Notification.Name

extension Notification.Name {
    static let refreshTransactions:Notification.Name = Notification.Name("refreshTransactions")
    static let changeTheme:Notification.Name = Notification.Name("changeTheme")
}

// MARK: - Extension - NumberFormatter

extension NumberFormatter {
    static let currencyFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter
    }()
}
