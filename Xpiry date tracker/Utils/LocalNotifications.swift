//
//  LocalNotifications.swift
//  Xpiry date tracker
//
//  Created by Gladys Lionardi on 08/04/25.
//

import SwiftUI
import Foundation
import UserNotifications

class NotifManager {
    
    static let instance = NotifManager()
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {success, error in
//            if let error = error {
//                print("ERROR NOTIF: \(error)")
//            } else {
//                print ("success notif")
//            }
            
        }
    }
    
    // schedule notifications for all items
    func scheduleNotification(for item: ItemEntity){
        
        guard let expDate = item.exp else {return}
        
        // schedule for reminders
        
        let baseID = item.id?.uuidString ?? UUID().uuidString
        for i in (0...3).reversed(){
            if let notifyDate = Calendar.current.date(byAdding: .day, value: -i, to: expDate){
                scheduleNotificationHelper(
                    title: "Expiry Reminder",
                    body: "\(item.name ?? "") is about to expire in \(i) day(s)!",
                    date: notifyDate,
                    identifier: "exp-h\(i)-\(baseID)"
                )
            }
        }
        
        // post expiry
        if let postExpStart = Calendar.current.date(byAdding: .day, value: 1, to: expDate){
            scheduleDailyNotifPostExp(
                title: "Expired Item",
                body: "\(item.name ?? "") has expired!",
                startDate: postExpStart,
                identifier: "exp-daily-\(baseID)")
        }
    }
    
    func cancelNotif(for item: ItemEntity){
        guard let baseID = item.id?.uuidString else {return}
        let identifiers = (0...3).map { "exp-h\($0)-\(baseID)" } + ["exp-daily-\(baseID)"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private func scheduleNotificationHelper (title: String, body: String, date: Date, identifier: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = body
        content.sound = .default
//        content.badge = 1
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = 7
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("ERROR NOTIF: \(error)")
//            }
        }
        
    }
    
    private func scheduleDailyNotifPostExp (title: String, body: String, startDate: Date, identifier: String){
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
        dateComponents.hour = 7
        dateComponents.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = body
        content.sound = .default
//        content.badge = 1
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Repeating notification error: \(error)")
//            }
        }
        
    }
}



//struct LocalNotifications: View{
//    var body: some View {
//        VStack(spacing: 40){
//            Button("Request permission") {
//                NotifManager.instance.requestAuthorization()
//            }
//        }
//    }
//}
//
//
//struct LocalNotifications_Preview: PreviewProvider{
//    static var previews: some View{
//        LocalNotifications()
//    }
//}
