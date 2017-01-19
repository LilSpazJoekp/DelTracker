//
//  DeliveryDayViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/2/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryDayViewController : UIViewController, UINavigationControllerDelegate {
	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
	}
	@IBAction func daySaveButton(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "edit", sender: saveDayButton)
	}
	@IBAction func cancelButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBOutlet var deliveryDatePicker: UIDatePicker!
	@IBOutlet var addDayButton: UIBarButtonItem!
	@IBOutlet var saveDayButton: AnyObject?
	
	// MARK: Variable and Constants
	
	var deliveryTableViewController: DeliveryTableViewController? = nil
	var delivery: Delivery?
	var deliveryDay: DeliveryDay?
	var deliveryDays = [DeliveryDay]()
	var deliveryDateViewController = DeliveryDayViewController.self
	var mainContext: NSManagedObjectContext? = nil
	override func viewDidLoad() {
		super.viewDidLoad()
		
		deliveryDatePicker.setValue(UIColor.white, forKey: "textColor")
	}
	override func viewDidAppear(_ animated: Bool) {
		if DeliveryStatisticsTableViewController.shortcutAction == "addDeliveryShortcut" {
			performSegue(withIdentifier: "edit", sender: self)
		} else if DeliveryStatisticsTableViewController.shortcutAction == "viewDeliveriesShortcut" {
			performSegue(withIdentifier: "edit", sender: self)
			
		}/*
		persistentContainer.loadPersistentStores {
		(persistentStoreDescription, error) in
		if let error = error {
		print("Unable to Load Persistent Store")
		print("\(error), \(error.localizedDescription)")
		} else {
		do {
		try self.fetchedResultsController.performFetch()
		} catch {
		let fetchError = error as NSError
		print("Unable to Perform Fetch Request")
		print("\(fetchError), \(fetchError.localizedDescription)")
		}
		}
		}*/
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		setDeliveryDay()
		guard let tabBarViewController = segue.destination as? DeliveryTabBarViewController else {
			return
		}
		guard let mainContext = mainContext else {
			return
		}
		self.navigationController?.isNavigationBarHidden = true
		let deliveryStatisticsNavigationController = tabBarViewController.viewControllers?[0] as! UINavigationController
		let deliveriesNavigationController = tabBarViewController.viewControllers?[1] as! UINavigationController
		let dropsNavigationController = tabBarViewController.viewControllers?[2] as! UINavigationController
		let deliveryStatisticsDestinationViewController = deliveryStatisticsNavigationController.viewControllers[0] as! DeliveryStatisticsTableViewController
		let deliveriesDestinationViewController = deliveriesNavigationController.viewControllers[0] as! DeliveryTableViewController
		let dropsDestinationViewController = dropsNavigationController.viewControllers[0] as! DropTableViewController
		deliveryStatisticsDestinationViewController.mainContext = mainContext
		deliveryStatisticsDestinationViewController.deliveryDay = deliveryDay
		deliveriesDestinationViewController.setDate = (deliveryDay?.date?.convertToDateString())!
		deliveriesDestinationViewController.deliveryDay = deliveryDay
		dropsDestinationViewController.mainContext = mainContext
		dropsDestinationViewController.drops = deliveryDay?.drops?.array as! [Drop]
		dropsDestinationViewController.setDate = (deliveryDay?.date?.convertToDateString())!
	}
	
	// MARK: CoreData
	
	func setDeliveryDay() {
		guard let mainContext = mainContext else {
			return
		}
		if deliveryDay == nil {
			let newDeliveryDay = DeliveryDay(context: mainContext)
			newDeliveryDay.date = deliveryDatePicker.date as NSDate?
			deliveryDay = newDeliveryDay
		}
	}
}
