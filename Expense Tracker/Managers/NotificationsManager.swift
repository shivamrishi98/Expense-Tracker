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

    private let notificationsRepository = LocalNotificationsRepository()
    
    public func requestAuthForNotifications() {
        notificationsRepository.requestAuthForNotifications()
    }
    
    public func scheduleNotification(at date:Date) {
        notificationsRepository.scheduleNotification(at: date)
    }
    
}
