//
//  DropViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DropViewController: UIViewController, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate {
	@IBOutlet var currentBalanceLabel: UILabel!
	@IBOutlet var dropTextField: CurrencyField!
	@IBOutlet var newBalanceLabel: UILabel!
	@IBOutlet var dropSaveButton: AnyObject!
	@IBOutlet var quickDropButton: AnyObject!
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
	override func viewDidLoad() {
		super.viewDidLoad()
		dropTextField.delegate = self
		if let drop = drop {
			navigationItem.title = "Edit Drop"
			dropTextField.text = drop.deliveryDropAmount
		} else {
			dropTextField.becomeFirstResponder()
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
 
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if dropSaveButton === sender as AnyObject? || quickDropButton === sender as AnyObject? {
			let dropTextFieldValue = dropTextField.text ?? ""
			drop = Drop(deliveryDropAmount: dropTextFieldValue)
		}
	}
}
