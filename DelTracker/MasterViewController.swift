//
//  MasterViewController.swift
//  coreData
//
//  Created by Joel Payne on 1/8/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var detailViewController: DetailViewController? = nil
	var managedObjectContext: NSManagedObjectContext? = nil


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem

		
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func insertNewObject(_ sender: Any) {
		let coreDataStack = UIApplication.shared.delegate as! AppDelegate
		let context = coreDataStack.persistentContainer.viewContext
		let newDrop = Drop(context: context)
		     
		// If appropriate, configure the new managed object.
		newDrop.timestamp = NSDate()

		// Save the context.
		do {
		    try context.save()
		} catch {
		    // Replace this implementation with code to handle the error appropriately.
		    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		    let nserror = error as NSError
		    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
				let coreDataStack = UIApplication.shared.delegate as! AppDelegate
				let context = coreDataStack.persistentContainer.viewContext
				let requestAllDeliveryDays = NSFetchRequest<Drop>(entityName: "Drop")
				requestAllDeliveryDays.returnsObjectsAsFaults = false
				var object: Drop? = nil
				do {
					let deliveryDays = try context.fetch(requestAllDeliveryDays)
					if deliveryDays.count > 0 {
						print("deliveryDays.count \(deliveryDays.count)")
						object = deliveryDays[indexPath.row]
					}
				} catch {
					let nserror = error as NSError
					fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
				}

				
		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let coreDataStack = UIApplication.shared.delegate as! AppDelegate
		let context = coreDataStack.persistentContainer.viewContext
		var sectionInfo: Int = 0
		let requestAllDeliveryDays = NSFetchRequest<Drop>(entityName: "Drop")
		requestAllDeliveryDays.returnsObjectsAsFaults = false
		do {
			let deliveryDays = try context.fetch(requestAllDeliveryDays)
			if deliveryDays.count > 0 {
				print("deliveryDays.count \(deliveryDays.count)")
				for deliveryDay in deliveryDays {
					print("deliveryDay \(deliveryDay)")
				}
				sectionInfo = deliveryDays.count
			}
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
		return sectionInfo
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let coreDataStack = UIApplication.shared.delegate as! AppDelegate
		let context = coreDataStack.persistentContainer.viewContext
		let requestAllDeliveryDays = NSFetchRequest<Drop>(entityName: "Drop")
		requestAllDeliveryDays.returnsObjectsAsFaults = false
		do {
			let deliveryDays = try context.fetch(requestAllDeliveryDays)
			if deliveryDays.count > 0 {
				print("deliveryDays.count \(deliveryDays.count)")
				for deliveryDay in deliveryDays {
					print("deliveryDay \(deliveryDay)")
					self.configureCell(cell, withDrop: deliveryDay)
				}
			}
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}

		
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		    let context = self.fetchedResultsController.managedObjectContext
		    context.delete(self.fetchedResultsController.object(at: indexPath))
		        
		    do {
		        try context.save()
		    } catch {
		        // Replace this implementation with code to handle the error appropriately.
		        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		        let nserror = error as NSError
		        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		    }
		}
	}

	func configureCell(_ cell: UITableViewCell, withDrop event: Drop) {
		cell.textLabel!.text = event.timestamp!.description
	}

	// MARK: - Fetched results controller

	var fetchedResultsController: NSFetchedResultsController<Drop> {
	    if _fetchedResultsController != nil {
	        return _fetchedResultsController!
	    }
	    
	    let fetchRequest: NSFetchRequest<Drop> = Drop.fetchRequest()
	    
	    // Set the batch size to a suitable number.
	    fetchRequest.fetchBatchSize = 20
	    
	    // Edit the sort key as appropriate.
	    let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
	    
	    fetchRequest.sortDescriptors = [sortDescriptor]
	    
	    // Edit the section name key path and cache name if appropriate.
	    // nil for section name key path means "no sections".
		// let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
		/// aFetchedResultsController.delegate = self
		//  _fetchedResultsController = aFetchedResultsController
	    
		//do {
		//     try _fetchedResultsController!.performFetch()
		// } catch {
	         // Replace this implementation with code to handle the error appropriately.
	         // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
		//      let nserror = error as NSError
		//      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		// }
	    
		return _fetchedResultsController!
	}    
	var _fetchedResultsController: NSFetchedResultsController<Drop>? = nil

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
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	    switch type {
	        case .insert:
	            tableView.insertRows(at: [newIndexPath!], with: .fade)
	        case .delete:
	            tableView.deleteRows(at: [indexPath!], with: .fade)
	        case .update:
	            self.configureCell(tableView.cellForRow(at: indexPath!)!, withDrop: anObject as! Drop)
	        case .move:
	            tableView.moveRow(at: indexPath!, to: newIndexPath!)
	    }
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	    self.tableView.endUpdates()
	}

	/*
	 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
	 
	 func controllerDidChangeContent(controller: NSFetchedResultsController) {
	     // In the simplest, most efficient, case, reload the table view.
	     self.tableView.reloadData()
	 }
	 */

}

