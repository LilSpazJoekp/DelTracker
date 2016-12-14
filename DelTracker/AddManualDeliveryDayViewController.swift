//
//  AddManualDeliveryDayViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/13/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class AddManualDeliveryDayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {	
	@IBOutlet var numberOfDeliveriesField: UITextField!
	@IBOutlet var totalRecievedWithPaidoutField: CurrencyField!
	@IBOutlet var totalTipsLabel: UILabel!
	@IBOutlet var pickerView: UIPickerView!
	@IBAction func totalRecievedWithOutPaidoutEditingDidEnd(_ sender: Any) {
		calculate()
	}
	@IBAction func cancelButton(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func saveButton(_ sender: Any) {
		setPeople()
		calculate()
	}
	@IBAction func numberOfDeliveriesFieldEditingDidBegan(_ sender: Any) {
		previousBarButton.isEnabled = false
		nextBarButton.isEnabled = true
	}
	@IBAction func totalRecievedWithOutPaidoutEditingDidBegin(_ sender: Any) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = false
	}
	var people = [Person]()
	var peopleArray: [String] = []
	var deliveryDay: DeliveryDay?
	var whoMadeBank: String = ""
	var whoClosedBank: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		peopleArray.removeAll()
		if let savedPeople = loadPeople() {
			people += savedPeople
			for (index, _) in people.enumerated() {
				let person = people[index]
				let personName = person.name
				peopleArray.append(personName)
			}
		}
		addBarButtons()
	}
	override func viewDidAppear(_ animated: Bool) {
		peopleArray.removeAll()
		if let savedPeople = loadPeople() {
			people = savedPeople
			for (index, _) in people.enumerated() {
				let person = people[index]
				let personName = person.name
				peopleArray.append(personName)
			}
		}
		self.pickerView.reloadAllComponents()
	}
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		if component == 1 {
			let titleData = peopleArray[row]
			let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "System", size: 15.0) as Any,NSForegroundColorAttributeName:UIColor.white])
			return myTitle
		} else {
			let titleData = peopleArray[row]
			let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "System", size: 15.0) as Any,NSForegroundColorAttributeName:UIColor.white])
			return myTitle
		}
	}
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 1 {
			return peopleArray.count;
		} else {
			return peopleArray.count;
		}
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == 1 {
			return peopleArray[row]
		} else {
			return peopleArray[row]
		}
	}
	func goToPreviousField(_:Any?) {
		totalRecievedWithPaidoutField.resignFirstResponder()
		numberOfDeliveriesField.becomeFirstResponder()
			}
	func goToNextField() {
		numberOfDeliveriesField.resignFirstResponder()
		totalRecievedWithPaidoutField.becomeFirstResponder()
	}
	
	// UITextField Navigation Bar
	let keyboardToolbar = UIToolbar()
	let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToPreviousField))
	let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToNextField))
	func addBarButtons() {
		nextBarButton.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		previousBarButton.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		keyboardToolbar.barTintColor = UIColor(red:0.09, green:0.11, blue:0.11, alpha:1.0)
		keyboardToolbar.sizeToFit()
		keyboardToolbar.items = [flexBarButton, previousBarButton, nextBarButton]
		numberOfDeliveriesField.inputAccessoryView = keyboardToolbar
		totalRecievedWithPaidoutField.inputAccessoryView = keyboardToolbar
		
	}

	func loadPeople() -> [Person]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
	}
	func setPeople() {
		whoMadeBank = peopleArray[pickerView.selectedRow(inComponent: 0)]
		whoClosedBank = peopleArray[pickerView.selectedRow(inComponent: 1)]
	}
	func calculate() {
		if numberOfDeliveriesField.text != "" {
			let numberOfDeliveries: Double = Double(numberOfDeliveriesField.text!)!
			let totalPaidout = numberOfDeliveries * 1.25
			let totalRecieved = removeFirstCharacter(input: totalRecievedWithPaidoutField.text!)
			let totalTips = "\(totalRecieved - totalPaidout)"
			totalTipsLabel.text = "$" + totalTips
		}
	}
	func removeFirstCharacter(input: String) -> Double {
		var inputDropped = input
		inputDropped.remove(at: (inputDropped.startIndex))
		return Double(inputDropped)!
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?){
		setPeople()
		let deliveryCountValue = numberOfDeliveriesField.text
		let deliveryDateValue = String(DeliveryDayViewController.selectedDateGlobal) ?? "010116"
		let totalTipsValue = self.totalTipsLabel.text
		let whoMadeBankName = self.whoMadeBank
		let whoClosedBankName = self.whoClosedBank
		let totalRecievedValue = self.totalRecievedWithPaidoutField.text
		let manual = true
		deliveryDay = DeliveryDay(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryCountValue!, totalTipsValue: totalTipsValue!, totalRecievedValue: totalRecievedValue!, whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName, manual: manual)
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}
