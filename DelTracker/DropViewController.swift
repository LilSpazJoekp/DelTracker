//
//  DropViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DropViewController: UIViewController, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate {
	@IBOutlet var currentBalanceLabel: UILabel!
	@IBOutlet var dropTextField: CurrencyField!
	@IBOutlet var newBalanceLabel: UILabel!
	@IBOutlet var dropSaveButton: AnyObject!
	@IBOutlet var quickDropButton: AnyObject!
	@IBOutlet var setTimeToNowButton: UIBarButtonItem!
	@IBOutlet var timeOverrideSwitch: UISwitch!
	@IBOutlet var dropTime: UIDatePicker!
	@IBAction func overrideDropTimeChanged(_ sender: UISwitch) {
		if timeOverrideSwitch.isOn {
			dropTime.isEnabled = true
			setTimeToNowButton?.isEnabled = true
		} else {
			if let drop = drop {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				dropTime.setDate(drop.timestamp as! Date, animated: true)
			}
		}
	}
	@IBAction func setTimeToNowBarButton(_ sender: UIBarButtonItem) {
		dropTime.setDate(NSDate() as Date, animated: true)
	}
	@IBAction func quickDropButton(_ sender: Any) {
		dropTextField.text = "$100.00"
		dropTextField.resignFirstResponder()
	}
	@IBAction func dropSaveButton(_ sender: UIBarButtonItem) {
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func cancelAdd(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	var drop: Drop?
	var drops = [Drop]()
	var selectedTime: Date = NSDate() as Date
	override func viewDidLoad() {
		super.viewDidLoad()
		dropTextField.delegate = self
		dropTime.setValue(UIColor.white, forKey: "textColor")
		if let drop = drop {
			navigationItem.title = "Edit Drop"
			dropTextField.text = drop.dropAmount.convertToCurrency()
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
 
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if dropSaveButton === sender as AnyObject? || quickDropButton === sender as AnyObject? {
			
		}
	}
	func setDropTime() {
		dropTime.reloadInputViews()
		selectedTime = dropTime.date
		dropTime.setValue(UIColor.white, forKey: "textColor")
	}
	
	// MARK: CoreData
	
	func saveDrops() {
		let coreDataStack = UIApplication.shared.delegate as! AppDelegate
		let context = coreDataStack.persistentContainer.viewContext
		let newDrop = Drop(context: context)
		if var dropAmount = dropTextField.text {
			newDrop.dropAmount = dropAmount.removeDollarSign()
			newDrop.timestamp = selectedTime as NSDate?
			do {
				try context.save()
				print("Save Successful \(newDrop)")
			} catch {
				print("Failed to save")
			}
		}
	}
}
