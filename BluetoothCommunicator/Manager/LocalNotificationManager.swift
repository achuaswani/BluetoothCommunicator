//
//  LocalNotificationManager.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/19/20.
//

import Foundation
import UserNotifications

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    override init() {
        super.init()
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        self.notificationCenter.delegate = self
    }
    
    func postNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        content.body = notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                            repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
