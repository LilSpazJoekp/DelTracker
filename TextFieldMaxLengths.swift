//
//  TextFieldMaxLengths.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
private var maxLengths = [UITextField: Int]()
extension UITextField {
	@IBInspectable var maxLength: Int {
		get {
			guard let length = maxLengths[self] else {
				return Int.max
			}
			return length
		}
		set {
			maxLengths[self] = newValue
			addTarget(
				self,
				action: #selector(limitLength),
				for: UIControlEvents.editingChanged
			)
		}
	}
	func limitLength(_ textField: UITextField) {
		guard let prospectiveText = textField.text,
			prospectiveText.characters.count > maxLength
			else {
				return
		}
		let selection = selectedTextRange
		let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
		text = prospectiveText.substring(to: maxCharIndex)
		selectedTextRange = selection
	}
}
