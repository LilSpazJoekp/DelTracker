//
//  WhoMadeBankTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/7/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class WhoMadeBankTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet var savePerson: AnyObject!
	@IBAction func cancelButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	var people = [Person]()
	var whoMadeBank: WhoMadeBank?
	var peopleArray: [String] = []
	var selectedPerson: String = ""
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
		self.personPicker.reloadAllComponents()
	}
	
	@IBOutlet var personPicker: UIPickerView!
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let titleData = peopleArray[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "System", size: 15.0) as Any,NSForegroundColorAttributeName:UIColor.white])
		return myTitle
	}
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return peopleArray.count;
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return peopleArray[row]
	}
	
	func loadPeople() -> [Person]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Person.ArchiveURL.path) as? [Person]
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
		
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if savePerson === sender as AnyObject? {
			if people.count != 0 {
				let selectedPerson = "\(peopleArray[personPicker.selectedRow(inComponent: 0)])"
				
				let name = selectedPerson
				whoMadeBank = WhoMadeBank(name: name)
			}
		}
	}
}
