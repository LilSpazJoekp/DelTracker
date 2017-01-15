//
//  DeliveryDayViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/2/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryDayViewController : UIViewController, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {
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
	var deliveryTableViewController: DeliveryTableViewController? = nil
	var delivery: Delivery?
	var deliveryDay: DeliveryDay?
	var deliveryDays = [DeliveryDay]()
	var deliveryDateViewController = DeliveryDayViewController.self
	var managedObjectContext: NSManagedObjectContext?
	static var selectedDateGlobal: String = "010116"
	static var totalReceivedValue: String = "$0.00"
	static var whoMadeBankName: String = "None"
	static var whoClosedBankName: String = "None"
	static var manualStatus: Bool?
	var selectedDate: String = ""
	convenience required init(selectedDate: String) {
		self.init(selectedDate: DeliveryDayViewController.selectedDateGlobal)
		self.selectedDate = selectedDate
	}
	private let persistentContainer = NSPersistentContainer(name: "DelTracker")
	fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DeliveryDay> = {
		let fetchRequest: NSFetchRequest<DeliveryDay> = DeliveryDay.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
		let predicate = self.deliveryDatePicker.date.setDateForPredicate()
		fetchRequest.predicate = NSPredicate(format: "date == %@", predicate)
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if deliveryDay != nil {
			deliveryDatePicker.isEnabled = false
		}
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
		if saveDayButton === sender as AnyObject? {/*
			if let savedDeliveryDays = loadDeliveryDays() {
				deliveryDays += savedDeliveryDays
				let deliveryDayDetailViewController = segue.destination as? DeliveryStatisticsTableViewController
				if DeliveryDayTableViewController.status != "adding" {
					let selectedDeliveryDayCell = Int(DeliveryDayTableViewController.status)
					let indexPath = selectedDeliveryDayCell
					let selectedDeliveryDay = deliveryDays[indexPath!]
					deliveryDayDetailViewController?.deliveryDay = selectedDeliveryDay
					let deliveryDateValue = deliveryDay?.deliveryDateValue
					let deliveryDayCountValue = deliveryDay?.deliveryDayCountValue
					let totalTipsValue = deliveryDay?.totalTipsValue
					let totalReceivedValue = deliveryDay?.totalReceivedValue
					DeliveryDayViewController.totalReceivedValue = (deliveryDay?.totalReceivedValue)!
					DeliveryDayViewController.whoMadeBankName = (deliveryDay?.whoMadeBankName)!
					DeliveryDayViewController.whoClosedBankName = (deliveryDay?.whoClosedBankName)!
					DeliveryDayViewController.manualStatus = selectedDeliveryDay.manual
					let whoMadeBankName = deliveryDay?.whoMadeBankName
					let whoClosedBankName = deliveryDay?.whoClosedBankName
					let manual = selectedDeliveryDay.manual
					deliveryDay = DeliveryDay(deliveryDateValue: deliveryDateValue!, deliveryDayCountValue: deliveryDayCountValue!, totalTipsValue: totalTipsValue!, totalReceivedValue: totalReceivedValue!, whoMadeBankName: whoMadeBankName!, whoClosedBankName: whoClosedBankName!, manual: manual)
				}
			}*/
		}
	}
	
	
	
	// MARK: CoreData
	/*
	func saveDeliveryDays() {
		setDeliveryDayTime()
		guard let managedObjectContext = managedObjectContext else {
			return
		}
		if drop == nil {
			let newDeliveryDay = DeliveryDay(context: managedObjectContext)
			if var amount = dropTextField.text {
				newDeliveryDay.amount = amount.removeDollarSign()
				newDeliveryDay.time = selectedTime as NSDate?
			}
			drop = newDeliveryDay
		}
		if let drop = drop {
			if var amount = dropTextField.text {
				drop.amount = amount.removeDollarSign()
				drop.time = selectedTime as NSDate?
			}
			_ = navigationController?.popViewController(animated: true)
		}
	}*/
}
