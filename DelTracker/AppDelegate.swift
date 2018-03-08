//
//  AppDelegate.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
	var window: UIWindow?
	var delivery: Delivery?
	var deliveryTableViewController: DeliveryTableViewController?
	var deliveryDay: DeliveryDay?
	var deliveryDays = [DeliveryDay]()
	var launchedShortcutItem: UIApplicationShortcutItem?
	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	var shortcutViewController = UIViewController()
	enum ShortcutIdentifier: String {
		case First
		case Second
		
		// MARK: - Initializers
		
		init?(fullType: String) {
			guard let last = fullType.components(separatedBy: ".").last else {
				return nil
			}
			self.init(rawValue: last)
		}
		
		// MARK: - Properties
		
		var type: String {
			return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
		}
	}
	func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
		let handled = false
		
		// Verify that the provided `shortcutItem`'s `type` is one handled by the application.
		guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else {
			return false
		}
		guard (shortcutItem.type as String?) != nil else {
			return false
		}/*
		switch (shortCutType) {
		case ShortcutIdentifier.First.type:
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMddyy"
			DeliveryDayViewController.selectedDateGlobal = dateFormatter.string(from: NSDate() as Date)
			Delivery.ArchiveURL = Delivery.DocumentsDirectory.appendingPathComponent("\(DeliveryDayViewController.selectedDateGlobal)")
			//Drop.ArchiveURL = Drop.DocumentsDirectory.appendingPathComponent("\(DeliveryDayViewController.selectedDateGlobal)")
			shortcutViewController = storyboard.instantiateViewController(withIdentifier: "deliveryTableViewController") as! DeliveryDayViewController
			if let aWindow = window {
				aWindow.rootViewController?.present(shortcutViewController, animated: true, completion: nil)
			}
			DeliveryStatisticsTableViewController.shortcutAction = "addDeliveryShortcut"
			handled = true
			break
		case ShortcutIdentifier.Second.type:
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMddyy"
			DeliveryDayViewController.selectedDateGlobal = dateFormatter.string(from: NSDate() as Date)
			Delivery.ArchiveURL = Delivery.DocumentsDirectory.appendingPathComponent("\(DeliveryDayViewController.selectedDateGlobal)")
			//Drop.ArchiveURL = Drop.DocumentsDirectory.appendingPathComponent("\(DeliveryDayViewController.selectedDateGlobal)")
			shortcutViewController = storyboard.instantiateViewController(withIdentifier: "deliveryTableViewController") as! DeliveryDayViewController
			if let aWindow = window {
				aWindow.rootViewController?.present(shortcutViewController, animated: true, completion: nil)
			}
			DeliveryStatisticsTableViewController.shortcutAction = "viewDeliveriesShortcut"
			handled = true
			break
		default:
			break
		}*/
		return handled
	}
	
	// MARK: - Application Life Cycle
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		/*guard let shortcut = launchedShortcutItem else {
			return
		}
		handleShortCutItem(shortcut)*/
		launchedShortcutItem = nil
	}
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
        // Override point for customization after application launch.
        
		let mainContext = self.persistentContainer.viewContext
		let dropChildContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		dropChildContext.parent = mainContext
		let deliveryChildContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		deliveryChildContext.parent = mainContext
		let tabBarViewController = self.window!.rootViewController as! UITabBarController
		let statisticsNavigationController = tabBarViewController.viewControllers?[0] as! UINavigationController
		tabBarViewController.delegate = self
		let deliveryDayTableNaigationController = tabBarViewController.viewControllers?[1] as! UINavigationController
		let statisticsTableViewController = statisticsNavigationController.topViewController as! DeliveryDayStatisticsTableViewController
		let deliveryDayTableViewController = deliveryDayTableNaigationController.topViewController as! DeliveryDayTableViewController
		statisticsTableViewController.mainContext = mainContext
		deliveryDayTableViewController.mainContext = mainContext
		deliveryDayTableViewController.dropChildContext = dropChildContext
		deliveryDayTableViewController.deliveryChildContext = deliveryChildContext
		return true
		// Override point for customization after application launch.
		/*var shouldPerformAdditionalDelegateHandling = true
		// If a shortcut was launched, display its information and take the appropriate action
		if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
			launchedShortcutItem = shortcutItem
			// This will block "performActionForShortcutItem:completionHandler" from being called.
			shouldPerformAdditionalDelegateHandling = false
		}
		return shouldPerformAdditionalDelegateHandling*/
	}
	/*
	Called when the user activates your application by selecting a shortcut on the home screen, except when
	application(_:,willFinishLaunchingWithOptions:) or application(_:didFinishLaunchingWithOptions) returns `false`.
	You should handle the shortcut in those callbacks and return `false` if possible. In that case, this
	callback is used if your application is already launched in the background.
	*/
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		let handledShortCutItem = handleShortCutItem(shortcutItem)
		completionHandler(handledShortCutItem)
	}
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use thi
	}
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveDeliveryDayContext()
	}
	
	var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "DelTracker")
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
	
	func saveDeliveryDayContext() {
		let deliveryDayContext = persistentContainer.viewContext
		if deliveryDayContext.hasChanges {
			do {
				try deliveryDayContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
