//
//  Extensions.swift
//  DelTracker
//
//  Created by Joel Payne on 1/8/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

// MARK: Extensions

extension UIButton {
	func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.setBackgroundImage(colorImage, for: forState)
	}
}
extension UITextField {
	func selectAllText() {
		self.selectedTextRange = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument)
	}
}
extension NumberFormatter {
	convenience init(numberStyle: NumberFormatter.Style) {
		self.init()
		self.numberStyle = numberStyle
	}
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
extension UIBarButtonItem {
	func setTitleWithOutAnimation(title: String?) {
		UIView.setAnimationsEnabled(false)
		self.title = title
		UIView.setAnimationsEnabled(true)
	}
}
extension String {
	mutating func removeDollarSign() -> Double {
		var dropped = self
		dropped.remove(at: (self.startIndex))
		let rounded = round(Double(dropped)! * 100) / 100
		return rounded
	}
}
extension Double {
	func convertToCurrency() -> String {
		let outputString = "$" + "\(String(format: "%.2f", self))"
		return outputString
	}
}
extension Int {
	func getPercentage(_ second: Int) -> String {
		let firstDouble = Double(self)
		let secondDouble = Double(second)
		let resultPercentage = (firstDouble / secondDouble) * 100
		let resultString = String(format: "%.1f", resultPercentage) + "%"
		return resultString
	}
}
extension Double {
	func getDoublePercentage(_ second: Double) -> String {
		let firstDouble = self
		let secondDouble = second
		let resultPercentage = (firstDouble / secondDouble) * 100
		let resultString = String(format: "%.1f", resultPercentage) + "%"
		return resultString
	}
}
extension NSDate {
	func convertToTimeString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hh:mm:ss a"
		let time = dateFormatter.string(from: self as Date)
		return time
	}
}
extension NSDate {
	func convertToDateString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/DD/yy"
		let date = dateFormatter.string(from: self as Date)
		return date
	}
}
extension Date {
	func setDateForPredicate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd"
		let datePredicate = dateFormatter.string(from: self)
		return datePredicate
	}
}
