//
//  DeliveryDay.swift
//  DelTracker
//
//  Created by Joel Payne on 12/4/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryDay: NSObject, NSCoding {
	
	// MARK: Properties
	
	var deliveryDayViewController: DeliveryDayViewController?
	var deliveryDateValue: String
	var deliveryDayCountValue: String
	var totalTipsValue: String
	var totalRecievedValue: String
	var whoMadeBankName: String
	var whoClosedBankName: String
	var manual: Bool
	
	// MARK: Archiving Paths
	
	static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	static var ArchiveURL = DocumentsDirectory.appendingPathComponent("deliveryDays")
	
	// MARK: Types
	
	struct PropertyKey {
		static let deliveryDateValueKey = "deliveryDateValue"
		static let deliveryDayCountValueKey = "deliveryDayCountValue"
		static let totalTipsValueKey = "totalTipsValue"
		static let totalRecievedValueKey = "totalRecievedValue"
		static let whoMadeBankNameKey = "whoMadeBankName"
		static let whoClosedBankNameKey = "whoClosedBankName"
		static let manualKey = "manual"
	}
	init?(deliveryDateValue: String, deliveryDayCountValue: String, totalTipsValue: String, totalRecievedValue: String, whoMadeBankName: String, whoClosedBankName: String, manual: Bool) {
		self.deliveryDateValue = deliveryDateValue
		self.deliveryDayCountValue = deliveryDayCountValue
		self.totalTipsValue = totalTipsValue
		self.totalRecievedValue = totalRecievedValue
		self.whoMadeBankName = whoMadeBankName
		self.whoClosedBankName = whoClosedBankName
		self.manual = manual
		super.init()
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(deliveryDateValue, forKey: PropertyKey.deliveryDateValueKey)
		aCoder.encode(deliveryDayCountValue, forKey: PropertyKey.deliveryDayCountValueKey)
		aCoder.encode(totalTipsValue, forKey: PropertyKey.totalTipsValueKey)
		aCoder.encode(totalRecievedValue, forKey: PropertyKey.totalRecievedValueKey)
		aCoder.encode(whoMadeBankName, forKey: PropertyKey.whoMadeBankNameKey)
		aCoder.encode(whoClosedBankName, forKey: PropertyKey.whoClosedBankNameKey)
		aCoder.encode(manual, forKey: PropertyKey.manualKey)
	}
	required convenience init?(coder aDecoder: NSCoder) {
		let deliveryDateValue = aDecoder.decodeObject(forKey: PropertyKey.deliveryDateValueKey) as! String
		let deliveryDayCountValue = aDecoder.decodeObject(forKey: PropertyKey.deliveryDayCountValueKey) as! String
		let totalTipsValue = aDecoder.decodeObject(forKey: PropertyKey.totalTipsValueKey) as! String
		let totalRecievedValue = aDecoder.decodeObject(forKey: PropertyKey.totalRecievedValueKey) as! String
		let whoMadeBankName = aDecoder.decodeObject(forKey: PropertyKey.whoMadeBankNameKey) as! String
		let whoClosedBankName = aDecoder.decodeObject(forKey: PropertyKey.whoClosedBankNameKey) as! String
		let manual = aDecoder.decodeBool(forKey: PropertyKey.manualKey)
		self.init(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryDayCountValue, totalTipsValue: totalTipsValue, totalRecievedValue: totalRecievedValue, whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName, manual: manual)
	}
}
