//
//  DeliveryStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/28/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//


import UIKit

class DeliveryStatisticsTableViewController: UITableViewController {
	@IBOutlet var deliveriesCount: UILabel!
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
	@IBOutlet var startingBankField: CurrencyField!
	@IBOutlet var bankBalanceLabel: UILabel!
	@IBOutlet var totalDropsLabel: UILabel!
	@IBOutlet var actualBalanceLabel: UILabel!
	@IBOutlet var actuallyRecievedField: CurrencyField!
	var deliveries = [Delivery]()
	var drops = [Drop]()
	var ticketAmountFinal: Double = 0.0
	var amountGivenFinal: Double = 0.0
	var cashTipsFinal: Double = 0.0
	var totalTipsFinal: Double = 0.0
	var totalDropsFinal: Double = 0.0
	var totalDropsArray: [Double] = []
	var ticketAmountArray: [Double] = []
	var amountGivenArray: [Double] = []
	var noTipArray: [String] = []
	var cashTipsArray: [Double] = []
	var totalTipsArray: [Double] = []
	func saveDeliverys() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveries, toFile: Delivery.ArchiveURL.path)
		if !isSuccessfulSave {
			print("Failed to save deliveries...")
		}
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
	func loadDrops() -> [Drop]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Drop.ArchiveURL.path) as? [Drop]
	}
	override func viewDidLoad() {
		print("viewDidload")
		super.viewDidLoad()
	}
	var noTipArrayCount = 0
	
	override func viewDidAppear(_ animated: Bool) {
		print("viewDidAppear")
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		cashTipsArray.removeAll()
		totalTipsArray.removeAll()
		noTipArray.removeAll()
		totalDropsArray.removeAll()
		if let savedDeliveries = loadDeliveries() {
			deliveries = savedDeliveries
			for (index, _) in deliveries.enumerated() {
				let delivery = deliveries[index]
					var ticketAmountDropped = delivery.ticketAmountValue
				ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
				let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
				ticketAmountArray.append(ticketAmountRounded)
				let ticketAmountTotaled = ticketAmountArray.reduce(0, +)
				self.ticketAmountFinal = ticketAmountTotaled
				// Sum of amountGiven
					var amountGivenDropped = delivery.amountGivenValue
				amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
				let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
				amountGivenArray.append(amountGivenRounded)
				let amountGivenTotaled = amountGivenArray.reduce(0, +)
				self.amountGivenFinal = amountGivenTotaled
				print("amountGivenFinal")
					// Sum of cashTips
					var cashTipsDropped = delivery.cashTipsValue
				cashTipsDropped.remove(at: (delivery.cashTipsValue.startIndex))
				let cashTipsRounded = round(Double(cashTipsDropped)! * 100) / 100
				cashTipsArray.append(cashTipsRounded)
				let cashTipsTotaled = cashTipsArray.reduce(0, +)
				self.cashTipsFinal = cashTipsTotaled
				print("cashTipsFinal")
				// Sum of totalTips
					var totalTipsDropped = delivery.totalTipsValue
				totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
				let totalTipsRounded = round(Double(totalTipsDropped)! * 100) / 100
				totalTipsArray.append(totalTipsRounded)
				let totalTipsTotaled = totalTipsArray.reduce(0, +)
				self.totalTipsFinal = totalTipsTotaled
				print("totalTipsFinal")
				// Actually Recieved
				var actuallyRecievedDropped: String = actuallyRecievedField.text!
				actuallyRecievedDropped.remove(at: (actuallyRecievedField.text?.startIndex)!)
				let actuallyRecievedFinal = actuallyRecievedDropped
				print("actuallyRecievedFinal")
					noTipArray.append(delivery.noTipSwitchValue)
			}
		}
		if let savedDrops = loadDrops() {
			drops = savedDrops
			for (index, _) in drops.enumerated() {
				let drop = drops[index]
					var totalDropsDropped = drop.deliveryDropAmount
				totalDropsDropped.remove(at: (drop.deliveryDropAmount.startIndex))
				let totalDropsRounded = round(Double(totalDropsDropped)! * 100) / 100
				totalDropsArray.append(totalDropsRounded)
				let totalDropsTotaled = totalDropsArray.reduce(0, +)
				self.totalDropsFinal = totalDropsTotaled
				print("totalDropsFinal")
				}
		}
		deliveriesCount.text = "0"
		totalSalesLabel.text = "0"
		totalAmountGivenLabel.text = "0"
		totalTipsLabel.text = "0"
		paidoutLabel.text = "0"
		shouldRecieveLabel.text = "0"
		salesMaxLabel.text = "0"
		salesMinLabel.text = "0"
		salesAverageLabel.text = "0"
		tipsMaxLabel.text = "0"
		tipsMinLabel.text = "0"
		tipsAverageLabel.text = "0"
		totalDropsLabel.text = "0"
		bankBalanceLabel.text = "0"
		noTipCountLabel.text = "0"
		var startingBankDropped: String = startingBankField.text ?? "$0.00"
		startingBankDropped.remove(at: (startingBankField.text?.startIndex)!)
		let ticketAmountAverage = ticketAmountArray.reduce(0.0) {
			return $0 + $1/Double(ticketAmountArray.count)
		}
		let totalTipsAverage = totalTipsArray.reduce(0.0) {
			return $0 + $1/Double(totalTipsArray.count)
		}
		let paidoutTotal = Double(deliveries.count) * 1.25
		let amountShouldReceive = amountGivenFinal - ticketAmountFinal + paidoutTotal + cashTipsFinal
		let bankBalance = ticketAmountFinal + Double(startingBankDropped)! - totalDropsFinal
		if noTipArray.contains("true") {
			let noTipArrayFilter = noTipArray.filter {
				el in el == "true"
			}
			self.noTipArrayCount = noTipArrayFilter.count
		} else {
			self.noTipArrayCount = 0
		}
		deliveriesCount.text = String(deliveries.count)
		totalSalesLabel.text = "$" + "\(String(format: "%.2f", ticketAmountFinal))"
		totalAmountGivenLabel.text = "$" + "\(String(format: "%.2f", amountGivenFinal))"
		totalTipsLabel.text = "$" + "\(String(format: "%.2f", totalTipsFinal))"
		paidoutLabel.text = "$" + "\(String(format: "%.2f", paidoutTotal))"
		shouldRecieveLabel.text = "$" + "\(String(format: "%.2f", amountShouldReceive))"
		salesMaxLabel.text = "$" + "\(String(format: "%.2f", ticketAmountArray.max()!))"
		salesMinLabel.text = "$" + "\(String(format: "%.2f", ticketAmountArray.min()!))"
		salesAverageLabel.text = "$" + "\(String(format: "%.2f", ticketAmountAverage))"
		tipsMaxLabel.text = "$" + "\(String(format: "%.2f", totalTipsArray.max()!))"
		tipsMinLabel.text = "$" + "\(String(format: "%.2f", totalTipsArray.min()!))"
		tipsAverageLabel.text = "$" + "\(String(format: "%.2f", totalTipsAverage))"
		totalDropsLabel.text = "$" + "\(String(format: "%.2f", totalDropsFinal))"
		bankBalanceLabel.text = "$" + "\(String(format: "%.2f", bankBalance))"
		noTipCountLabel.text = String(self.noTipArrayCount)
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}
