//
//  WhoClosedBank.swift
//  DelTracker
//
//  Created by Joel Payne on 12/8/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class WhoClosedBank: NSObject, NSCoding {
	
	// MARK: Properties
	
	var name: String
	var deliveryDay: DeliveryDayViewController?
	
	// MARK: Archiving Paths
	
	static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	static var ArchiveURL = DocumentsDirectory.appendingPathComponent("WhoClosedBank" + "\(DeliveryDayViewController.selectedDateGlobal)")
	
	// MARK: Types
	
	struct PropertyKey {
		static let nameKey = "name"
	}
	init?(name: String) {
		self.name = name
		super.init()
	}
	
	//MARK: NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKey.nameKey)
	}
	required convenience init?(coder aDecoder: NSCoder) {
		let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
		
		// Must call designated initializer.
		self.init(name: name)
	}
}
