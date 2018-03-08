//
//  DropTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DropTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
	
	// MARK: StoryBoard Outlets
	
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	
	// MARK: StoryBoard Actions
	
	@IBAction func deleteAction(_ sender: Any) {
		indexPathsToDelete.removeAll()
		for (_, path) in selectedIndicies.enumerated() {
			print(path)
			let indexPath: IndexPath = [0, path]
			indexPathsToDelete.append(indexPath)
			//print(indexPathsToDelete)
			//removeDrop(dropDate: "drops" + DeliveryDayViewController.selectedDateGlobal)
			drops.remove(at: path)
		}
		table.deleteRows(at: indexPathsToDelete, with: .fade)
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
	
	// MARK: Variables
	
	var drops = [Drop]()
	var deliveryDay: DeliveryDay?
	var selectedIndicies: [Int] = []
	var deselectedIndexPath: Int?
	var indexPathsToDelete: [IndexPath] = []
	var deliveryDayViewController: DeliveryDayViewController?
	var mainContext: NSManagedObjectContext? = nil
	var saved = false
	var _fetchedResultsController: NSFetchedResultsController<Drop>? = nil
	var fetchedResultsController: NSFetchedResultsController<Drop> {
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		let deliveryDayObjectID = deliveryDay?.objectID
		let parentDeliveryDay = mainContext?.object(with: deliveryDayObjectID!) as? DeliveryDay
		let fetchRequest: NSFetchRequest<Drop> = Drop.fetchRequest()
		fetchRequest.fetchBatchSize = 20
		let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let predicate = NSPredicate(format: "deliveryDay == %@", parentDeliveryDay!)
		fetchRequest.predicate = predicate
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext!, sectionNameKeyPath: nil, cacheName: "DropCache")
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
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		table.reloadData()
	}
	
	// MARK: Actions
	
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
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let dropCount = self.fetchedResultsController.fetchedObjects?.count
		return dropCount!
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "dropCell", for: indexPath) as! DropTableViewCell
		let drop = self.fetchedResultsController.object(at: indexPath)
		self.configureCell(cell, atIndexPath: indexPath, withDrop: drop)
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = backgroundView
		return cell
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let context = self.fetchedResultsController.managedObjectContext
			context.delete(self.fetchedResultsController.object(at: indexPath))
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			}
		}
	}
	func configureCell(_ cell: DropTableViewCell, atIndexPath indexPath: IndexPath, withDrop drop: Drop) {
		cell.dropNumber.text = "\(indexPath.row + 1)"
		cell.amount.text = drop.amount.convertToCurrency()
		cell.dropTime.text = drop.time?.convertToTimeString()
	}
	
	// MARK: - Fetched results controller
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
			self.configureCell(tableView.cellForRow(at: indexPath!)! as! DropTableViewCell, atIndexPath: indexPath!, withDrop: anObject as! Drop)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToDropList(_ sender: UIStoryboardSegue) {
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !tableView.isEditing {
			return true
		} else {
			return false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destinationViewController = segue.destination as? DropViewController else {
			return
		}
		destinationViewController.mainContext = mainContext
		destinationViewController.deliveryDay = deliveryDay
		destinationViewController.saved = saved
		if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDropDetail" {
			destinationViewController.drop = fetchedResultsController.object(at: indexPath)
		}
	}
}
