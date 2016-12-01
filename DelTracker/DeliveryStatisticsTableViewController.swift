//
//  DeliveryStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/28/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//


import UIKit

class DeliveryStatisticsTableViewController: UITableViewController {
	@IBOutlet var totalSalesLabel: UILabel!
	@IBOutlet var totalAmountGivenLabel: UILabel!
	@IBOutlet var totalTipsLabel: UILabel!
	@IBOutlet var paidoutLabel: UILabel!
	@IBOutlet var shouldRecieveLabel: UILabel!
	@IBOutlet var salesAverageLabel: UILabel!
	@IBOutlet var salesMinLabel: UILabel!
	@IBOutlet var salesMaxLabel: UILabel!
	@IBOutlet var tipsAverageLabel: UILabel!
	@IBOutlet var tipsMinLabel: UILabel!
	@IBOutlet var tipsMaxLabel: UILabel!
	@IBOutlet var noTipCountLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	let deliveryTable = DeliveryTableViewController()
	override func viewDidAppear(_ animated: Bool) {
		let paidoutTotal = Double(deliveryTable.deliveries.count) * 1.25
		let amountShouldReceive = deliveryTable.amountGivenFinal - deliveryTable.ticketAmountFinal + paidoutTotal + deliveryTable.cashTipsFinal
		totalSalesLabel.text = "$" + "\(deliveryTable.ticketAmountFinal)"
		totalAmountGivenLabel.text = "$" + "\(deliveryTable.amountGivenFinal)"
		totalTipsLabel.text = "$" + "\(deliveryTable.totalTipsFinal)"
		paidoutLabel.text = "$" + "\(paidoutTotal)"
		shouldRecieveLabel.text = "$" + "\(amountShouldReceive)"
		print(deliveryTable.ticketAmountFinal) // result: 0.0
		print(deliveryTable.amountGivenFinal) // result: 0.0
		print(deliveryTable.cashTipsFinal) // result: 0.0
		print(deliveryTable.totalTipsFinal) // result: 0.0
	}
}
