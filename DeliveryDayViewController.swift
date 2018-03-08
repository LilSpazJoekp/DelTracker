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
	var deliveryChildContext: NSManagedObjectContext? = nil
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		deliveryDatePicker.setValue(UIColor.white, forKey: "textColor")
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		if DeliveryStatisticsTableViewController.shortcutAction == "addDeliveryShortcut" {
			performSegue(withIdentifier: "edit", sender: self)
		} else if DeliveryStatisticsTableViewController.shortcutAction == "viewDeliveriesShortcut" {
			performSegue(withIdentifier: "edit", sender: self)
			
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tabBarViewController = segue.destination as? DeliveryTabBarViewController {
			setDeliveryDay()
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
			deliveriesDestinationViewController.mainContext = mainContext
			deliveriesDestinationViewController.deliveryDay = deliveryDay
			dropsDestinationViewController.mainContext = mainContext
			dropsDestinationViewController.deliveryDay = deliveryDay			
		}
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
		} else if let deliveryDay = deliveryDay {
			deliveryDay.date = deliveryDatePicker.date as NSDate?
		}
	}
}
