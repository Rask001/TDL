//
//  AppDelegate.swift
//  TDL
//
//  Created by Антон on 19.01.2022.
//

import UIKit
import CoreData
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


var window: UIWindow?
	
	
	let firstVC = ViewController()
	let secondVC = SecondVC()
	let notificationCenter = UNUserNotificationCenter.current()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
									 [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let firstNavController = UINavigationController(rootViewController: firstVC)
	  let secondNavController = UINavigationController(rootViewController: secondVC)
	
		
		
		let tabBarVC = UITabBarController()
		tabBarVC.setViewControllers([firstNavController, secondNavController], animated: true)
		tabBarVC.tabBar.backgroundColor = UIColor(named: "BGColor")
		firstVC.loadViewIfNeeded()  //подгружает значек таб бара при запуске
		secondVC.loadViewIfNeeded()  //подгружает значек таб бара при запуске
		
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = tabBarVC
		window?.makeKeyAndVisible()
		
		//запрос на локальные уведомления, request local notification
		notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
			guard success else { return }
			self.notificationCenter.getNotificationSettings { (settings) in
				guard settings.authorizationStatus == .authorized else { return }
			}
		}
		notificationCenter.delegate = self
		return true
		
	}


	
	
	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "Model")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()
	

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

//MARK: NOTIFICATION EXTENSION
extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.sound, .banner])
		print("уведомление в то время как приложение открыто")
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		print("тут можно что-нибудь сделать когда пользователь нажимает на уведомление")
	}
}
