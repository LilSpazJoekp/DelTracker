//
//  DeliveryTabBarViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/15/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryTabBarViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
	func loadDrops() -> [Drop]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Drop.ArchiveURL.path) as? [Drop]
	}
}
