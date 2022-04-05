//
//  LocalNotificationsManager.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 05/04/22.
//

import UIKit

final class NotificationsManager {
    static let shared = NotificationsManager()
    private init() {}

    private let localNotificationsRepository = LocalNotificationsRepository()
    
    public func requestAuthForLocalNotifications() {
        localNotificationsRepository.requestAuthForNotifications()
    }
    
    public func scheduleLocalNotification(at date:Date) {
        localNotificationsRepository.scheduleNotification(at: date)
    }
    
}
