//
//  PersonViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/7/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class PersonViewController : UIViewController, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate {
	@IBOutlet var personSaveButton: AnyObject!
	@IBOutlet var personTextField: UITextField!
	@IBAction func personSaveButton(_ sender: UIBarButtonItem) {
		savePeople()
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		_ = navigationController?.popViewController(animated: true)
	}
	@IBAction func editPersonSaveButton(_ sender: UIBarButtonItem) {
		savePeople()
		dismiss(animated: true, completion: nil)
	}
	
	var person: Person?
	var people = [Person]()
	var selectedTime: Date = NSDate() as Date
	var managedObjectContext: NSManagedObjectContext?
	override func viewDidLoad() {
		super.viewDidLoad()
		personTextField.delegate = self
		if let person = person {
			navigationItem.title = "Edit Person"
			personTextField.text = person.name
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	// MARK: CoreData
	
	func savePeople() {
		guard let managedObjectContext = managedObjectContext else {
			return
		}
		if person == nil {
			let newPerson = Person(context: managedObjectContext)
			if let name = personTextField.text {
				newPerson.name = name
			}
			person = newPerson
		}
		if let person = person {
			if let name = personTextField.text {
				person.name = name
			}
			_ = navigationController?.popViewController(animated: true)
		}
	}
}
