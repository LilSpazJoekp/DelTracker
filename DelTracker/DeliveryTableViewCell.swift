//
//  DeliveryTableViewCell.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryTableViewCell : UITableViewCell {
	@IBOutlet var deliveryNumber: UILabel!
	@IBOutlet var ticketNumberCell: UILabel!
	@IBOutlet var ticketAmountCell: UILabel!
	@IBOutlet var amountGivenCell: UILabel!
	@IBOutlet var cashTipsCell: UILabel!
	@IBOutlet var totalTipsCell: UILabel!
	@IBOutlet var paymentMethodCell: UILabel!
	@IBOutlet var deliveryTimeCell: UILabel!
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
