//
//  PersonTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/7/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class PersonTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	// MARK: Storyboard Outlets
	
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	
	// MARK: Storyboard Actions
	
	@IBAction func saveButton(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "unwindToDeliveryStatisticsTableListSegue", sender: self)
	}
	@IBAction func editButton(_ sender: UIBarButtonItem) {/*
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
	
	// MARK: Variables
	
	var people = [Person]()
	var selectedWhoMadeBankIndexPath: IndexPath = IndexPath(row: 0, section: 0)
	var selectedWhoClosedBankIndexPath: IndexPath = IndexPath(row: 0, section: 0)
	var whoMadeBank: Person?
	var whoClosedBank: Person?
	var whoMadeBankSelectedPerson: String?
	var whoClosedBankSelectedPerson: String?
	var mainContext: NSManagedObjectContext? = nil
	private let persistentContainer = NSPersistentContainer(name: "DelTracker2")
	fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
		let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		fetchRequest.returnsObjectsAsFaults = false
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
					self.people = self.fetchedResultsController.fetchedObjects!
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
	func applicationDidEnterBackground(_ notification: Notification) {
		do {
			try persistentContainer.viewContext.save()
		} catch {
			print("Unable to Save Changes")
			print("\(error), \(error.localizedDescription)")
		}
	}
	
	// MARK: CoreData
	
	
	func savePersonContext() {
		do {
			try persistentContainer.viewContext.save()
		} catch {
			print("Unable to Save Person")
			print("\(error), \(error.localizedDescription)")
		}
	}
	
	// MARK: Table View
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let title = UILabel()
		title.textColor = UIColor.white
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = title.textColor
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let people = fetchedResultsController.fetchedObjects else {
			return 0
		}
		return people.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? PersonTableViewCell else {
			fatalError("Unexpected Index Path")
		}		
		configure(cell, at: indexPath)
		return cell
	}
	func configure(_ cell: PersonTableViewCell, at indexPath: IndexPath) {
			let person = fetchedResultsController.object(at: indexPath)
			cell.personName.text = person.name
		if self.title == "Who Made Bank" {
			if cell.personName.text == whoMadeBankSelectedPerson {
				cell.accessoryType = .checkmark
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
				tableView.deselectRow(at: indexPath, animated: true)
			} else {
				cell.accessoryType = .none
			}
		} else if self.title == "Who Closed Bank" {
			if cell.personName.text == whoClosedBankSelectedPerson {
				cell.accessoryType = .checkmark
				tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
				tableView.deselectRow(at: indexPath, animated: true)
			} else {
				cell.accessoryType = .none
			}
		}
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for row in 0...tableView.numberOfRows(inSection: 0) {
			if row == indexPath.row {
				continue
			}
			tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
		}
		if self.title == "Who Made Bank" {
			if let cell = tableView.cellForRow(at: indexPath) {
				cell.accessoryType = .checkmark
				selectedWhoMadeBankIndexPath = indexPath
				let whoMadeBank = fetchedResultsController.object(at: selectedWhoMadeBankIndexPath)
				self.whoMadeBank = whoMadeBank
			}
			tableView.deselectRow(at: indexPath, animated: true)
			performSegue(withIdentifier: "unwindToDeliveryStatisticsTableListSegue", sender: self)
		} else if self.title == "Who Closed Bank" {
			if let cell = tableView.cellForRow(at: indexPath) {
				cell.accessoryType = .checkmark
				selectedWhoClosedBankIndexPath = indexPath
				let whoClosedBank = fetchedResultsController.object(at: selectedWhoClosedBankIndexPath)
				self.whoClosedBank = whoClosedBank
			}
			tableView.deselectRow(at: indexPath, animated: true)
			performSegue(withIdentifier: "unwindToDeliveryStatisticsTableListSegue", sender: self)
		}
		
	}
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.accessoryType = .none
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let person = fetchedResultsController.object(at: indexPath)
			person.managedObjectContext?.delete(person)
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
			savePersonContext()
			break
		case .delete:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			savePersonContext()
			break
		case .update:
			if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? PersonTableViewCell {
				configure(cell, at: indexPath)
			}
			savePersonContext()
			break
		case .move:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			if let newIndexPath = newIndexPath {
				tableView.insertRows(at: [newIndexPath], with: .fade)
			}
			savePersonContext()
			break
		}
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToPersonList(_ sender: UIStoryboardSegue) {
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !tableView.isEditing {
			return true
		} else {
			return false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "unwindToDeliveryStatisticsTableListSegue" {
			guard let destinationViewController = segue.destination as? DeliveryStatisticsTableViewController else {
				return
			}
			if self.title == "Who Made Bank" {
				if people.count != 0 {
					destinationViewController.whoMadeBank = whoMadeBank
					destinationViewController.whoClosedBankLabel.text = whoClosedBankSelectedPerson
				}
			} else if self.title == "Who Closed Bank" {
				if people.count != 0 {
					destinationViewController.whoClosedBank = whoClosedBank
					destinationViewController.whoMadeBankLabel.text = whoMadeBankSelectedPerson
				}
			}
		} else {
			guard let destinationViewController = segue.destination as? PersonViewController else {
				return
			}
			destinationViewController.mainContext = persistentContainer.viewContext
			if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showPersonDetail" {
				destinationViewController.person = fetchedResultsController.object(at: indexPath)
			}
		}
	}
}

/*
override func viewDidLoad() {
super.viewDidLoad()
self.clearsSelectionOnViewWillAppear = true
self.navigationItem.leftBarButtonItem = self.editButtonItem
self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
if let savedPeople = loadPeople() {
people += savedPeople
}
//let coreDataStack = UIApplication.shared.delegate as! AppDelegate
//let context = coreDataStack.persistentContainer.viewContext
/*
for person in people {
let newPerson = Person(context: context)
newPerson.setValue(person.name, forKey: "name")
do {
try context.save()
print("Save Successful \(newPerson)")
} catch {
print("Failed to save")
let nserror = error as NSError
fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
}

}*/
}

// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
return 1
}
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return people.count
}
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
let cellIdentifier = "personCell"
let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PersonTableViewCell
let person = people[indexPath.row]
cell.personName.text = person.name
let backgroundView = UIView()
backgroundView.backgroundColor = UIColor.darkGray
cell.selectedBackgroundView = backgroundView
return cell
}
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
// Return false if you do not want the specified item to be editable.
return true
}
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
if editingStyle == .delete {
people.remove(at: indexPath.row)
savePeople()
tableView.deleteRows(at: [indexPath], with: .fade)
} else if editingStyle == .insert {
}
}
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
}

// MARK: - Navigation

@IBAction func unwindToPersonList(_ sender: UIStoryboardSegue) {
if let sourceViewController = sender.source as? PersonViewController, let person = sourceViewController.person {
if let selectedIndexPath = tableView.indexPathForSelectedRow {
people[selectedIndexPath.row] = person
tableView.reloadRows(at: [selectedIndexPath], with: .right)
} else {
let newIndexPath = IndexPath(row: people.count, section: 0)
people.append(person)
tableView.insertRows(at: [newIndexPath], with: .bottom)
}
savePeople()
}
}
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if segue.identifier == "showDetail" {
let personDetailViewController = segue.destination as! PersonViewController
if let selectedPersonCell = sender as? PersonTableViewCell {
let indexPath = tableView.indexPath(for: selectedPersonCell)!
let selectedPerson = people[indexPath.row]
personDetailViewController.person = selectedPerson
}
} else if segue.identifier == "addItem" {
}
}

// MARK: NSCoding

func savePeople() {
let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(people, toFile: Person.ArchiveURL.path)
if !isSuccessfulSave {
print("save Failed")
}
}
func loadPeople() -> [Person]? {
return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
}
*/
