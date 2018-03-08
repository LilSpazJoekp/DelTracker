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
	var dropChildContext: NSManagedObjectContext? = nil
	var setDate: String?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
	}
	override func viewDidAppear(_ animated: Bool) {
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
	
	// MARK: CoreData
	
	
	
	// MARK: - Table View
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "dropCell", for: indexPath) as! DropTableViewCell
		let drop = self.fetchedResultsController.object(at: indexPath)
		self.configureCell(cell, atIndexPath: indexPath, withDrop: drop)
		return cell
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
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func configureCell(_ cell: DropTableViewCell, atIndexPath indexPath: IndexPath, withDrop drop: Drop) {
		cell.dropNumber.text = "\(indexPath.row + 1)"
		cell.amount.text = drop.amount.convertToCurrency()
		cell.dropTime.text = drop.time?.convertToTimeString()
    }
	
	// MARK: - Fetched results controller
	
	var fetchedResultsController: NSFetchedResultsController<Drop> {
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		
		let fetchRequest: NSFetchRequest<Drop> = Drop.fetchRequest()
		
		// Set the batch size to a suitable number.
		fetchRequest.fetchBatchSize = 20
		
		// Edit the sort key as appropriate.
		let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
		
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext!, sectionNameKeyPath: nil, cacheName: "Master")
		aFetchedResultsController.delegate = self
		_fetchedResultsController = aFetchedResultsController
		
		do {
			try _fetchedResultsController!.performFetch()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
		
		return _fetchedResultsController!
	}
	var _fetchedResultsController: NSFetchedResultsController<Drop>? = nil
	
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
		destinationViewController.drops = drops
		if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDropDetail" {
			destinationViewController.drop = fetchedResultsController.object(at: indexPath)
		}
	}
}
