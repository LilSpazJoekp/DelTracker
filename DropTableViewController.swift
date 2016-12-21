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
		@IBOutlet var editButton: UIBarButtonItem!
		@IBOutlet var deleteButton: UIBarButtonItem!
		@IBAction func deleteAction(_ sender: Any) {
			indexPathsToDelete.removeAll()
			for (_, path) in selectedIndicies.enumerated() {
				print(path)
				let indexPath: IndexPath = [0, path]
				indexPathsToDelete.append(indexPath)
				print(indexPathsToDelete)
				removeDrop(dropDate: "drops" + DeliveryDayViewController.selectedDateGlobal)
				drops.remove(at: path)
			}
			table.deleteRows(at: indexPathsToDelete, with: .fade)
			saveDrops()
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
		override func viewDidLoad() {
			super.viewDidLoad()
			self.clearsSelectionOnViewWillAppear = true
			//self.navigationItem.leftBarButtonItem = self.editButtonItem
			self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
			if let savedDrops = loadDrops() {
				drops += savedDrops
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
		override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			setDeleteButtonCount()
			selectedIndicies.append(indexPath.row)
			if selectedIndicies.count != 0 {
				print(selectedIndicies)
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
					print(deselectedIndexPath!)
					selectedIndicies.remove(at: selectedIndicies.index(of: Int(deselectedIndexPath!))!)
					print(selectedIndicies)
				}
			}
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
	}
