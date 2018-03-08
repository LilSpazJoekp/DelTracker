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
        dateFormatter.dateFormat = "hh:mm a"
        let time = dateFormatter.string(from: self as Date)
        return time
    }
}
extension Date {
    func convertToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let time = dateFormatter.string(from: self as Date)
        return time
    }
}
extension NSDate {
	func convertToDateString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yy"
		let date = dateFormatter.string(from: self as Date)
		return date
	}
}
extension Date {
	func convertToDateString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yy"
		let date = dateFormatter.string(from: self as Date)
		return date
	}
}
extension Date {
	func setDateOfTime(_ deliveryDayDate: NSDate) -> NSDate {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hhmmssa"
		let time = dateFormatter.string(from: self)
		dateFormatter.dateFormat = "MMddyy"
		let date = dateFormatter.string(from: deliveryDayDate as Date)
		dateFormatter.dateFormat = "MMddyyhhmmssa"
		let newDate = dateFormatter.date(from: date + time)
        return newDate! as NSDate
	}
}
extension NSDate {
	func convertToSectionHeader() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		let date = dateFormatter.string(from: self as Date)
		return date
	}
}
extension NSDate {
	func setDateForPredicate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd"
		let datePredicate = dateFormatter.string(from: self as Date)
		return datePredicate
	}
}
extension UILabel {
	func checkForNegative() {
		if var labelText = self.text {
			if labelText.removeDollarSign() < 0.0{
				self.textColor = UIColor.red
			} else {
				self.textColor = UIColor.white
			}
		}
	}
}
extension NSDate {
	func getStartOfDay() -> NSDate {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		let year = dateFormatter.string(from: self as Date)
		dateFormatter.dateFormat = "MM"
		let month = dateFormatter.string(from: self as Date)
		dateFormatter.dateFormat = "dd"
		let day = dateFormatter.string(from: self as Date)
		let hour = "00"
		let minute = "00"
		let second = "00"
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let interval = dateFormatter.date(from: "\(year)-\(month)-\(day) \(hour):\(minute):\(second)")?.timeIntervalSinceReferenceDate
		let startOfDay = NSDate(timeIntervalSinceReferenceDate: interval!)
		return startOfDay
	}
}
extension NSDate {
	func getEndOfDay() -> NSDate {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		let year = dateFormatter.string(from: self as Date)
		dateFormatter.dateFormat = "MM"
		let month = dateFormatter.string(from: self as Date)
		dateFormatter.dateFormat = "dd"
		let day = dateFormatter.string(from: self as Date)
		let hour = "23"
		let minute = "59"
		let second = "59"
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let interval = dateFormatter.date(from: "\(year)-\(month)-\(day) \(hour):\(minute):\(second)")?.timeIntervalSinceReferenceDate
		let endOfDay = NSDate(timeIntervalSinceReferenceDate: interval!)
		return endOfDay
	}
}
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
    @objc func limitLength(_ textField: UITextField) {
		guard let prospectiveText = textField.text,
			prospectiveText.count > maxLength
			else {
				return
		}
		let selection = selectedTextRange
		let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
		text = prospectiveText.substring(to: maxCharIndex)
		selectedTextRange = selection
	}
}
private var selectorColorAssociationKey: UInt8 = 0
extension UIPickerView {
	@IBInspectable var selectorColor: UIColor? {
		get {
			return objc_getAssociatedObject(self, &selectorColorAssociationKey) as? UIColor
		}
		set(newValue) {
			objc_setAssociatedObject(self, &selectorColorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	open override func didAddSubview(_ subview: UIView) {
		super.didAddSubview(subview)
		if let color = selectorColor {
			if subview.bounds.height < 1.0 {
				subview.backgroundColor = color
			}
		}
	}
}
extension UIDatePicker {
	@IBInspectable var selectorColor: UIColor? {
		get {
			return objc_getAssociatedObject(self, &selectorColorAssociationKey) as? UIColor
		}
		set(newValue) {
			objc_setAssociatedObject(self, &selectorColorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	open override func didAddSubview(_ subview: UIView) {
		super.didAddSubview(subview)
		if let color = selectorColor {
			if subview.bounds.height < 1.0 {
				subview.backgroundColor = color
			}
		}
	}
}
extension NSDate {
	var monthYear: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		let monthYear = dateFormatter.string(from: self as Date)
		return monthYear
	}
}
extension Array {
	func getAverageMinMax(_ total: Double) -> (avg: Double, min: Double, max: Double) {
		let array: [Double] = self as! [Double]
		let count: Double = Double(array.count)
		var average: Double?
		var min: Double?
		var max: Double?
		if count != 0 {
			average = total / count
			min = array.min()
			max = array.max()
		} else {
			average = 0
			min = 0
			max = 0
		}
		return (average!, min!, max!)
	}
}
extension DeliveryStatisticsTableViewController {
	func loadTableData() {
		guard let context = mainContext else {
			return
		}
		let deliveryCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		let deliveryDayPredicate = NSPredicate(format: "deliveryDay == %@", deliveryDay!)
		deliveryCountRequest.resultType = .countResultType
		deliveryCountRequest.predicate = deliveryDayPredicate
		
		let dropCountRequest = NSFetchRequest<NSNumber>(entityName: "Drop")
		dropCountRequest.resultType = .countResultType
		dropCountRequest.predicate = deliveryDayPredicate
		
		let noTipCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		let noTipPredicate = NSPredicate(format: "noTip == %@", "1")
		noTipCountRequest.resultType = .countResultType
		noTipCountRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, noTipPredicate])
		
		let sumTicketAmountRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let sumTicketAmount = NSExpressionDescription()
		let maxTicketAmount = NSExpressionDescription()
		let minTicketAmount = NSExpressionDescription()
		let avgTicketAmount = NSExpressionDescription()
		let ticketAmountExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumTicketAmount.name = "sumTicketAmount"
		sumTicketAmount.expression = NSExpression(forFunction: "sum:", arguments: [ticketAmountExpression])
		sumTicketAmount.expressionResultType = .doubleAttributeType
		maxTicketAmount.name = "maxTicketAmount"
		maxTicketAmount.expression = NSExpression(forFunction: "max:", arguments: [ticketAmountExpression])
		maxTicketAmount.expressionResultType = .doubleAttributeType
		minTicketAmount.name = "minTicketAmount"
		minTicketAmount.expression = NSExpression(forFunction: "min:", arguments: [ticketAmountExpression])
		minTicketAmount.expressionResultType = .doubleAttributeType
		avgTicketAmount.name = "avgTicketAmount"
		avgTicketAmount.expression = NSExpression(forFunction: "average:", arguments: [ticketAmountExpression])
		avgTicketAmount.expressionResultType = .doubleAttributeType
		sumTicketAmountRequest.resultType = .dictionaryResultType
		sumTicketAmountRequest.propertiesToFetch = [sumTicketAmount, maxTicketAmount, minTicketAmount, avgTicketAmount]
		sumTicketAmountRequest.predicate = deliveryDayPredicate
		
		let sumAmountGivenRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let sumAmountGiven = NSExpressionDescription()
		let amountGivenExpression = NSExpression(forKeyPath: #keyPath(Delivery.amountGiven))
		sumAmountGiven.name = "sumAmountGiven"
		sumAmountGiven.expression = NSExpression(forFunction: "sum:", arguments: [amountGivenExpression])
		sumAmountGiven.expressionResultType = .doubleAttributeType
		sumAmountGivenRequest.resultType = .dictionaryResultType
		sumAmountGivenRequest.includesPendingChanges = true
		sumAmountGivenRequest.propertiesToFetch = [sumAmountGiven]
		sumAmountGivenRequest.predicate = deliveryDayPredicate
		
		let sumCashTipsRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let cashTipNonZeroPredicate = NSPredicate(format: "cashTips != %@", "0.0")
		let sumCashTips = NSExpressionDescription()
		let maxCashTips = NSExpressionDescription()
		let minCashTips = NSExpressionDescription()
		let avgCashTips = NSExpressionDescription()
		let cashTipsExpression = NSExpression(forKeyPath: #keyPath(Delivery.cashTips))
		sumCashTips.name = "sumCashTips"
		sumCashTips.expression = NSExpression(forFunction: "sum:", arguments: [cashTipsExpression])
		sumCashTips.expressionResultType = .doubleAttributeType
		maxCashTips.name = "maxCashTips"
		maxCashTips.expression = NSExpression(forFunction: "max:", arguments: [cashTipsExpression])
		maxCashTips.expressionResultType = .doubleAttributeType
		minCashTips.name = "minCashTips"
		minCashTips.expression = NSExpression(forFunction: "min:", arguments: [cashTipsExpression])
		minCashTips.expressionResultType = .doubleAttributeType
		avgCashTips.name = "avgCashTips"
		avgCashTips.expression = NSExpression(forFunction: "average:", arguments: [cashTipsExpression])
		avgCashTips.expressionResultType = .doubleAttributeType
		sumCashTipsRequest.resultType = .dictionaryResultType
		sumCashTipsRequest.propertiesToFetch = [sumCashTips, maxCashTips, minCashTips, avgCashTips]
		sumCashTipsRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, cashTipNonZeroPredicate])
		
		let sumTotalTipsRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let totalTipNonZeroPredicate = NSPredicate(format: "totalTips != %@", "0.0")
		let sumTotalTips = NSExpressionDescription()
		let maxTotalTips = NSExpressionDescription()
		let minTotalTips = NSExpressionDescription()
		let avgTotalTips = NSExpressionDescription()
		let totalTipsExpression = NSExpression(forKeyPath: #keyPath(Delivery.totalTips))
		sumTotalTips.name = "sumTotalTips"
		sumTotalTips.expression = NSExpression(forFunction: "sum:", arguments: [totalTipsExpression])
		sumTotalTips.expressionResultType = .doubleAttributeType
		maxTotalTips.name = "maxTotalTips"
		maxTotalTips.expression = NSExpression(forFunction: "max:", arguments: [totalTipsExpression])
		maxTotalTips.expressionResultType = .doubleAttributeType
		minTotalTips.name = "minTotalTips"
		minTotalTips.expression = NSExpression(forFunction: "min:", arguments: [totalTipsExpression])
		minTotalTips.expressionResultType = .doubleAttributeType
		avgTotalTips.name = "avgTotalTips"
		avgTotalTips.expression = NSExpression(forFunction: "average:", arguments: [totalTipsExpression])
		avgTotalTips.expressionResultType = .doubleAttributeType
		sumTotalTipsRequest.resultType = .dictionaryResultType
		sumTotalTipsRequest.propertiesToFetch = [sumTotalTips, maxTotalTips, minTotalTips, avgTotalTips]
		sumTotalTipsRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, totalTipNonZeroPredicate])
		
		let sumNoneSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let nonePredicate = NSPredicate(format: "paymentMethod == %@", "0")
		let sumNoneSales = NSExpressionDescription()
		let maxNoneSales = NSExpressionDescription()
		let minNoneSales = NSExpressionDescription()
		let avgNoneSales = NSExpressionDescription()
		let noneSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumNoneSales.name = "sumNoneSales"
		sumNoneSales.expression = NSExpression(forFunction: "sum:", arguments: [noneSalesExpression])
		sumNoneSales.expressionResultType = .doubleAttributeType
		maxNoneSales.name = "maxNoneSales"
		maxNoneSales.expression = NSExpression(forFunction: "max:", arguments: [noneSalesExpression])
		maxNoneSales.expressionResultType = .doubleAttributeType
		minNoneSales.name = "minNoneSales"
		minNoneSales.expression = NSExpression(forFunction: "min:", arguments: [noneSalesExpression])
		minNoneSales.expressionResultType = .doubleAttributeType
		avgNoneSales.name = "avgNoneSales"
		avgNoneSales.expression = NSExpression(forFunction: "average:", arguments: [noneSalesExpression])
		avgNoneSales.expressionResultType = .doubleAttributeType
		sumNoneSalesRequest.resultType = .dictionaryResultType
		sumNoneSalesRequest.propertiesToFetch = [sumNoneSales, maxNoneSales, minNoneSales, avgNoneSales]
		sumNoneSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, nonePredicate])
		
		let sumCashSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let cashPredicate = NSPredicate(format: "paymentMethod == %@", "1")
		let sumCashSales = NSExpressionDescription()
		let maxCashSales = NSExpressionDescription()
		let minCashSales = NSExpressionDescription()
		let avgCashSales = NSExpressionDescription()
		let cashSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumCashSales.name = "sumCashSales"
		sumCashSales.expression = NSExpression(forFunction: "sum:", arguments: [cashSalesExpression])
		sumCashSales.expressionResultType = .doubleAttributeType
		maxCashSales.name = "maxCashSales"
		maxCashSales.expression = NSExpression(forFunction: "max:", arguments: [cashSalesExpression])
		maxCashSales.expressionResultType = .doubleAttributeType
		minCashSales.name = "minCashSales"
		minCashSales.expression = NSExpression(forFunction: "min:", arguments: [cashSalesExpression])
		minCashSales.expressionResultType = .doubleAttributeType
		avgCashSales.name = "avgCashSales"
		avgCashSales.expression = NSExpression(forFunction: "average:", arguments: [cashSalesExpression])
		avgCashSales.expressionResultType = .doubleAttributeType
		sumCashSalesRequest.resultType = .dictionaryResultType
		sumCashSalesRequest.propertiesToFetch = [sumCashSales, maxCashSales, minCashSales, avgCashSales]
		sumCashSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, cashPredicate])
		
		let sumCheckSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let checkPredicate = NSPredicate(format: "paymentMethod == %@", "2")
		let sumCheckSales = NSExpressionDescription()
		let maxCheckSales = NSExpressionDescription()
		let minCheckSales = NSExpressionDescription()
		let avgCheckSales = NSExpressionDescription()
		let checkSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumCheckSales.name = "sumCheckSales"
		sumCheckSales.expression = NSExpression(forFunction: "sum:", arguments: [checkSalesExpression])
		sumCheckSales.expressionResultType = .doubleAttributeType
		maxCheckSales.name = "maxCheckSales"
		maxCheckSales.expression = NSExpression(forFunction: "max:", arguments: [checkSalesExpression])
		maxCheckSales.expressionResultType = .doubleAttributeType
		minCheckSales.name = "minCheckSales"
		minCheckSales.expression = NSExpression(forFunction: "min:", arguments: [checkSalesExpression])
		minCheckSales.expressionResultType = .doubleAttributeType
		avgCheckSales.name = "avgCheckSales"
		avgCheckSales.expression = NSExpression(forFunction: "average:", arguments: [checkSalesExpression])
		avgCheckSales.expressionResultType = .doubleAttributeType
		sumCheckSalesRequest.resultType = .dictionaryResultType
		sumCheckSalesRequest.propertiesToFetch = [sumCheckSales, maxCheckSales, minCheckSales, avgCheckSales]
		sumCheckSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, checkPredicate])
		
		let sumCreditSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let creditPredicate = NSPredicate(format: "paymentMethod == %@", "3")
		let sumCreditSales = NSExpressionDescription()
		let maxCreditSales = NSExpressionDescription()
		let minCreditSales = NSExpressionDescription()
		let avgCreditSales = NSExpressionDescription()
		let creditSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumCreditSales.name = "sumCreditSales"
		sumCreditSales.expression = NSExpression(forFunction: "sum:", arguments: [creditSalesExpression])
		sumCreditSales.expressionResultType = .doubleAttributeType
		maxCreditSales.name = "maxCreditSales"
		maxCreditSales.expression = NSExpression(forFunction: "max:", arguments: [creditSalesExpression])
		maxCreditSales.expressionResultType = .doubleAttributeType
		minCreditSales.name = "minCreditSales"
		minCreditSales.expression = NSExpression(forFunction: "min:", arguments: [creditSalesExpression])
		minCreditSales.expressionResultType = .doubleAttributeType
		avgCreditSales.name = "avgCreditSales"
		avgCreditSales.expression = NSExpression(forFunction: "average:", arguments: [creditSalesExpression])
		avgCreditSales.expressionResultType = .doubleAttributeType
		sumCreditSalesRequest.resultType = .dictionaryResultType
		sumCreditSalesRequest.propertiesToFetch = [sumCreditSales, maxCreditSales, minCreditSales, avgCreditSales]
		sumCreditSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, creditPredicate])
		
		let sumChargeSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let chargePredicate = NSPredicate(format: "paymentMethod == %@", "4")
		let sumChargeSales = NSExpressionDescription()
		let maxChargeSales = NSExpressionDescription()
		let minChargeSales = NSExpressionDescription()
		let avgChargeSales = NSExpressionDescription()
		let chargeSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumChargeSales.name = "sumChargeSales"
		sumChargeSales.expression = NSExpression(forFunction: "sum:", arguments: [chargeSalesExpression])
		sumChargeSales.expressionResultType = .doubleAttributeType
		maxChargeSales.name = "maxChargeSales"
		maxChargeSales.expression = NSExpression(forFunction: "max:", arguments: [chargeSalesExpression])
		maxChargeSales.expressionResultType = .doubleAttributeType
		minChargeSales.name = "minChargeSales"
		minChargeSales.expression = NSExpression(forFunction: "min:", arguments: [chargeSalesExpression])
		minChargeSales.expressionResultType = .doubleAttributeType
		avgChargeSales.name = "avgChargeSales"
		avgChargeSales.expression = NSExpression(forFunction: "average:", arguments: [chargeSalesExpression])
		avgChargeSales.expressionResultType = .doubleAttributeType
		sumChargeSalesRequest.resultType = .dictionaryResultType
		sumChargeSalesRequest.propertiesToFetch = [sumChargeSales, maxChargeSales, minChargeSales, avgChargeSales]
		sumChargeSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, chargePredicate])
		
		let sumOtherSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let otherPredicate = NSPredicate(format: "paymentMethod == %@", "5")
		let sumOtherSales = NSExpressionDescription()
		let maxOtherSales = NSExpressionDescription()
		let minOtherSales = NSExpressionDescription()
		let avgOtherSales = NSExpressionDescription()
		let otherSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumOtherSales.name = "sumOtherSales"
		sumOtherSales.expression = NSExpression(forFunction: "sum:", arguments: [otherSalesExpression])
		sumOtherSales.expressionResultType = .doubleAttributeType
		maxOtherSales.name = "maxOtherSales"
		maxOtherSales.expression = NSExpression(forFunction: "max:", arguments: [otherSalesExpression])
		maxOtherSales.expressionResultType = .doubleAttributeType
		minOtherSales.name = "minOtherSales"
		minOtherSales.expression = NSExpression(forFunction: "min:", arguments: [otherSalesExpression])
		minOtherSales.expressionResultType = .doubleAttributeType
		avgOtherSales.name = "avgOtherSales"
		avgOtherSales.expression = NSExpression(forFunction: "average:", arguments: [otherSalesExpression])
		avgOtherSales.expressionResultType = .doubleAttributeType
		sumOtherSalesRequest.resultType = .dictionaryResultType
		sumOtherSalesRequest.propertiesToFetch = [sumOtherSales, maxOtherSales, minOtherSales, avgOtherSales]
		sumOtherSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, otherPredicate])
		sumOtherSalesRequest.propertiesToFetch = [sumOtherSales]
		
		let sumNoTipSalesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let sumNoTipSales = NSExpressionDescription()
		let maxNoTipSales = NSExpressionDescription()
		let minNoTipSales = NSExpressionDescription()
		let avgNoTipSales = NSExpressionDescription()
		let noTipSalesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		sumNoTipSales.name = "sumNoTipSales"
		sumNoTipSales.expression = NSExpression(forFunction: "sum:", arguments: [noTipSalesExpression])
		sumNoTipSales.expressionResultType = .doubleAttributeType
		maxNoTipSales.name = "maxNoTipSales"
		maxNoTipSales.expression = NSExpression(forFunction: "max:", arguments: [noTipSalesExpression])
		maxNoTipSales.expressionResultType = .doubleAttributeType
		minNoTipSales.name = "minNoTipSales"
		minNoTipSales.expression = NSExpression(forFunction: "min:", arguments: [noTipSalesExpression])
		minNoTipSales.expressionResultType = .doubleAttributeType
		avgNoTipSales.name = "avgNoTipSales"
		avgNoTipSales.expression = NSExpression(forFunction: "average:", arguments: [noTipSalesExpression])
		avgNoTipSales.expressionResultType = .doubleAttributeType
		sumNoTipSalesRequest.resultType = .dictionaryResultType
		sumNoTipSalesRequest.propertiesToFetch = [sumNoTipSales, maxNoTipSales, minNoTipSales, avgNoTipSales]
		sumNoTipSalesRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, noTipPredicate])
		
		let sumDropAmountRequest = NSFetchRequest<NSDictionary>(entityName: "Drop")
		let sumDropAmount = NSExpressionDescription()
		let dropAmountExpression = NSExpression(forKeyPath: #keyPath(Drop.amount))
		sumDropAmount.name = "sumDropAmount"
		sumDropAmount.expression = NSExpression(forFunction: "sum:", arguments: [dropAmountExpression])
		sumDropAmount.expressionResultType = .doubleAttributeType
		sumDropAmountRequest.resultType = .dictionaryResultType
		sumDropAmountRequest.propertiesToFetch = [sumDropAmount]
		sumDropAmountRequest.predicate = deliveryDayPredicate
		do {
			let deliveryCountResult = try context.fetch(deliveryCountRequest)
			let deliveryCount = deliveryCountResult.first?.doubleValue
			self.tabBarController?.tabBar.items![1].badgeValue = "\(Int(deliveryCount!))"
			deliveriesCount.text = "\(Int(deliveryCount!))"
			if deliveryCount != 0.0 {
				do {
					self.ticketAmountFinal = try context.fetch(sumTicketAmountRequest)
					if self.ticketAmountFinal! != [] as [NSDictionary] {
						let ticketAmountFinalDictionary = self.ticketAmountFinal?.first
						self.totalTicketAmount = (ticketAmountFinalDictionary?["sumTicketAmount"] as! Double?)!
						if self.totalTicketAmount != 0 {
							self.averageTicketAmount = (ticketAmountFinalDictionary?["avgTicketAmount"] as! Double?)!
							self.maxTicketAmount = (ticketAmountFinalDictionary?["maxTicketAmount"] as! Double?)!
							self.minTicketAmount = (ticketAmountFinalDictionary?["minTicketAmount"] as! Double?)!
						}
						
						self.amountGivenFinal = try context.fetch(sumAmountGivenRequest)
						let amountGivenFinalDictionary = self.amountGivenFinal?.first
						let totalAmountGiven: Double = amountGivenFinalDictionary?["sumAmountGiven"] as! Double
						
						self.totalTipsFinal = try context.fetch(sumTotalTipsRequest)
						let totalTipsFinalDictionary = self.totalTipsFinal?.first
						let averageTotalTips: Double = totalTipsFinalDictionary?["avgTotalTips"] as! Double
						let maxTotalTips: Double = totalTipsFinalDictionary?["maxTotalTips"] as! Double
						let minTotalTips: Double = totalTipsFinalDictionary?["minTotalTips"] as! Double
						let totalTotalTips: Double = totalTipsFinalDictionary?["sumTotalTips"] as! Double
						
						self.cashSalesFinal = try context.fetch(sumCashSalesRequest)
						let cashSalesFinalDictionary = self.cashSalesFinal?.first
						let totalCashSales: Double = cashSalesFinalDictionary?["sumCashSales"] as! Double
						
						self.checkSalesFinal = try context.fetch(sumCheckSalesRequest)
						let checkSalesFinalDictionary = self.checkSalesFinal?.first
						let totalCheckSales: Double = checkSalesFinalDictionary?["sumCheckSales"] as! Double
						
						self.creditSalesFinal = try context.fetch(sumCreditSalesRequest)
						let creditSalesFinalDictionary = self.creditSalesFinal?.first
						let totalCreditSales: Double = creditSalesFinalDictionary?["sumCreditSales"] as! Double
						
						self.chargeSalesFinal = try context.fetch(sumChargeSalesRequest)
						let chargeSalesFinalDictionary = self.chargeSalesFinal?.first
						let totalChargeSales: Double = chargeSalesFinalDictionary?["sumChargeSales"] as! Double
						
						self.otherSalesFinal = try context.fetch(sumOtherSalesRequest)
						let otherSalesFinalDictionary = self.otherSalesFinal?.first
						let totalOtherSales: Double = otherSalesFinalDictionary?["sumOtherSales"] as! Double
						
						self.noTipSalesFinal = try context.fetch(sumNoTipSalesRequest)
						let noTipSalesFinalDictionary = self.noTipSalesFinal?.first
						let totalNoTipSales: Double = noTipSalesFinalDictionary?["sumNoTipSales"] as! Double
						
						let dropAmountFinal = try context.fetch(sumDropAmountRequest)
						let dropAmountFinalDictionary = dropAmountFinal.first
						let totalDropAmount: Double = dropAmountFinalDictionary?["sumDropAmount"] as! Double
						
						let deliveryCountResult = try context.fetch(deliveryCountRequest)
						let deliveryCount = deliveryCountResult.first?.doubleValue
						self.tabBarController?.tabBar.items![1].badgeValue = "\(Int(deliveryCount!))"
						self.deliveriesCount.text = "\(Int(deliveryCount!))"
						
						let dropCountResult = try context.fetch(dropCountRequest)
						let dropCount = dropCountResult.first?.doubleValue
						self.tabBarController?.tabBar.items![2].badgeValue = "\(Int(dropCount!))"
						
						let noTipCountResult = try context.fetch(noTipCountRequest)
						let noTipCount = noTipCountResult.first?.doubleValue
						self.noTipCountLabel.text = "\(Int(noTipCount!))"
						
						let paidout = deliveryCount! * 1.25
						self.paidoutLabel.text = paidout.convertToCurrency()
						
						let amountShouldReceive = paidout + totalTotalTips
						self.amountShouldRecieveTotalsLabel.text = amountShouldReceive.convertToCurrency()
						self.amountShouldRecieveBankDetailsLabel.text = amountShouldReceive.convertToCurrency()
						
						if let actuallyReceived = self.actuallyReceivedField.text?.removeDollarSign() {
							let difference = actuallyReceived - amountShouldReceive
							self.differenceLabel.text = difference.convertToCurrency()
							self.differenceLabel.checkForNegative()
							self.deliveryDay?.totalReceived = actuallyReceived
						}
						if let startingBankBalance = self.startingBankField.text?.removeDollarSign() {
							DeliveryStatisticsTableViewController.startingBank = startingBankBalance
							let bankBalance = startingBankBalance + totalTicketAmount - totalChargeSales - totalDropAmount
							self.bankBalanceLabel.text = bankBalance.convertToCurrency()
						}
						self.salesAverageLabel.text = averageTicketAmount.convertToCurrency()
						self.salesMinLabel.text = self.maxTicketAmount.convertToCurrency()
						self.salesMaxLabel.text = self.minTicketAmount.convertToCurrency()
						self.totalSalesLabel.text = totalTicketAmount.convertToCurrency()
						self.totalAmountGivenLabel.text = totalAmountGiven.convertToCurrency()
						self.tipsAverageLabel.text = averageTotalTips.convertToCurrency()
						self.tipsMaxLabel.text = maxTotalTips.convertToCurrency()
						self.tipsMinLabel.text = minTotalTips.convertToCurrency()
						self.totalTipsLabel.text = totalTotalTips.convertToCurrency()
						self.deliveryDay?.totalTips = totalTotalTips
						self.cashSalesLabel.text = totalCashSales.convertToCurrency()
						self.checkSalesLabel.text = totalCheckSales.convertToCurrency()
						self.creditSalesLabel.text = totalCreditSales.convertToCurrency()
						self.chargeSalesLabel.text = totalChargeSales.convertToCurrency()
						self.otherSalesLabel.text = totalOtherSales.convertToCurrency()
						self.noTipSalesLabel.text = totalNoTipSales.convertToCurrency()
					}
				} catch let nserror as NSError {
					let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
					alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
					self.present(alert, animated: true, completion: nil)
				}
			}
			if self.sender == "Who Made Bank" {
				self.whoMadeBankLabel.text = deliveryDay?.whoMadeBank
			} else if self.sender == "Who Closed Bank" {
				self.whoClosedBankLabel.text = deliveryDay?.whoClosedBank
			} else if let deliveryDay = self.deliveryDay {
				if !deliveryDay.manual {
					self.manualDeliverySwitch.isHidden = !deliveryDay.manual
					self.manualDeliverySwitch.isUserInteractionEnabled = !deliveryDay.manual
					self.manualDeliveryDayLabel.isHidden = !deliveryDay.manual
					self.deliveriesCount.isUserInteractionEnabled = !deliveryDay.manual
				}
				self.whoMadeBankLabel.text = deliveryDay.whoMadeBank
				self.whoClosedBankLabel.text = deliveryDay.whoClosedBank
				self.actuallyReceivedField.text = deliveryDay.totalReceived.convertToCurrency()
				self.currentDeliverDayDateLabel.text = deliveryDay.date?.convertToDateString()
				self.differenceLabel.checkForNegative()
			}
			if manualDeliverySwitch.isOn {
				if self.sender == "Who Made Bank" {
					whoMadeBankLabel.text = whoMadeBank?.name
				} else if self.sender == "Who Closed Bank" {
					whoClosedBankLabel.text = whoClosedBank?.name
				} else if let deliveryDay = deliveryDay {
					deliveryDay.manual = manualDeliverySwitch.isOn
					deliveriesCount.text = "\(deliveryDay.deliveryCount)"
					whoMadeBankLabel.text = deliveryDay.whoMadeBank
					whoClosedBankLabel.text = deliveryDay.whoClosedBank
					actuallyReceivedField.text = deliveryDay.totalReceived.convertToCurrency()
					currentDeliverDayDateLabel.text = deliveryDay.date?.convertToDateString()
				}
			}
		} catch let nserror as NSError {
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
