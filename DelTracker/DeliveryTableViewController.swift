//
//  DeliveryTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryTableViewController : UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
	@IBOutlet var table: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	@IBOutlet var deleteButton: UIBarButtonItem!
	@IBAction func deleteAction(_ sender: UIBarButtonItem) {
		indexPathsToDelete.removeAll()
		for (_, path) in selectedIndicies.enumerated() {
			let indexPath: IndexPath = [0, path]
			let context = self.fetchedResultsController.managedObjectContext
			context.delete(self.fetchedResultsController.object(at: indexPath))
		}
		let context = self.fetchedResultsController.managedObjectContext
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
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
	var drops = [Drop]()
	var deliveryDay: DeliveryDay?
	var setDate: String?
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	var tabBar: DeliveryTabBarViewController?
	var mainContext: NSManagedObjectContext? = nil
	var _fetchedResultsController: NSFetchedResultsController<Delivery>? = nil
	var fetchedResultsController: NSFetchedResultsController<Delivery> {
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		let fetchRequest: NSFetchRequest<Delivery> = Delivery.fetchRequest()
		fetchRequest.fetchBatchSize = 20
		let sortDescriptor = NSSortDescriptor(key: "deliveryTime", ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let predicate = NSPredicate(format: "deliveryDay == %@", deliveryDay!)
		fetchRequest.predicate = predicate
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext!, sectionNameKeyPath: nil, cacheName: "DeliveryCache")
		aFetchedResultsController.delegate = self
		_fetchedResultsController = aFetchedResultsController
		do {
			try _fetchedResultsController!.performFetch()
		} catch {
			let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		return _fetchedResultsController!
	}
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = true
	}
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.tabBarController?.tabBar.isHidden = false
		self.tabBarController?.tabBar.items![1].badgeValue = String(deliveries.count)
		self.tabBarController?.tabBar.items![2].badgeValue = String(drops.count)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		self.table.reloadData()		
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
	func activityIndicator(msg: String, _ indicator: Bool) {
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
	
	// MARK: - Table View Life Cycle
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let deliveryCount = self.fetchedResultsController.fetchedObjects?.count
		return deliveryCount!
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryCell", for: indexPath) as! DeliveryTableViewCell
		let delivery = self.fetchedResultsController.object(at: indexPath)
		self.configureCell(cell, atIndexPath: indexPath, withDelivery: delivery)
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = backgroundView
		return cell
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing {
			setDeleteButtonCount()
			selectedIndicies.append(indexPath.row)
			if selectedIndicies.count != 0 {
			}
		} else {
			tableView.deselectRow(at: indexPath, animated: true)
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
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let context = self.fetchedResultsController.managedObjectContext
			context.delete(self.fetchedResultsController.object(at: indexPath))
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			}
		}
	}
	func configureCell(_ cell: DeliveryTableViewCell, atIndexPath indexPath: IndexPath, withDelivery delivery: Delivery) {
		let paymentMethod: String?
		switch delivery.paymentMethod {
		case 0:
			paymentMethod = "None"
		case 1:
			paymentMethod = "Cash"
		case 2:
			paymentMethod = "Check"
		case 3:
			paymentMethod = "Credit"
		case 4:
			paymentMethod = "Charge"
		case 5:
			paymentMethod = "Other"
		default:
			paymentMethod = "None"
		}
		cell.deliveryNumber.text = String(indexPath.row + 1)
		cell.ticketNumberCell.text = "\(delivery.ticketNumber)"
		cell.ticketAmountCell.text = delivery.ticketAmount.convertToCurrency()
		cell.amountGivenCell.text = delivery.amountGiven.convertToCurrency()
		cell.cashTipsCell.text = delivery.cashTips.convertToCurrency()
		cell.totalTipsCell.text = delivery.totalTips.convertToCurrency()
		cell.paymentMethodCell.text = paymentMethod
		cell.deliveryTimeCell.text = delivery.deliveryTime?.convertToTimeString()
	}
	
	// MARK: - Fetched results controller
	
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
		self.tabBarController?.tabBar.items![1].badgeValue = String(deliveries.count)
		self.tabBarController?.tabBar.items![2].badgeValue = String(drops.count)
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			self.configureCell(tableView.cellForRow(at: indexPath!)! as! DeliveryTableViewCell, atIndexPath: indexPath!, withDelivery: anObject as! Delivery)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
		self.tabBarController?.tabBar.items![1].badgeValue = String(deliveries.count)
		self.tabBarController?.tabBar.items![2].badgeValue = String(drops.count)
		}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
	}
	
	// MARK: - Navigation
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !tableView.isEditing {
			return true
		} else {
			return false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destinationViewController = segue.destination as? DeliveryViewController else {
			return
		}
		self.navigationController?.tabBarController?.tabBar.isHidden = true
		destinationViewController.mainContext = mainContext
		destinationViewController.deliveryDay = deliveryDay
		if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "showDetail" {
			destinationViewController.delivery = fetchedResultsController.object(at: indexPath)
		}
	}
}
