//
//  DropTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DropTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
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
		//save
		
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
	var drops = [Drop]()
	var selectedIndicies: [Int] = []
	var deselectedIndexPath: Int?
	var indexPathsToDelete: [IndexPath] = []
	var deliveryDayViewController: DeliveryDayViewController?
	var managedObjectContext: NSManagedObjectContext? = nil
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		//self.navigationItem.leftBarButtonItem = self.editButtonItem
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
	}
	override func viewDidAppear(_ animated: Bool) {
		let context = self.fetchedResultsController.managedObjectContext
		let request = NSFetchRequest<Drop>(entityName: "Drop")
		do {
			let results = try context.fetch(request)
			if results.count > 0 {
				for result in results {
					context.delete(result)
					do {
						try context.save()
					} catch {
						let nserror = error as NSError
						fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
					}
				}
			}
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
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
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "dropCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DropTableViewCell
		let drop = self.fetchedResultsController.object(at: indexPath)
		self.configureCell(cell, withDrop: drop, indexPath: indexPath)
		return cell
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	func configureCell(_ cell: DropTableViewCell, withDrop drop: Drop, indexPath: IndexPath) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hh:mm:ss a"
		//let formattedTime = dateFormatter.string(from: drop.dropTime as! Date)
		cell.dropAmount.text = convertToCurrency(drop.dropAmount)
		cell.dropNumber.text = "\(indexPath.row)"
		//cell.dropTime.text = formattedTime
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
		let sortDescriptor = NSSortDescriptor(key: "dropTime", ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "Drop", cacheName: "Master")
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
			self.configureCell(tableView.cellForRow(at: indexPath!)! as! DropTableViewCell, withDrop: anObject as! Drop, indexPath: indexPath!)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToDropList(_ sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? DropViewController, let drop = sourceViewController.drop {
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				drops[selectedIndexPath.row] = drop
				tableView.reloadRows(at: [selectedIndexPath], with: .right)
			} else {
				let newIndexPath = IndexPath(row: drops.count, section: 0)
				drops.append(drop)
				tableView.insertRows(at: [newIndexPath], with: .bottom)
			}
		}
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !tableView.isEditing {
			return true
		} else {
			return false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDropDetail" {
			let dropDetailViewController = segue.destination as! DropViewController
			if let selectedDropCell = sender as? DropTableViewCell {
				let indexPath = tableView.indexPath(for: selectedDropCell)!
				let selectedDrop = drops[indexPath.row]
				dropDetailViewController.drop = selectedDrop
			}
		}
	}
	func convertToCurrency(_ inputDouble: Double) -> String {
		let outputString = "$" + "\(String(format: "%.2f", inputDouble))"
		return outputString
	}
	func convertToTime(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hh:mm:ss a"
		let time = dateFormatter.string(from: date)
		return time
	}
	
	// MARK: NSCoding
	
	
	func loadDrops() -> [Drop]? {
		let coreDataStack = UIApplication.shared.delegate as! AppDelegate
		// UIApplication.shared().delegate as! AppDelegate is now UIApplication.shared.delegate as! AppDelegate
		let context = coreDataStack.persistentContainer.viewContext
		let request = NSFetchRequest<Drop>(entityName: "Drop")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMddyy"
		let dateFormatted = dateFormatter.date(from: DeliveryDayViewController.selectedDateGlobal)
		dateFormatter.dateFormat = "MMM d, yyyy"
		let dateFormattedFinal = dateFormatter.string(from: dateFormatted!)
		//request.predicate = NSPredicate(format: "dropTime = %@", dateFormattedFinal)
		request.returnsObjectsAsFaults = false
		do {
			let results = try context.fetch(request)
		return results as [Drop]
		} catch {
			print("Request failed")
			return []
		}
	}
	/*
	func removeDrop(dropDate: String) {
	let fileManager = FileManager.default
	let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
	let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
	let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
	guard let dirPath = paths.first else {
	return
	}
	let filePath = "\(dirPath)/\(dropDate)"
	do {
	try fileManager.removeItem(atPath: filePath)
	} catch let error as NSError {
	print(error.debugDescription)
	}
	}
	*/
}
