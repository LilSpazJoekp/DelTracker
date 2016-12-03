//
//  Drop.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class Drop: NSObject, NSCoding {
	
	// MARK: Properties
	
	var deliveryDropAmount: String
	
	
	// MARK: Archiving Paths
	
	static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("deliveryDrops")
	
	// MARK: Types
	
	struct DeliveryDropKey {
		static let deliveryDropAmountKey = "deliveryDropAmount"
		
	}
	init?(deliveryDropAmount: String) {
		self.deliveryDropAmount = deliveryDropAmount
		
		super.init()
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(deliveryDropAmount, forKey: DeliveryDropKey.deliveryDropAmountKey)
	}
	required convenience init?(coder aDecoder: NSCoder) {
		let deliveryDropAmount = aDecoder.decodeObject(forKey: DeliveryDropKey.deliveryDropAmountKey) as! String
		// Must call designated initializer.
		self.init(deliveryDropAmount: deliveryDropAmount)
	}
}
