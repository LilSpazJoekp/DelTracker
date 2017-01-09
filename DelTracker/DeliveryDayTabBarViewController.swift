//
//  DeliveryDayTabBarViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/22/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryDayTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		print("hellovdl")
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		print("hellovda")
	}
}
