//
//  DeliveryStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/28/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//


import UIKit

class DeliveryStatisticsTableViewController: UITableViewController, UITextFieldDelegate {
	
	@IBAction func endEditing(_ sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	@IBAction func RecievedTextFieldEditingEnded(_ sender: UITextField) {
		let tips = self.amountGivenFinal - self.ticketAmountFinal + self.cashTipsFinal
		let paidOut = Double(self.deliveries.count) * 1.25
		let shouldRecieve = tips + paidOut
		if actuallyRecievedField.text != nil {
			let actuallyRecieved = Double(self.removeFirstCharactersFrom(inputString: self.actuallyRecievedField.text!))
			let difference = actuallyRecieved! - shouldRecieve
			differenceLabel.text = "$" + "\(String(format: "%.2f", difference))"
		} else {
			let actuallyRecieved = 0.00
			let difference = shouldRecieve - actuallyRecieved
			differenceLabel.text = "$" + "\(String(format: "%.2f", difference))"
		}
	}
	@IBOutlet var saveDeliveryDay: UIBarButtonItem!
	@IBOutlet var deliveriesCount: UILabel!
	@IBOutlet var totalSalesLabel: UILabel!
	@IBOutlet var totalAmountGivenLabel: UILabel!
	@IBOutlet var totalTipsLabel: UILabel!
	@IBOutlet var paidoutLabel: UILabel!
	@IBOutlet var amountShouldRecieveTotalsLabel: UILabel!
	@IBOutlet var salesAverageLabel: UILabel!
	@IBOutlet var salesMinLabel: UILabel!
	@IBOutlet var salesMaxLabel: UILabel!
	@IBOutlet var cashSalesLabel: UILabel!
	@IBOutlet var checkSalesLabel: UILabel!
	@IBOutlet var creditSalesLabel: UILabel!
	@IBOutlet var chargeSalesLabel: UILabel!
	@IBOutlet var otherSalesLabel: UILabel!
	@IBOutlet var tipsAverageLabel: UILabel!
	@IBOutlet var tipsMinLabel: UILabel!
	@IBOutlet var tipsMaxLabel: UILabel!
	@IBOutlet var noTipCountLabel: UILabel!
	@IBOutlet var noTipSalesLabel: UILabel!
	@IBOutlet var currentDeliverDayDateLabel: UILabel!
	@IBOutlet var startingBankField: CurrencyField!
	@IBOutlet var bankBalanceLabel: UILabel!
	@IBOutlet var totalDropsLabel: UILabel!
	@IBOutlet var whoMadeBankLabel: UILabel!
	@IBOutlet var whoClosedBankLabel: UILabel!
	@IBOutlet var amountShouldRecieveBankDetailsLabel: UILabel!
	@IBOutlet var actuallyRecievedField: CurrencyField!
	@IBOutlet var differenceLabel: UILabel!
	var deliveryDays = [DeliveryDay]()
	var deliveryDay: DeliveryDay?
	var whoMadeBankLoad: WhoMadeBankTableViewController?
	var deliveryDayViewController: DeliveryDayViewController?
	var deliveries = [Delivery]()
	var drops = [Drop]()
	var ticketAmountArray: [Double] = []
	var ticketAmountFinal: Double = 0.0
	var amountGivenArray: [Double] = []
	var amountGivenFinal: Double = 0.0
	var cashTipsArray: [Double] = []
	var cashTipsFinal: Double = 0.0
	var totalTipsArray: [Double] = []
	var totalTipsFinal: Double = 0.0
	var totalDropsArray: [Double] = []
	var totalDropsFinal: Double = 0.0
	var noTipArray: [String] = []
	var noTipArrayCount = 0
	var cashSalesArray: [Double] = []
	var cashSalesFinal: Double = 0.0
	var checkSalesArray: [Double] = []
	var checkSalesFinal: Double = 0.0
	var creditSalesArray: [Double] = []
	var creditSalesFinal: Double = 0.0
	var chargeSalesArray: [Double] = []
	var chargeSalesFinal: Double = 0.0
	var chargeGivenArray: [Double] = []
	var chargeGivenFinal: Double = 0.0
	var otherSalesArray: [Double] = []
	var otherSalesFinal: Double = 0.0
	var noTipSalesArray: [Double] = []
	var noTipSalesFinal: Double = 0.0
	var whoMadeBank: String = ""
	var whoClosedBank: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		actuallyRecievedField.delegate = self
		if let savedDeliveryDays = loadDeliveryDays() {
			deliveryDays += savedDeliveryDays
		}
	
		if DeliveryDayTableViewController.status != "adding" {
			let selectedDeliveryDay = deliveryDays[Int(DeliveryDayTableViewController.status)!]
			whoMadeBank = selectedDeliveryDay.whoMadeBankName
			whoClosedBank = selectedDeliveryDay.whoClosedBankName
			actuallyRecievedField.text = selectedDeliveryDay.totalRecievedValue
		}
	}
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
	{
		let title = UILabel()
		title.textColor = UIColor.white
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = title.textColor
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?){
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		totalTipsArray.removeAll()
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
				// Sum of totalTips
				var totalTipsDropped = delivery.totalTipsValue
				totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
				let totalTipsRounded = round(Double(totalTipsDropped)! * 100) / 100
				totalTipsArray.append(totalTipsRounded)
				let totalTipsTotaled = totalTipsArray.reduce(0, +)
				self.totalTipsFinal = totalTipsTotaled
			}
			let deliveryCountValue = String(deliveries.count)
			let deliveryDateValue = String(DeliveryDayViewController.selectedDateGlobal) ?? "010116"
			let totalTipsValue = "$" + "\(String(format: "%.2f", totalTipsFinal))"
			let whoMadeBankName = self.whoMadeBank
			let whoClosedBankName = self.whoClosedBank
			let totalRecievedValue = actuallyRecievedField.text
			let manual = false
			deliveryDay = DeliveryDay(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryCountValue, totalTipsValue: totalTipsValue, totalRecievedValue: totalRecievedValue!, whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName, manual: manual)
		}
	}
	
	@IBAction func unwindToDeliveryStatisticsTableList(_ sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? DeliveryDayViewController, let deliveryDay = sourceViewController.deliveryDay {
			if DeliveryDayTableViewController.status != "adding" {
				let selectedIndexPath = Int(DeliveryDayTableViewController.status)
				deliveryDays[selectedIndexPath!] = deliveryDay
			}
			saveDeliveryDays()
		} else if let sourceViewController = sender.source as? WhoMadeBankTableViewController, let name = sourceViewController.whoMadeBank {
			self.whoMadeBank = name.name
		} else if let sourceViewController = sender.source as? WhoClosedBankTableViewController, let name = sourceViewController.whoClosedBank {
			self.whoClosedBank = name.name
		}
	}
	override func viewDidAppear(_ animated: Bool) {
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		cashTipsArray.removeAll()
		totalTipsArray.removeAll()
		noTipArray.removeAll()
		totalDropsArray.removeAll()
		cashSalesArray.removeAll()
		cashSalesArray.removeAll()
		creditSalesArray.removeAll()
		chargeSalesArray.removeAll()
		otherSalesArray.removeAll()
		noTipSalesArray.removeAll()
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
				
				// Sum of cashTips
				var cashTipsDropped = delivery.cashTipsValue
				cashTipsDropped.remove(at: (delivery.cashTipsValue.startIndex))
				let cashTipsRounded = round(Double(cashTipsDropped)! * 100) / 100
				cashTipsArray.append(cashTipsRounded)
				let cashTipsTotaled = cashTipsArray.reduce(0, +)
				self.cashTipsFinal = cashTipsTotaled
				
				// Sum of totalTips
				var totalTipsDropped = delivery.totalTipsValue
				totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
				let totalTipsRounded = round(Double(totalTipsDropped)! * 100) / 100
				totalTipsArray.append(totalTipsRounded)
				let totalTipsTotaled = totalTipsArray.reduce(0, +)
				self.totalTipsFinal = totalTipsTotaled
				
				//NoTipSwitchArray
				noTipArray.append(delivery.noTipSwitchValue)
				
				//Payment Method Sales Total
				
				if delivery.paymentMethodValue == "1" {
					var ticketAmountDropped = delivery.ticketAmountValue
					ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
					let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
					cashSalesArray.append(ticketAmountRounded)
					let cashSalesTotaled = cashSalesArray.reduce(0, +)
					self.cashSalesFinal = cashSalesTotaled
					print("Delivery: " + "\(self.cashSalesFinal)")
				} else if delivery.paymentMethodValue == "2" {
					var ticketAmountDropped = delivery.ticketAmountValue
					ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
					let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
					checkSalesArray.append(ticketAmountRounded)
					let checkSalesTotaled = checkSalesArray.reduce(0, +)
					self.checkSalesFinal = checkSalesTotaled
					print("checkSalesFinal: " + "\(self.checkSalesFinal)")
				} else if delivery.paymentMethodValue == "3" {
					var ticketAmountDropped = delivery.ticketAmountValue
					ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
					let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
					creditSalesArray.append(ticketAmountRounded)
					let creditSalesTotaled = creditSalesArray.reduce(0, +)
					self.creditSalesFinal = creditSalesTotaled
					print("creditSalesFinal: " + "\(self.creditSalesFinal)")
				} else if delivery.paymentMethodValue == "4" {
					var ticketAmountDropped = delivery.ticketAmountValue
					ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
					let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
					chargeSalesArray.append(ticketAmountRounded)
					let chargeSalesTotaled = chargeSalesArray.reduce(0, +)
					self.chargeSalesFinal = chargeSalesTotaled
					var amountGivenDropped = delivery.amountGivenValue
					amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
					let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
					chargeGivenArray.append(amountGivenRounded)
					let chargeGivenTotaled = chargeGivenArray.reduce(0, +)
					self.chargeGivenFinal = chargeGivenTotaled
					print("chargeSalesFinal: " + "\(self.chargeSalesFinal)")
				} else if delivery.paymentMethodValue == "5" {
					var ticketAmountDropped = delivery.ticketAmountValue
					ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
					let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
					otherSalesArray.append(ticketAmountRounded)
					let otherSalesTotaled = otherSalesArray.reduce(0, +)
					self.otherSalesFinal = otherSalesTotaled
					print("otherSalesFinal: " + "\(self.otherSalesFinal)")
				}
				if delivery.noTipSwitchValue == "true" {
					var ticketAmountDropped = delivery.ticketAmountValue
					ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
					let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
					noTipSalesArray.append(ticketAmountRounded)
					let noTipSalesTotaled = noTipSalesArray.reduce(0, +)
					self.noTipSalesFinal = noTipSalesTotaled
					print("noTipSalesFinal: " + "\(self.noTipSalesFinal)")
				}
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
			}
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMddyy"
		let dateFormatted = dateFormatter.date(from: DeliveryDayViewController.selectedDateGlobal)
		dateFormatter.dateFormat = "MM/dd/yy"
		let dateFormattedFinal = dateFormatter.string(from: dateFormatted!)
		var startingBankDropped: String = startingBankField.text ?? "$0.00"
		startingBankDropped.remove(at: (startingBankField.text?.startIndex)!)
		let ticketAmountAverage = ticketAmountArray.reduce(0.0) {
			return $0 + $1/Double(ticketAmountArray.count)
		}
		let totalTipsAverage = totalTipsArray.reduce(0.0) {
			return $0 + $1/Double(totalTipsArray.count)
		}
		let paidoutTotal = Double(deliveries.count) * 1.25
		let amountShouldReceive = (amountGivenFinal - chargeGivenFinal) - (cashSalesFinal + checkSalesFinal + creditSalesFinal + otherSalesFinal) + paidoutTotal + cashTipsFinal
		let bankBalance = (cashSalesFinal + checkSalesFinal + creditSalesFinal + otherSalesFinal) + Double(startingBankDropped)! - totalDropsFinal
		if noTipArray.contains("true") {
			let noTipArrayFilter = noTipArray.filter {
				el in el == "true"
			}
			self.noTipArrayCount = noTipArrayFilter.count
		} else {
			self.noTipArrayCount = 0
		}
		if deliveries.count != 0 {
			deliveriesCount.text = String(deliveries.count)
			totalSalesLabel.text = "$" + "\(String(format: "%.2f", ticketAmountFinal))"
			totalAmountGivenLabel.text = "$" + "\(String(format: "%.2f", amountGivenFinal))"
			totalTipsLabel.text = "$" + "\(String(format: "%.2f", totalTipsFinal))"
			paidoutLabel.text = "$" + "\(String(format: "%.2f", paidoutTotal))"
			amountShouldRecieveTotalsLabel.text = "$" + "\(String(format: "%.2f", amountShouldReceive))"
			if ticketAmountFinal != 0 {
				salesAverageLabel.text = "$" + "\(String(format: "%.2f", ticketAmountAverage))"
				salesMaxLabel.text = "$" + "\(String(format: "%.2f", ticketAmountArray.max()!))"
				salesMinLabel.text = "$" + "\(String(format: "%.2f", ticketAmountArray.min()!))"
				cashSalesLabel.text = "$" + "\(String(format: "%.2f", cashSalesFinal))"
				checkSalesLabel.text = "$" + "\(String(format: "%.2f", checkSalesFinal))"
				creditSalesLabel.text = "$" + "\(String(format: "%.2f", creditSalesFinal))"
				chargeSalesLabel.text = "$" + "\(String(format: "%.2f", chargeSalesFinal))"
				otherSalesLabel.text = "$" + "\(String(format: "%.2f", otherSalesFinal))"
				tipsAverageLabel.text = "$" + "\(String(format: "%.2f", totalTipsAverage))"
				tipsMaxLabel.text = "$" + "\(String(format: "%.2f", totalTipsArray.max()!))"
				tipsMinLabel.text = "$" + "\(String(format: "%.2f", totalTipsArray.min()!))"
				noTipCountLabel.text = String(self.noTipArrayCount)
				noTipSalesLabel.text = "$" + "\(String(format: "%.2f", noTipSalesFinal))"
			}
			currentDeliverDayDateLabel.text = dateFormattedFinal
			bankBalanceLabel.text = "$" + "\(String(format: "%.2f", bankBalance))"
			totalDropsLabel.text = "$" + "\(String(format: "%.2f", totalDropsFinal))"
			whoMadeBankLabel.text = whoMadeBank
			whoClosedBankLabel.text = whoClosedBank
			amountShouldRecieveBankDetailsLabel.text = "$" + "\(String(format: "%.2f", amountShouldReceive))"
		}
	}
	func removeFirstCharactersFrom(inputString: (String)) -> String {
		var tempString = inputString
		tempString.remove(at: (tempString.startIndex))
		return tempString
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	// MARK: NSCoding
	
	func loadDeliveryDays() -> [DeliveryDay]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
	}
	func saveDeliveries() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveries, toFile: Delivery.ArchiveURL.path)
		if !isSuccessfulSave {
			print("save Failed")
		}
	}
	func saveDeliveryDays() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(deliveryDays, toFile: DeliveryDay.ArchiveURL.path)
		if !isSuccessfulSave {
			print("save Failed")
		}
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
	func loadDrops() -> [Drop]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Drop.ArchiveURL.path) as? [Drop]
	}
}
