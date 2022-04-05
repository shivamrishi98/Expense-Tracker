//
//  LocalNotificationsRepository.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 05/04/22.
//

import Foundation
import UserNotifications

protocol NotificationsRepository {
    func requestAuthForNotifications()
    func scheduleNotification(at date:Date)
}

final class LocalNotificationsRepository:NotificationsRepository {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    struct NotificationContent {
        let title:String
        let body:String
        let sound:UNNotificationSound
    }
    
    public func requestAuthForNotifications() {
        let options:UNAuthorizationOptions = [.alert,.badge,.sound]
        notificationCenter.requestAuthorization(options: options) { _, error in
            guard let _ = error else {
                return
            }
        }
    }
    
    public func scheduleNotification(at date:Date) {
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let strongSelf = self else {
                return
            }
            if settings.authorizationStatus == .authorized {
                let notificationContent = strongSelf.createNotificationContent(
                    with: .init(title: "Where are you?",
                                body: "Expense tracker is waiting for you to track your expenses.",
                                sound: .default))
                
                let calendarTrigger = strongSelf.createCalendarTrigger(with: date)
                
                let request = UNNotificationRequest(
                    identifier: "local_notification",
                    content: notificationContent,
                    trigger: calendarTrigger)
                
                strongSelf.notificationCenter.add(request) { error in
                    guard let _ = error else {
                        return
                    }
                }
                
            } else {
                print("Permission declined")
            }
        }
    }
    
    private func createNotificationContent(with content:NotificationContent) -> UNMutableNotificationContent{
        let notification = UNMutableNotificationContent()
        notification.title = content.title
        notification.body = content.body
        notification.sound = content.sound
        return notification
    }
    
    private func createCalendarTrigger(with date:Date) -> UNCalendarNotificationTrigger {
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second],
                                                            from: date)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponent,
            repeats: false)
        return trigger
    }
    
}
