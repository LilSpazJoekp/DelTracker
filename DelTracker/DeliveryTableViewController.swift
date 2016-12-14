//
//  DeliveryTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryTableViewController: UITableViewController, UITextFieldDelegate {
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	@IBAction func editButton(_ sender: UIBarButtonItem) {
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
	
	var deliveries = [Delivery]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
		//self.navigationItem.leftBarButtonItem = self.editButtonItem
		if let savedDeliveries = loadDeliveries() {
			deliveries += savedDeliveries
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return deliveries.count
	}
	var paymentMethodString = ""
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "deliveryCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeliveryTableViewCell
		let delivery = deliveries[indexPath.row]
		if delivery.paymentMethodValue == "0" {
			self.paymentMethodString = "None"
		} else if delivery.paymentMethodValue == "1" {
			self.paymentMethodString = "Cash"
		} else if delivery.paymentMethodValue == "2" {
			self.paymentMethodString = "Check"
		} else if delivery.paymentMethodValue == "3" {
			self.paymentMethodString = "Credit"
		} else if delivery.paymentMethodValue == "4" {
			self.paymentMethodString = "Charge"
		} else if delivery.paymentMethodValue == "5" {
			self.paymentMethodString = "Other"
		}
		cell.deliveryNumber.text = String(indexPath.row + 1)
		cell.ticketNumberCell.text = delivery.ticketNumberValue
		cell.ticketAmountCell.text = delivery.ticketAmountValue
		cell.amountGivenCell.text = delivery.amountGivenValue
		cell.cashTipsCell.text = delivery.cashTipsValue
		cell.totalTipsCell.text = delivery.totalTipsValue
		cell.paymentMethodCell.text = paymentMethodString
		cell.deliveryTimeCell.text = delivery.deliveryTimeValue
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = backgroundView		
		return cell
	}
	override func viewDidAppear(_ animated: Bool) {
		table.reloadSections(IndexSet.init(integer: 0), with: .fade)
	}
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			deliveries.remove(at: indexPath.row)
			saveDeliveries()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		}
	}
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let tempItemToMove = deliveries[fromIndexPath.row]
		deliveries.remove(at: fromIndexPath.row)
		deliveries.insert(tempItemToMove, at: to.row)
		saveDeliveries()
	}
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
	
	
	// MARK: - Navigation
	
	@IBAction func unwindToDeliveryList(_ sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? DeliveryViewController, let delivery = sourceViewController.delivery {
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				deliveries[selectedIndexPath.row] = delivery
				tableView.reloadRows(at: [selectedIndexPath], with: .right)
			} else {
				let newIndexPath = IndexPath(row: deliveries.count, section: 0)
				deliveries.append(delivery)
				tableView.insertRows(at: [newIndexPath], with: .bottom)
			}
			saveDeliveries()
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			let deliveryDetailViewController = segue.destination as! DeliveryViewController
			if let selectedDeliveryCell = sender as? DeliveryTableViewCell {
				let indexPath = tableView.indexPath(for: selectedDeliveryCell)!
				let selectedDelivery = deliveries[indexPath.row]
				deliveryDetailViewController.delivery = selectedDelivery
			}
		} else if segue.identifier == "addItem" {
			
		}
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !tableView.isEditing {
			return true
		} else {
			return false
		}
	}
	
	//MARK: NSCoding
	
	func saveDeliveries() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveries, toFile: Delivery.ArchiveURL.path)
		if !isSuccessfulSave {
			
		}
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
}
