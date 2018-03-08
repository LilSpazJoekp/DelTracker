//
//  DropViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DropViewController : UIViewController, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate {
	
	// MARK: StoryBoard Outlets
	
	@IBOutlet var currentBalanceLabel: UILabel!
	@IBOutlet var dropTextField: CurrencyField!
	@IBOutlet var newBalanceLabel: UILabel!
	@IBOutlet var dropSaveButton: AnyObject!
	@IBOutlet var quickDropButton: AnyObject!
	@IBOutlet var setTimeToNowButton: UIBarButtonItem!
	@IBOutlet var timeOverrideSwitch: UISwitch!
	@IBOutlet var dropTime: UIDatePicker!
	
	// MARK: StoryBoard Actions
	
	@IBAction func overrideDropTimeChanged(_ sender: UISwitch) {
		if timeOverrideSwitch.isOn {
			dropTime.isEnabled = true
			setTimeToNowButton?.isEnabled = true
		} else {
			if let drop = drop {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
                dropTime.setDate(drop.time! as Date, animated: true)
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
		saveDrops()
		//perfomUnwindSegue()
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: Variables and Constants
	
	var drop: Drop?
	var drops = [Drop]()
	var deliveryDay: DeliveryDay?
    var selectedTime: Date = NSDate() as Date
	var mainContext: NSManagedObjectContext? = nil
	var dropChildContext: NSManagedObjectContext? = nil
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dropTextField.delegate = self
		dropTime.setValue(UIColor.white, forKey: "textColor")
		if let drop = drop {
			navigationItem.title = "Edit Drop"
			dropTextField.text = drop.amount.convertToCurrency()
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	// MARK: Actions
	
	func setDropTime() {
		dropTime.reloadInputViews()
		selectedTime = dropTime.date
	}
	
	// MARK: CoreData
		
	func saveDrops() {
		setDropTime()
		guard let mainContext = mainContext else {
			return
		}
		
		if drop == nil {
			let newDrop = Drop(context: mainContext)
			if var amount = dropTextField.text {
				newDrop.amount = amount.removeDollarSign()
				newDrop.time = selectedTime
				var date = NSDate()
                date = selectedTime as NSDate
				newDrop.dateString = date.convertToDateString()
			}
			drop = newDrop
		}
		if let drop = drop {
			if var amount = dropTextField.text {
				drop.amount = amount.removeDollarSign()
				drop.time = selectedTime
			}			
			_ = navigationController?.popViewController(animated: true)
		}
	}
}
