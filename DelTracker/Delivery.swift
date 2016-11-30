//
//  Delivery.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class Delivery: NSObject, NSCoding {
    
    // MARK: Properties
    
    var ticketNumberValue: String
    var ticketAmountValue: String
    var noTipSwitchValue: String
    var amountGivenValue: String
	var cashTipsValue: String
    var totalTipsValue: String
    var paymentMethodValue: String
	
	// MARK: Archiving Paths
	
	static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("deliveries")

	// MARK: Types
	
	struct PropertyKey {
		static let ticketNumberValueKey = "ticketNumberValue"
		static let ticketAmountValueKey = "ticketAmountValue"
		static let noTipSwitchValueKey = "noTipSwitchValue"
		static let amountGivenValueKey = "amountGivenValue"
		static let cashTipsValueKey = "cashTipsValue"
		static let totalTipsValueKey = "totalTipsValue"
		static let paymentMethodValueKey = "paymentMethodValue"
	}
	init?(ticketNumberValue: String, ticketAmountValue: String, noTipSwitchValue: String, amountGivenValue: String, cashTipsValue: String, totalTipsValue: String, paymentMethodValue: String) {
        self.ticketNumberValue = ticketNumberValue
        self.ticketAmountValue = ticketAmountValue
        self.noTipSwitchValue = noTipSwitchValue
        self.amountGivenValue = amountGivenValue
		self.cashTipsValue = cashTipsValue
        self.totalTipsValue = totalTipsValue
        self.paymentMethodValue = paymentMethodValue
		super.init()
        }
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(ticketNumberValue, forKey: PropertyKey.ticketNumberValueKey)
		aCoder.encode(ticketAmountValue, forKey: PropertyKey.ticketAmountValueKey)
		aCoder.encode(noTipSwitchValue, forKey: PropertyKey.noTipSwitchValueKey)
		aCoder.encode(amountGivenValue, forKey: PropertyKey.amountGivenValueKey)
		aCoder.encode(cashTipsValue, forKey: PropertyKey.cashTipsValueKey)
		aCoder.encode(totalTipsValue, forKey: PropertyKey.totalTipsValueKey)
		aCoder.encode(paymentMethodValue, forKey: PropertyKey.paymentMethodValueKey)
	}
	required convenience init?(coder aDecoder: NSCoder) {
		let ticketNumberValue = aDecoder.decodeObject(forKey: PropertyKey.ticketNumberValueKey) as! String
		let ticketAmountValue = aDecoder.decodeObject(forKey: PropertyKey.ticketAmountValueKey) as! String
		let noTipSwitchValue = aDecoder.decodeObject(forKey: PropertyKey.noTipSwitchValueKey) as! String
		let amountGivenValue = aDecoder.decodeObject(forKey: PropertyKey.amountGivenValueKey) as! String
		let cashTipsValue = aDecoder.decodeObject(forKey: PropertyKey.cashTipsValueKey) as! String
		let totalTipsValue = aDecoder.decodeObject(forKey: PropertyKey.totalTipsValueKey) as! String
		let paymentMethodValue = aDecoder.decodeObject(forKey: PropertyKey.paymentMethodValueKey) as! String
		// Must call designated initializer.
		self.init(ticketNumberValue: ticketNumberValue, ticketAmountValue: ticketAmountValue, noTipSwitchValue: noTipSwitchValue, amountGivenValue: amountGivenValue, cashTipsValue: cashTipsValue, totalTipsValue: totalTipsValue, paymentMethodValue: paymentMethodValue)
}
}
