//
//  PeopleTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/7/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
	
	@IBOutlet var table: UITableView!
	@IBAction func saveButton(_ sender: UIBarButtonItem) {
		savePeople()
		dismiss(animated: true, completion: nil)
	}
	@IBAction func cancelButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	var people = [Person]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		self.navigationItem.leftBarButtonItem = self.editButtonItem
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		if let savedPeople = loadPeople() {
			people += savedPeople
		}
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
			print("Adding new Person.")
		}
	}
	
	// MARK: NSCoding
	
	func savePeople() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(people, toFile: Person.ArchiveURL.path)
		if !isSuccessfulSave {
			print("Failed to save people...")
		}
	}
	func loadPeople() -> [Person]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
	}
}
