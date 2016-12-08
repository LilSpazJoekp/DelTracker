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
	var deliveryDayView: DeliveryDayViewController?
	var deliveryDays = [DeliveryDay]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		self.navigationItem.leftBarButtonItem = self.editButtonItem
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
		return cell
	}
	//override func viewDidAppear(_ animated: Bool) {
	//	table.reloadSections(IndexSet.init(integer: 0), with: .fade)
	//}
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			deliveryDays.remove(at: indexPath.row)
			saveDeliveryDays()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
	}
	
	// MARK: - Navigation
	
	@IBAction func unwindToDeliveryDayList(_ sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? DeliveryStatisticsTableViewController, let deliveryDay = sourceViewController.deliveryDay {
			print(true)
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				print(true)
				deliveryDays[selectedIndexPath.row] = deliveryDay
				tableView.reloadRows(at: [selectedIndexPath], with: .right)
			} else {
				print(false)
				let newIndexPath = IndexPath(row: deliveryDays.count, section: 0)
				deliveryDays.append(deliveryDay)
				tableView.insertRows(at: [newIndexPath], with: .bottom)
			}
			saveDeliveryDays()
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			let deliveryDayDetailViewController = segue.destination as! DeliveryDayViewController
			if let selectedDeliveryDayCell = sender as? DeliveryDayTableViewCell {
				let indexPath = tableView.indexPath(for: selectedDeliveryDayCell)!
				let selectedDeliveryDay = deliveryDays[indexPath.row]
				deliveryDayDetailViewController.deliveryDay = selectedDeliveryDay
			}
		} else if segue.identifier == "addItem" {
			print("Adding new DeliveryDay.")
		}
	}
	// MARK: NSCoding
	
	func saveDeliveryDays() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveryDays, toFile: DeliveryDay.ArchiveURL.path)
		if !isSuccessfulSave {
			print("Failed to save deliveryDays...")
		}
	}
	func loadDeliveryDays() -> [DeliveryDay]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
	}
}
