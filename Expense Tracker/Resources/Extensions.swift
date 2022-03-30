//
//  Extensions.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

// MARK: - EXTENSION - UIView

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

extension String {
    static func formattedToOriginal(date:Date) -> String {
        return DateFormatter.dateFormatter.string(from: date)
    }
    static func formattedDate(date:Date) -> String {
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}

extension Date {
    static func formattString(date:String) -> Date {
        return DateFormatter.dateFormatter.date(from: date) ?? Date()
    }
}
