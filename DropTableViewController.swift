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
	var selectedIndicies: [Int] = []
	var deselectedIndexPath: Int?
	var indexPathsToDelete: [IndexPath] = []
	var deliveryDayViewController: DeliveryDayViewController?
	var managedObjectContext: NSManagedObjectContext? = nil
	private let persistentContainer = NSPersistentContainer(name: "DelTracker")
	fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Drop> = {
		let fetchRequest: NSFetchRequest<Drop> = Drop.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
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
		}
		NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
	}
	override func viewDidAppear(_ animated: Bool) {
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
	func applicationDidEnterBackground(_ notification: Notification) {
		do {
			try persistentContainer.viewContext.save()
		} catch {
			print("Unable to Save Changes")
			print("\(error), \(error.localizedDescription)")
		}
	}
	func saveDropContext() {
		do {
			try persistentContainer.viewContext.save()
		} catch {
			print("Unable to Save Drop")
			print("\(error), \(error.localizedDescription)")
		}
	}
	
	// MARK: Table View
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//tableView.deselectRow(at: indexPath, animated: true)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let drops = fetchedResultsController.fetchedObjects else {
			return 0
		}
		return drops.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "dropCell", for: indexPath) as? DropTableViewCell else {
			fatalError("Unexpected Index Path")
		}
		configure(cell, at: indexPath)
		return cell
	}
	func configure(_ cell: DropTableViewCell, at indexPath: IndexPath) {
		let drop = fetchedResultsController.object(at: indexPath)
		cell.amount.text = drop.amount.convertToCurrency()
		cell.dropTime.text = drop.time?.convertToTimeString()
		cell.dropNumber.text = "\(indexPath.row + 1)"
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let drop = fetchedResultsController.object(at: indexPath)
			drop.managedObjectContext?.delete(drop)
		}
	}
	
	// MARK: - Fetched Results Controller
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()  
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch (type) {
		case .insert:
			if let indexPath = newIndexPath {
				tableView.insertRows(at: [indexPath], with: .fade)
			}
			saveDropContext()
			break
		case .delete:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			saveDropContext()
			break
		case .update:
			if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DropTableViewCell {
				configure(cell, at: indexPath)
			}
			saveDropContext()
			break
		case .move:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			if let newIndexPath = newIndexPath {
				tableView.insertRows(at: [newIndexPath], with: .fade)
			}
			saveDropContext()
			break
		}
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
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
		destinationViewController.managedObjectContext = persistentContainer.viewContext
		if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDropDetail" {
			destinationViewController.drop = fetchedResultsController.object(at: indexPath)
		}
	}
}/*
extension ViewController: NSFetchedResultsControllerDelegate {

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
tableView.beginUpdates()
}

func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
tableView.endUpdates()

updateView()
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
switch (type) {
case .insert:
if let indexPath = newIndexPath {
tableView.insertRows(at: [indexPath], with: .fade)
}
break;
case .delete:
if let indexPath = indexPath {
tableView.deleteRows(at: [indexPath], with: .fade)
}
break;
case .update:
if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DropTableViewCell {
configure(cell, at: indexPath)
}
break;
case .move:
if let indexPath = indexPath {
tableView.deleteRows(at: [indexPath], with: .fade)
}

if let newIndexPath = newIndexPath {
tableView.insertRows(at: [newIndexPath], with: .fade)
}
break;
}
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

}

}

extension ViewController: UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
guard let drops = fetchedResultsController.fetchedObjects else {
return 0
}
return drops.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
guard let cell = tableView.dequeueReusableCell(withIdentifier: DropTableViewCell.reuseIdentifier, for: indexPath) as? DropTableViewCell else {
fatalError("Unexpected Index Path")
}

// Configure Cell
configure(cell, at: indexPath)

return cell
}

func configure(_ cell: DropTableViewCell, at indexPath: IndexPath) {
// Fetch Drop
let drop = fetchedResultsController.object(at: indexPath)

// Configure Cell
cell.authorLabel.text = drop.author
cell.contentsLabel.text = drop.contents
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
if editingStyle == .delete {
// Fetch Drop
let drop = fetchedResultsController.object(at: indexPath)

// Delete Drop
drop.managedObjectContext?.delete(drop)
}
}

}

extension ViewController: UITableViewDelegate {

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
tableView.deselectRow(at: indexPath, animated: true)
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
cell.amount.text = convertToCurrency(drop.amount)
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
}*/
