//
//  UserNotification.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/30.
//  Copyright © 2018 ebuser. All rights reserved.
//

import UserNotifications

class UserNotification: NSObject, Localizable {

    let localizeFileName = "Notification"

    static let current: UserNotification = {
        let instance = UserNotification()
        instance.requestAuthorization()
        return instance
    }()

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (_, _) in
            return
        }
    }

    func addAlarm(alarm: DB.AlarmModel) {
        let content = UNMutableNotificationContent()
        content.title = localize(for: "alarm title")
        content.body = alarm.name
        content.sound = UNNotificationSound.default()

        let calendar = Calendar.current
        let alarmTime = alarm.time.addingTimeInterval(-30 * 60)
        let dateInfo = calendar.dateComponents(in: .tokyoTimezone, from: alarmTime)

        var dateInfoCopy = DateComponents()
        dateInfoCopy.year = dateInfo.year
        dateInfoCopy.month = dateInfo.month
        dateInfoCopy.day = dateInfo.day
        dateInfoCopy.hour = dateInfo.hour
        dateInfoCopy.minute = dateInfo.minute
        dateInfoCopy.second = dateInfo.second

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfoCopy, repeats: false)

        let center = UNUserNotificationCenter.current()
        let request = UNNotificationRequest(identifier: alarm.identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }

    func removeAlarm(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }

}

extension UserNotification: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
