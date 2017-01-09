//
//  DeliveryDay.swift
//  DelTracker
//
//  Created by Joel Payne on 12/4/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryDay: NSObject, NSCoding {
	
	// MARK: Properties
	
	var deliveryDateValue: String
	var deliveryDayCountValue: String
	var totalTipsValue: String
	var totalReceivedValue: String
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
		static let totalReceivedValueKey = "totalReceivedValue"
		static let whoMadeBankNameKey = "whoMadeBankName"
		static let whoClosedBankNameKey = "whoClosedBankName"
		static let manualKey = "manual"
	}
	init?(deliveryDateValue: String, deliveryDayCountValue: String, totalTipsValue: String, totalReceivedValue: String, whoMadeBankName: String, whoClosedBankName: String, manual: Bool) {
		self.deliveryDateValue = deliveryDateValue
		self.deliveryDayCountValue = deliveryDayCountValue
		self.totalTipsValue = totalTipsValue
		self.totalReceivedValue = totalReceivedValue
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
		aCoder.encode(totalReceivedValue, forKey: PropertyKey.totalReceivedValueKey)
		aCoder.encode(whoMadeBankName, forKey: PropertyKey.whoMadeBankNameKey)
		aCoder.encode(whoClosedBankName, forKey: PropertyKey.whoClosedBankNameKey)
		aCoder.encode(manual, forKey: PropertyKey.manualKey)
	}
	required convenience init?(coder aDecoder: NSCoder) {
		let deliveryDateValue = aDecoder.decodeObject(forKey: PropertyKey.deliveryDateValueKey) as! String
		let deliveryDayCountValue = aDecoder.decodeObject(forKey: PropertyKey.deliveryDayCountValueKey) as! String
		let totalTipsValue = aDecoder.decodeObject(forKey: PropertyKey.totalTipsValueKey) as! String
		let totalReceivedValue = aDecoder.decodeObject(forKey: PropertyKey.totalReceivedValueKey) as! String
		let whoMadeBankName = aDecoder.decodeObject(forKey: PropertyKey.whoMadeBankNameKey) as! String
		let whoClosedBankName = aDecoder.decodeObject(forKey: PropertyKey.whoClosedBankNameKey) as! String
		let manual = aDecoder.decodeBool(forKey: PropertyKey.manualKey)
		self.init(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryDayCountValue, totalTipsValue: totalTipsValue, totalReceivedValue: totalReceivedValue, whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName, manual: manual)
	}
}
