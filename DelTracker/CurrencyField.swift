//
//  CurrencyField.swift
//  DelTracker
//
//  Created by Joel Payne on 12/23/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class CurrencyField: UITextField {
	override func awakeFromNib() {
		super.awakeFromNib()
		addTarget(self, action: #selector(editingChanged), for: .editingChanged)
		keyboardType = .numberPad
		textAlignment = .right
		editingChanged()
	}
	func editingChanged() {
		text = Formatter.currency.string(from: (Double(string.numbers.integer) / 100) as NSNumber)
	}
}
struct Formatter {
	static let currency = NumberFormatter(numberStyle: .currency)
}
extension UITextField {
	var string: String {
		return text ?? "0"
	}
}
extension String {
	var numbers: String {
		return components(separatedBy: Numbers.characterSet.inverted).joined()
	}
	var integer: Int {
		return Int(numbers) ?? 0
	}
}
struct Numbers {
	static let characterSet = CharacterSet(charactersIn: "0123456789")
}
extension NumberFormatter {
	convenience init(numberStyle: NumberFormatter.Style) {
		self.init()
		self.numberStyle = numberStyle
	}
}
