
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
	
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	@IBAction func deleteAction(_ sender: Any) {/*
		indexPathsToDelete.removeAll()
		for (_, path) in selectedIndicies.enumerated() {
			let deliveryDay = deliveryDays[path]
			if !deliveryDay.manual {
				let indexPath: IndexPath = [0, path]
				indexPathsToDelete.append(indexPath)
				deliveryDays.remove(at: path)
			} else {
				deliveryDays.remove(at: path)
			}
		}
		table.deleteRows(at: indexPathsToDelete, with: .fade)
		saveDeliveryDays()*/
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
	var deliveryDayView: DeliveryDayViewController?
	var deliveryDays = [DeliveryDay]()
	var selectedIndicies: [Int] = []
	var deselectedIndexPath: Int?
	var indexPathsToDelete: [IndexPath] = []
	var deliveryDayViewController: DeliveryDayViewController?
	var managedObjectContext: NSManagedObjectContext? = nil
	static var deliveryDayDrops: [Drop] = []
	private let persistentContainer = NSPersistentContainer(name: "DelTracker")
	fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DeliveryDay> = {
		let fetchRequest: NSFetchRequest<DeliveryDay> = DeliveryDay.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
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
	func saveDeliveryDayContext() {
		do {
			try persistentContainer.viewContext.save()
		} catch {
			print("Unable to Save DeliveryDay")
			print("\(error), \(error.localizedDescription)")
		}
	}
	
	// MARK: Table View
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//tableView.deselectRow(at: indexPath, animated: true)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let deliveryDays = fetchedResultsController.fetchedObjects else {
			return 0
		}
		return deliveryDays.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryDayCell", for: indexPath) as? DeliveryDayTableViewCell else {
			fatalError("Unexpected Index Path")
		}
		configure(cell, at: indexPath)
		return cell
	}
	func configure(_ cell: DeliveryDayTableViewCell, at indexPath: IndexPath) {
		let deliveryDay = fetchedResultsController.object(at: indexPath)
		cell.dateLabel?.text = deliveryDay.date?.convertToDateString()
		cell.deliveryCount?.text = "\(deliveryDay.deliveries?.count)"
		cell.totalTips?.text = deliveryDay.totalTips.convertToCurrency()
		cell.totalPay?.text = deliveryDay.totalReceived.convertToCurrency()
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let deliveryDay = fetchedResultsController.object(at: indexPath)
			deliveryDay.managedObjectContext?.delete(deliveryDay)
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
			saveDeliveryDayContext()
			break
		case .delete:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			saveDeliveryDayContext()
			break
		case .update:
			if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DeliveryDayTableViewCell {
				configure(cell, at: indexPath)
			}
			saveDeliveryDayContext()
			break
		case .move:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			if let newIndexPath = newIndexPath {
				tableView.insertRows(at: [newIndexPath], with: .fade)
			}
			saveDeliveryDayContext()
			break
		}
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
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
		guard let destinationViewController = segue.destination as? DeliveryDayViewController else {
			return
		}
		destinationViewController.managedObjectContext = persistentContainer.viewContext
		if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDeliveryDayDetail" {
			destinationViewController.deliveryDay = fetchedResultsController.object(at: indexPath)
		}
	}
}
/*
var deliveryDays = [DeliveryDay]()
var selectedIndicies: [Int] = []
var deselectedIndexPath: Int?
var indexPathsToDelete: [IndexPath] = []
static var status: String = ""
static var manual: Bool?
var insertRows: IndexPath? = nil
var newRows: IndexPath? = nil
override func viewDidLoad() {
super.viewDidLoad()
insertRows?.removeFirst()
newRows?.removeFirst()
self.clearsSelectionOnViewWillAppear = true
deleteButton.isEnabled = false
deleteButton.tintColor = UIColor.clear
self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)

}

// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
return 1
}
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return deliveryDays.count
}
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let deliveryDay = deliveryDays[indexPath.row]
let cellIdentifier = "deliveryDayCell"
let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeliveryDayTableViewCell
cell.dateLabel?.text = deliveryDay.date?.convertToDateString()
cell.deliveryCount?.text = "\(deliveryDay.deliveries?.count)"
cell.totalTips?.text = deliveryDay.totalTips.convertToCurrency()
cell.totalPay?.text = deliveryDay.totalReceived.convertToCurrency()
let backgroundView = UIView()
backgroundView.backgroundColor = UIColor.darkGray
cell.selectedBackgroundView = backgroundView
return cell
}
override func viewDidAppear(_ animated: Bool) {
table.reloadSections(IndexSet.init(integer: 0), with: .fade)
}
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
return true
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
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
if editingStyle == .delete {
let deliveryDay = deliveryDays[indexPath.row]
removeDelivery(deliveryDate: deliveryDay.deliveryDateValue)
deliveryDays.remove(at: indexPath.row)
tableView.deleteRows(at: [indexPath], with: .fade)
saveDeliveryDays()
}
}
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
let tempItemToMove = deliveryDays[fromIndexPath.row]
deliveryDays.remove(at: fromIndexPath.row)
deliveryDays.insert(tempItemToMove, at: to.row)
saveDeliveryDays()
}

// MARK: - Navigation

@IBAction func unwindToDeliveryDayList(_ sender: UIStoryboardSegue) {
if let sourceViewController = sender.source as? DeliveryStatisticsTableViewController, let deliveryDay = sourceViewController.deliveryDay {
if let selectedIndexPath = tableView.indexPathForSelectedRow {
deliveryDays[selectedIndexPath.row] = deliveryDay
tableView.reloadRows(at: [selectedIndexPath], with: .right)
} else {
let newIndexPath = IndexPath(row: 0, section: 0)
deliveryDays.insert(deliveryDay, at: 0)
tableView.insertRows(at: [newIndexPath], with: .bottom)
}
}
saveDeliveryDays()
}
override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
if !tableView.isEditing {
return true
} else {
return false
}
}
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if !tableView.isEditing {
if segue.identifier == "showDetail" {
let deliveryDayDetailViewController = segue.destination as! DeliveryDayViewController
if let selectedDeliveryDayCell = sender as? DeliveryDayTableViewCell {
let indexPath = tableView.indexPath(for: selectedDeliveryDayCell)!
let selectedDeliveryDay = deliveryDays[indexPath.row]
deliveryDayDetailViewController.deliveryDay = selectedDeliveryDay
DeliveryDayViewController.manualStatus = selectedDeliveryDay.manual
DeliveryDayTableViewController.status = String(indexPath.row)
}
} else if segue.identifier == "addItem" {
DeliveryDayTableViewController.status = "adding"
}
}
}

// MARK: NSCoding

func saveDeliveryDays() {
let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveryDays, toFile: DeliveryDay.ArchiveURL.path)
if !isSuccessfulSave {
print("save Failed")
}
}
func loadDeliveryDays() -> [DeliveryDay]? {
return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
}
func removeDelivery(deliveryDate: String) {
let fileManager = FileManager.default
let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
guard let dirPath = paths.first else {
return
}
let filePath = "\(dirPath)/\(deliveryDate)"
do {
try fileManager.removeItem(atPath: filePath)
} catch let error as NSError {
print(error.debugDescription)
}
}
func removeFile(fileName: String) {
let fileManager = FileManager.default
let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
guard let dirPath = paths.first else {
return
}
let filePath = "\(dirPath)/\(fileName)"
do {
try fileManager.removeItem(atPath: filePath)
} catch let error as NSError {
print(error.debugDescription)
}
printDirectoryContents()
}
func printDirectoryContents() {
let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
do {
let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
print(directoryContents)
} catch let error as NSError {
print(error.localizedDescription)
}
}
}

/*
class DeliveryDayTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
@IBOutlet var table: UITableView!
@IBOutlet var editButton: UIBarButtonItem!
@IBOutlet var deleteButton: UIBarButtonItem!
@IBAction func deleteAction(_ sender: Any) {
indexPathsToDelete.removeAll()
for (_, path) in selectedIndicies.enumerated() {
let deliveryDay = deliveryDays[path]
if !deliveryDay.manual {
print(path)
let indexPath: IndexPath = [0, path]
indexPathsToDelete.append(indexPath)
removeDelivery(deliveryDate: deliveryDay.deliveryDateValue)
deliveryDays.remove(at: path)
} else {
deliveryDays.remove(at: path)
}
}
table.deleteRows(at: indexPathsToDelete, with: .fade)
saveDeliveryDays()
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
var deliveryDayView: DeliveryDayViewController?
var deliveryDays = [DeliveryDay]()
var selectedIndicies: [Int] = []
var deselectedIndexPath: Int?
var indexPathsToDelete: [IndexPath] = []
static var status: String = ""
static var manual: Bool?
var insertRows: IndexPath? = nil
var newRows: IndexPath? = nil
override func viewDidLoad() {
super.viewDidLoad()
insertRows?.removeFirst()
newRows?.removeFirst()
self.clearsSelectionOnViewWillAppear = true
deleteButton.isEnabled = false
deleteButton.tintColor = UIColor.clear
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

// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
return 1
}
override func viewDidAppear(_ animated: Bool) {
table.reloadSections(IndexSet.init(integer: 0), with: .fade)
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
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
return true
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
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
let tempItemToMove = deliveryDays[fromIndexPath.row]
deliveryDays.remove(at: fromIndexPath.row)
deliveryDays.insert(tempItemToMove, at: to.row)
saveDeliveryDays()
}

// MARK: - Navigation

@IBAction func unwindToDeliveryDayList(_ sender: UIStoryboardSegue) {
if let sourceViewController = sender.source as? DeliveryStatisticsTableViewController, let deliveryDay = sourceViewController.deliveryDay {
if let selectedIndexPath = tableView.indexPathForSelectedRow {
deliveryDays[selectedIndexPath.row] = deliveryDay
tableView.reloadRows(at: [selectedIndexPath], with: .right)
} else {
let newIndexPath = IndexPath(row: 0, section: 0)
deliveryDays.insert(deliveryDay, at: 0)
tableView.insertRows(at: [newIndexPath], with: .bottom)
}
}
saveDeliveryDays()
}
override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
if !tableView.isEditing {
return true
} else {
return false
}
}
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
guard let destinationViewController = segue.destination as? DeliveryDayViewController else {
return
}
destinationViewController.managedObjectContext = persistentContainer.viewContext
if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDetail" {
destinationViewController.deliveryDay = fetchedResultsController.object(at: indexPath)
}
}
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if !tableView.isEditing {
if segue.identifier == "showDetail" {
let deliveryDayDetailViewController = segue.destination as! DeliveryDayViewController
if let selectedDeliveryDayCell = sender as? DeliveryDayTableViewCell {
let indexPath = tableView.indexPath(for: selectedDeliveryDayCell)!
let selectedDeliveryDay = deliveryDays[indexPath.row]
deliveryDayDetailViewController.deliveryDay = selectedDeliveryDay
DeliveryDayViewController.manualStatus = selectedDeliveryDay.manual
DeliveryDayTableViewController.status = String(indexPath.row)
}
} else if segue.identifier == "addItem" {
DeliveryDayTableViewController.status = "adding"
}
}
}
var managedObjectContext: NSManagedObjectContext? = nil
private let persistentContainer = NSPersistentContainer(name: "DelTracker")
fileprivate lazy var fetchedResultsController: NSFetchedResultsController<DeliveryDay> = {
let fetchRequest: NSFetchRequest<DeliveryDay> = DeliveryDay.fetchRequest()
fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
fetchedResultsController.delegate = self
return fetchedResultsController
}()

// MARK: View Life Cycle


func applicationDidEnterBackground(_ notification: Notification) {
do {
try persistentContainer.viewContext.save()
} catch {
print("Unable to Save Changes")
print("\(error), \(error.localizedDescription)")
}
}
func saveDeliveryDayContext() {
do {
try persistentContainer.viewContext.save()
} catch {
print("Unable to Save DeliveryDay")
print("\(error), \(error.localizedDescription)")
}
}

// MARK: Table View


override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
guard let deliveryDays = fetchedResultsController.fetchedObjects else {
return 0
}
return deliveryDays.count
}
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
guard let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryDayCell", for: indexPath) as? DeliveryDayTableViewCell else {
fatalError("Unexpected Index Path")
}
configure(cell, at: indexPath)
return cell
}
func configure(_ cell: DeliveryDayTableViewCell, at indexPath: IndexPath) {
let deliveryDay = fetchedResultsController.object(at: indexPath)
cell.dateLabel?.text = deliveryDay.date?.convertToDateString()
cell.deliveryCount?.text = "\(deliveryDay.deliveries?.count)"
cell.totalTips?.text = deliveryDay.totalTips.convertToCurrency()
cell.totalPay?.text = deliveryDay.totalReceived.convertToCurrency()
let backgroundView = UIView()
backgroundView.backgroundColor = UIColor.darkGray
cell.selectedBackgroundView = backgroundView

}
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
if editingStyle == .delete {
let deliveryDay = fetchedResultsController.object(at: indexPath)
deliveryDay.managedObjectContext?.delete(deliveryDay)
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
saveDeliveryDayContext()
break
case .delete:
if let indexPath = indexPath {
tableView.deleteRows(at: [indexPath], with: .fade)
}
saveDeliveryDayContext()
break
case .update:
if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DeliveryDayTableViewCell {
configure(cell, at: indexPath)
}
saveDeliveryDayContext()
break
case .move:
if let indexPath = indexPath {
tableView.deleteRows(at: [indexPath], with: .fade)
}
if let newIndexPath = newIndexPath {
tableView.insertRows(at: [newIndexPath], with: .fade)
}
saveDeliveryDayContext()
break
}
}
func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
}

// MARK: - Navigation

@IBAction func unwindToDeliveryDayList(_ sender: UIStoryboardSegue) {
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
guard let destinationViewController = segue.destination as? DeliveryDayViewController else {
return
}
destinationViewController.managedObjectContext = persistentContainer.viewContext
if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDetail" {
destinationViewController.DeliveryDay = fetchedResultsController.object(at: indexPath)
}
}

// MARK: NSCoding

func saveDeliveryDays() {
let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveryDays, toFile: DeliveryDay.ArchiveURL.path)
if !isSuccessfulSave {
print("save Failed")
}
}
func loadDeliveryDays() -> [DeliveryDay]? {
return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
}
func removeDelivery(deliveryDate: String) {
let fileManager = FileManager.default
let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
guard let dirPath = paths.first else {
return
}
let filePath = "\(dirPath)/\(deliveryDate)"
do {
try fileManager.removeItem(atPath: filePath)
} catch let error as NSError {
print(error.debugDescription)
}
}
func removeFile(fileName: String) {
let fileManager = FileManager.default
let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
guard let dirPath = paths.first else {
return
}
let filePath = "\(dirPath)/\(fileName)"
do {
try fileManager.removeItem(atPath: filePath)
} catch let error as NSError {
print(error.debugDescription)
}
printDirectoryContents()
}
func printDirectoryContents() {
let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
do {
let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
print(directoryContents)
} catch let error as NSError {
print(error.localizedDescription)
}
}
}
*/*/
