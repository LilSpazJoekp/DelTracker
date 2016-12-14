//
//  DropTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DropTableViewController: UITableViewController {
	@IBOutlet var table: UITableView!
	var drops = [Drop]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		self.navigationItem.leftBarButtonItem = self.editButtonItem
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		if let savedDrops = loadDrops() {
			drops += savedDrops
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return drops.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "dropCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DropTableViewCell
		let drop = drops[indexPath.row]
		cell.dropNumber.text = String(indexPath.row + 1)
		cell.dropAmount.text = drop.deliveryDropAmount
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = backgroundView
		return cell
	}
	override func viewDidAppear(_ animated: Bool) {
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			drops.remove(at: indexPath.row)
			saveDrops()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		}
	}
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
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
			saveDrops()
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
		} else if segue.identifier == "addDrop" {
		}
	}
	
	// MARK: NSCoding
	
	func saveDrops() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(drops, toFile: Drop.ArchiveURL.path)
		if !isSuccessfulSave {
			print("save Failed")
		}
	}
	func loadDrops() -> [Drop]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Drop.ArchiveURL.path) as? [Drop]
	}
}
