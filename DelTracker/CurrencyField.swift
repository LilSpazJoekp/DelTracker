//
//  CurrencyField.swift
//  DelTracker
//
//  Created by Joel Payne on 12/23/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class CurrencyField : UITextField {
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

struct Numbers {
	static let characterSet = CharacterSet(charactersIn: "0123456789")
}
