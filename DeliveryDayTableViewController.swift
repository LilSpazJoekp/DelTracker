//
//  DeliveryDayTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/2/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryDayTableViewController: UITableViewController {
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	@IBAction func deleteAction(_ sender: Any) {
		/*
		let indexPath =	tableView.indexPathsForSelectedRows
		removeDelivery(deliveryDate: deliveryDay.deliveryDateValue)
		deliveryDays.remove(at: indexPath.row)
		saveDeliveryDays()
		tableView.deleteRows(at: [indexPath], with: .fade)
		*/
	}
	@IBAction func editButton(_ sender: Any) {
		if !table.isEditing {
			table.setEditing(true, animated: true)
			editButton.title = "Done"
			editButton.style = UIBarButtonItemStyle.done
			deleteButton.isEnabled = false
			deleteButton.tintColor = UIColor.red
			deleteButton.title = "Delete(0)"
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
	static var status: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		//self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteAction(_:)))
		deleteButton.isEnabled = false
		deleteButton.tintColor = UIColor.clear
		self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		if let savedDeliveryDays = loadDeliveryDays() {
			deliveryDays += savedDeliveryDays
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return deliveryDays.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "deliveryDayCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeliveryDayTableViewCell
		let deliveryDay = deliveryDays[indexPath.row]
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMddyy"
		let dateFormatted = dateFormatter.date(from: String(deliveryDay.deliveryDateValue))
		dateFormatter.dateFormat = "MM/dd/yy"
		let dateFormattedFinal = dateFormatter.string(from: dateFormatted!)
		cell.dateLabel?.text = dateFormattedFinal
		cell.deliveryCount?.text = deliveryDay.deliveryDayCountValue
		cell.totalTips?.text = deliveryDay.totalTipsValue
		cell.totalPay?.text = deliveryDay.totalRecievedValue
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
	//didunselect row at
	//editingdidend
	//set delete to 0
	//stop delete flashing
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		setDeleteButtonCount()
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		setDeleteButtonCount()
	}
	func setDeleteButtonCount() {
		if tableView.isEditing {
			if !deleteButton.isEnabled {
				deleteButton.isEnabled = true
				deleteButton.tintColor = UIColor.red
				deleteButton.title = "Delete(" + "\(tableView.indexPathsForSelectedRows?.count ?? 0)" + ")"
			} else if deleteButton.isEnabled {
				deleteButton.title = "Delete(" + "\(tableView.indexPathsForSelectedRows?.count ?? 0)" + ")"
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
			saveDeliveryDays()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		}
	}
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let tempItemToMove = deliveryDays[fromIndexPath.row]
		deliveryDays.remove(at: fromIndexPath.row)
		deliveryDays.insert(tempItemToMove, at: to.row)
		saveDeliveryDays()
	}
	override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToDeliveryDayList(_ sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? DeliveryStatisticsTableViewController, let deliveryDay = sourceViewController.deliveryDay {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				deliveryDays[selectedIndexPath.row] = deliveryDay
				tableView.reloadRows(at: [selectedIndexPath], with: .right)
			} else {
				let newIndexPath = IndexPath(row: deliveryDays.count, section: 0)
				deliveryDays.append(deliveryDay)
				tableView.insertRows(at: [newIndexPath], with: .bottom)
			}
			saveDeliveryDays()
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
		if !tableView.isEditing {
			if segue.identifier == "showDetail" {
				let deliveryDayDetailViewController = segue.destination as! DeliveryDayViewController
				if let selectedDeliveryDayCell = sender as? DeliveryDayTableViewCell {
					let indexPath = tableView.indexPath(for: selectedDeliveryDayCell)!
					let selectedDeliveryDay = deliveryDays[indexPath.row]
					deliveryDayDetailViewController.deliveryDay = selectedDeliveryDay
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
