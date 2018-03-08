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
		getBankBalance()
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
	var deliveryDay: DeliveryDay?
	var selectedTime: Date = NSDate() as Date
	var mainContext: NSManagedObjectContext? = nil
	var dropAmountFinal: Double = 0.0
	var chargeSalesFinal: Double = 0.0
	var ticketAmountFinal: Double = 0.0
	var saved = false
	
	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		dropTextField.delegate = self
		dropTime.setValue(UIColor.white, forKey: "textColor")
		if let drops = deliveryDay?.drops?.array as? [Drop] {
			for (index, _) in drops.enumerated() {
				let drop = drops[index]
				dropAmountFinal += drop.amount
			}
		}
		if let deliveries = deliveryDay?.deliveries?.array as? [Delivery] {
			for (index, _) in deliveries.enumerated() {
				let delivery = deliveries[index]
				ticketAmountFinal += delivery.ticketAmount
				if delivery.paymentMethod == 4 {
					chargeSalesFinal += delivery.ticketAmount
				}
			}
		}
		if let drop = drop {
			navigationItem.title = "Edit Drop"
			dropTextField.text = drop.amount.convertToCurrency()
		}
		getBankBalance()
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
		getBankBalance()
	}
	
	// MARK: Actions
	
	func setDropTime() {
		dropTime.reloadInputViews()
		selectedTime = dropTime.date
	}
	func getBankBalance() {
		let currentBalance = ticketAmountFinal - chargeSalesFinal + DeliveryStatisticsTableViewController.startingBank
		currentBalanceLabel.text = currentBalance.convertToCurrency()
		currentBalanceLabel.checkForNegative()
		if let dropAmount = dropTextField.text?.removeDollarSign() {
			let newBalance = currentBalance - dropAmount
			newBalanceLabel.text = newBalance.convertToCurrency()
			newBalanceLabel.checkForNegative()
		}
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
				newDrop.time = selectedTime as NSDate?
				newDrop.deliveryDay = deliveryDay
			}
			drop = newDrop
			deliveryDay?.addToDrops(drop!)
		}
		if let drop = drop {
			if var amount = dropTextField.text {
				drop.amount = amount.removeDollarSign()
				drop.time = selectedTime as NSDate?
			}
			_ = navigationController?.popViewController(animated: true)
		}
	}
}
