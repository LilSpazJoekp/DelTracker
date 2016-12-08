//
//  DeliveryDayViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/2/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryDayViewController: UIViewController {
	let deliveryTableViewController = DeliveryTableViewController()
	
	@IBAction func daySaveButton(_ sender: UIBarButtonItem) {
		print("setting archive path")
		setArchiveURLPath()
	}
	@IBAction func cancelButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet var deliveryDatePicker: UIDatePicker!
	var delivery: Delivery?
	var deliveryDay: DeliveryDay?
	var deliveryDateViewController = DeliveryDayViewController.self
	
	static var selectedDateGlobal: String = "010116"
	
	var selectedDate: String = ""
	convenience required init(selectedDate: String) {
		self.init(selectedDate: DeliveryDayViewController.selectedDateGlobal)
		self.selectedDate = selectedDate
	}
	
	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		print("setting archive path")
		setArchiveURLPath()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		print("viewDidLoad")
		deliveryDatePicker.setValue(UIColor.white, forKey: "textColor")
		if let deliveryDay = deliveryDay {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMddyy"
			let date = dateFormatter.date(from: deliveryDay.deliveryDateValue)
			deliveryDatePicker.setDate(date!, animated: true)
		}
		print("setting archive path")
		setArchiveURLPath()
	}
	func setArchiveURLPath() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMddyy"
		DeliveryDayViewController.selectedDateGlobal = dateFormatter.string(from: deliveryDatePicker.date)
		Delivery.ArchiveURL = Delivery.DocumentsDirectory.appendingPathComponent("\(DeliveryDayViewController.selectedDateGlobal)")
		Drop.ArchiveURL = Drop.DocumentsDirectory.appendingPathComponent("\(DeliveryDayViewController.selectedDateGlobal)")
		print(Delivery.ArchiveURL.path)
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
}
