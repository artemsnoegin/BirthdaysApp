//
//  NotificationManager.swift
//  BirthdaysPushMVP
//
//  Created by Артём Сноегин on 16.11.2025.
//

import UserNotifications

class UserNotificationManager {
    
    static let shared = UserNotificationManager()
    
    private let notificationCentre = UNUserNotificationCenter.current()
    
    func setDelegate(_ delegate: UNUserNotificationCenterDelegate) {
        
        notificationCentre.delegate = delegate
    }
    
    func requestAuthorization() {
        
        // TODO: Добавить обработку ошибок
        notificationCentre.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                //
            } else {
                //
            }
        }
    }
    
    // TODO: обработка ошибки когда пользователь запретил нотификацию (.getNotificationSetting)
    func addNotification(id: String, celebrantName: String, birthday: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "Happy Birthday, \(celebrantName)!🎉"
        content.body = "\(celebrantName) is celebrating tomorrow"
        content.sound = .default
        
        guard let day = Calendar.current.date(byAdding: .day, value: -1, to: birthday),
              let time = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: day)
        else {
            print("Error setting date")
            return
        }          
        
        let components = Calendar.current.dateComponents([.day, .month, .hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCentre.add(request)
    }
    
    func removeNotification(id: String) {
        notificationCentre.removePendingNotificationRequests(withIdentifiers: [id])
    }
}
