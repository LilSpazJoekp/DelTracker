//
//  DeliveryDayTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/2/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryDayTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
	
	// MARK: StoryBoard Outlets
	
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	
	// MARK: StoryBoard Actions
	
	@IBAction func deleteAction(_ sender: Any) {
		indexPathsToDelete.removeAll()
		for (_, path) in selectedIndicies.enumerated() {
			let indexPath: IndexPath = [0, path]
			let context = self.fetchedResultsController.managedObjectContext
			context.delete(self.fetchedResultsController.object(at: indexPath))
		}
		let context = self.fetchedResultsController.managedObjectContext
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		table.setEditing(false, animated: true)
		editButton.title = "Edit"
		editButton.style = UIBarButtonItemStyle.plain
		deleteButton.isEnabled = false
		deleteButton.tintColor = UIColor.clear
	}
	@IBAction func editButton(_ sender: Any) {
		if !table.isEditing {
			table.setEditing(true, animated: true)
			editButton.title = "Done"
			editButton.style = UIBarButtonItemStyle.done
			deleteButton.isEnabled = false
			deleteButton.tintColor = UIColor.red
			deleteButton.setTitleWithOutAnimation(title: "Delete(0)")
		} else if table.isEditing {
			table.setEditing(false, animated: true)
			editButton.title = "Edit"
			editButton.style = UIBarButtonItemStyle.plain
			deleteButton.isEnabled = false
			deleteButton.tintColor = UIColor.clear
		}
	}
	
	// MARK: Variables and Actions
	
	var selectedIndicies: [Int] = []
	var deselectedIndexPath: Int?
	var indexPathsToDelete: [IndexPath] = []
	var mainContext: NSManagedObjectContext? = nil
	var deliveryChildContext: NSManagedObjectContext? = nil
	var _fetchedResultsController: NSFetchedResultsController<DeliveryDay>? = nil
	var fetchedResultsController: NSFetchedResultsController<DeliveryDay> {
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		let fetchRequest: NSFetchRequest<DeliveryDay> = DeliveryDay.fetchRequest()
		// Set the batch size to a suitable number.
		fetchRequest.fetchBatchSize = 20
		// Edit the sort key as appropriate.
		let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext!, sectionNameKeyPath: #keyPath(DeliveryDay.date.monthYear), cacheName: "DeliveryDayCache")
		aFetchedResultsController.delegate = self
		_fetchedResultsController = aFetchedResultsController
		do {
			try _fetchedResultsController!.performFetch()
		} catch {
			let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		return _fetchedResultsController!
	}
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
	}
	func setDeleteButtonCount() {
		if tableView.isEditing {
			if !deleteButton.isEnabled {
				deleteButton.isEnabled = true
				deleteButton.tintColor = UIColor.red
				deleteButton.setTitleWithOutAnimation(title: "Delete(" + "\(tableView.indexPathsForSelectedRows?.count ?? 0)" + ")")
			} else if deleteButton.isEnabled {
				deleteButton.setTitleWithOutAnimation(title: "Delete(" + "\(tableView.indexPathsForSelectedRows?.count ?? 0)" + ")")
			}
			if tableView.indexPathsForSelectedRows?.count == nil {
				deleteButton.isEnabled = false
			}
		}
	}

	
	// MARK: - Table View
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryDayCell", for: indexPath)
		let deliveryDay = self.fetchedResultsController.object(at: indexPath)
		self.configureCell(cell as! DeliveryDayTableViewCell, withDeliveryDay: deliveryDay)
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		setDeleteButtonCount()
		selectedIndicies.append(indexPath.row)
		if selectedIndicies.count != 0 {
		}
	}
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		setDeleteButtonCount()
		if selectedIndicies.count != 0 {
			if selectedIndicies.contains(indexPath.row) {
				let selectedIndicesFiltered = selectedIndicies.filter {
					el in el == indexPath.row
				}
				for (index, _) in selectedIndicesFiltered.enumerated() {
					deselectedIndexPath = selectedIndicesFiltered[index]
				}
				selectedIndicies.remove(at: selectedIndicies.index(of: Int(deselectedIndexPath!))!)
			}
		}
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let context = self.fetchedResultsController.managedObjectContext
			context.delete(self.fetchedResultsController.object(at: indexPath))
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			}
		}
	}
	func configureCell(_ cell: DeliveryDayTableViewCell, withDeliveryDay deliveryDay: DeliveryDay) {
		cell.dateLabel?.text = deliveryDay.date?.convertToDateString()
		cell.deliveryCount?.text = "\(deliveryDay.deliveries?.array.count ?? 0)"
		cell.totalTips?.text = deliveryDay.totalTips.convertToCurrency()
		cell.totalPay?.text = deliveryDay.totalReceived.convertToCurrency()
	}
	
	// MARK: - Fetched results controller
	
   @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.beginUpdates()
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
		case .delete:
			self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
		default:
			return
		}
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			self.configureCell(tableView.cellForRow(at: indexPath!)! as! DeliveryDayTableViewCell, withDeliveryDay: anObject as! DeliveryDay)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToDeliveryDayList(_ sender: UIStoryboardSegue) {
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !tableView.isEditing {
			return true
		} else {
			return false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tabBarViewController = segue.destination as? DeliveryTabBarViewController {
			let deliveryStatisticsNavigationController = tabBarViewController.viewControllers?[0] as! UINavigationController
			let deliveriesNavigationController = tabBarViewController.viewControllers?[1] as! UINavigationController
			let dropsNavigationController = tabBarViewController.viewControllers?[2] as! UINavigationController
			let deliveryStatisticsDestinationViewController = deliveryStatisticsNavigationController.viewControllers[0] as! DeliveryStatisticsTableViewController
			let deliveriesDestinationViewController = deliveriesNavigationController.viewControllers[0] as! DeliveryTableViewController
			let dropsDestinationViewController = dropsNavigationController.viewControllers[0] as! DropTableViewController
			if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDeliveryDayDetail" {
				deliveryStatisticsDestinationViewController.mainContext = self.fetchedResultsController.managedObjectContext
				deliveryStatisticsDestinationViewController.deliveryDay = fetchedResultsController.object(at: indexPath)
				deliveryStatisticsDestinationViewController.saved = true
				deliveriesDestinationViewController.mainContext = self.fetchedResultsController.managedObjectContext
				deliveriesDestinationViewController.deliveryDay = fetchedResultsController.object(at: indexPath)
				dropsDestinationViewController.mainContext = self.fetchedResultsController.managedObjectContext
				dropsDestinationViewController.deliveryDay = fetchedResultsController.object(at: indexPath)
				dropsDestinationViewController.saved = true
			}
		}
		if let deliveryDayDestinationViewController = segue.destination as? DeliveryDayViewController, segue.identifier == "addDeliveryDay" {
			let newDeliveryDay = DeliveryDay(context: self.fetchedResultsController.managedObjectContext)
			newDeliveryDay.date = NSDate()
			deliveryDayDestinationViewController.deliveryDay = newDeliveryDay
			deliveryDayDestinationViewController.mainContext = self.fetchedResultsController.managedObjectContext
		}
	}
}
