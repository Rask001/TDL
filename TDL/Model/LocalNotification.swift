//
//  LocalNotification.swift
//  TDL
//
//  Created by Антон on 18.02.2022.
//


import UserNotifications


func sendReminderNotification(_ title: String, _ body: String, _ date: Date){
	let content = UNMutableNotificationContent()
	content.title = title
	content.sound = .default
	content.body = body
	
	
	let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
	
	
	let request = UNNotificationRequest(identifier: "id_\(title)", content: content, trigger: trigger)
	UNUserNotificationCenter.current().add(request) { error in
		if error != nil {
			print(error?.localizedDescription as Any)
		}
	}
}