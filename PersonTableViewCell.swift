//
//  PersonTableViewCell.swift
//  DelTracker
//
//  Created by Joel Payne on 12/7/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class PersonTableViewCell: UITableViewCell {
	@IBOutlet var personName: UILabel!
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
