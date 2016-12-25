//
//  DeliveryTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryTableViewController: UITableViewController, UITextFieldDelegate {
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	@IBAction func deleteAction(_ sender: UIBarButtonItem) {
		indexPathsToDelete.removeAll()
		for (_, path) in selectedIndicies.enumerated() {
			print(path)
			let indexPath: IndexPath = [0, path]
			indexPathsToDelete.append(indexPath)
			print(indexPathsToDelete)			
			deliveries.remove(at: path)
		}
		table.deleteRows(at: indexPathsToDelete, with: .fade)
		saveDeliveries()
		table.setEditing(false, animated: true)
		editButton.title = "Edit"
		editButton.style = UIBarButtonItemStyle.plain
		deleteButton.isEnabled = false
		deleteButton.tintColor = UIColor.clear
	}
	@IBAction func editButton(_ sender: UIBarButtonItem) {
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
	var selectedIndicies: [Int] = []
	var deselectedIndexPath: Int?
	var indexPathsToDelete: [IndexPath] = []
	var deliveries = [Delivery]()	
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
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
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
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
	
	// MARK: - Navigation
	
	@IBAction func unwindToDeliveryList(_ sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? DeliveryViewController, let delivery = sourceViewController.delivery {
			activityIndicator(msg: "    Saving...", true)
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
	
	//MARK: CoreData
	
	func getContext () -> NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}


func activityIndicator(msg:String, _ indicator:Bool ) {
	print(msg)
	strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
	strLabel.text = msg
	strLabel.textColor = UIColor.white
	messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 90, width: 180, height: 50))
	messageFrame.layer.cornerRadius = 15
	messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
	if indicator {
		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
		activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
		activityIndicator.startAnimating()
		messageFrame.addSubview(activityIndicator)
	}
	messageFrame.addSubview(strLabel)
	view.bringSubview(toFront: strLabel)
	view.addSubview(messageFrame)
	view.bringSubview(toFront: messageFrame)
	}
	func saveDeliveries() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveries, toFile: Delivery.ArchiveURL.path)
		if !isSuccessfulSave {
			
		}
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
}
