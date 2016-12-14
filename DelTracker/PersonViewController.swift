//
//  PersonViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/7/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate {
	@IBOutlet var personSaveButton: AnyObject!
	@IBOutlet var personTextField: UITextField!
	@IBAction func personSaveButton(_ sender: UIBarButtonItem) {
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func cancelAdd(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	var person: Person?
	override func viewDidLoad() {
		super.viewDidLoad()
		personTextField.delegate = self
		if let person = person {
			navigationItem.title = "Edit Person"
			personTextField.text = person.name
		} else {
			personTextField.becomeFirstResponder()
		}
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		personTextField.resignFirstResponder()
		return true
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
 
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if personSaveButton === sender as AnyObject? {
			let personTextFieldValue = personTextField.text ?? ""
			person = Person(name: personTextFieldValue)
		}
	}
}
