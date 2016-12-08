//
//  DeliveryStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/28/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//


import UIKit

class DeliveryStatisticsTableViewController: UITableViewController {
	
	@IBOutlet var saveDeliveryDay: UIBarButtonItem!
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
	@IBOutlet var whoMadeBankLabel: UILabel!
	@IBOutlet var whoClosedBankLabel: UILabel!
	@IBOutlet var actualBalanceLabel: UILabel!
	@IBOutlet var actuallyRecievedField: CurrencyField!
	@IBOutlet var differenceLabel: UILabel!
	@IBOutlet var cashSalesLabel: UILabel!
	@IBOutlet var checkSalesLabel: UILabel!
	@IBOutlet var creditSalesLabel: UILabel!
	@IBOutlet var chargeSalesLabel: UILabel!
	@IBOutlet var otherSalesLabel: UILabel!
	var deliveryDays = [DeliveryDay]()
	var deliveryDay: DeliveryDay?
	
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
	var noTipArrayCount = 0
	
	
	override func viewDidLoad() {
		print("viewDidload")
		super.viewDidLoad()
		if let savedDeliveryDays = loadDeliveryDays() {
			deliveryDays += savedDeliveryDays
		}
		//whoMadeBankLabel.text = deliveryDay?.whoMadeBankName
		//	whoClosedBankLabel.text = deliveryDay?.whoClosedBankName
		//	actuallyRecievedField.text = deliveryDay?.totalRecievedValue
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
			let whoMadeBankName = WhoMadeBankTableViewController.whoDidBag
			let whoClosedBankName = WhoClosedBankTableViewController.whoDidBag
			
			func totalRecievedValue(input1: (String), input2: (String)) -> String {
				if actuallyRecievedField.text != "$0.00" {
					let totalRecievedValue = input1
					return totalRecievedValue
				} else {
					let totalRecievedValue = input2
					return totalRecievedValue
				}
			}
			deliveryDay = DeliveryDay(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryCountValue, totalTipsValue: totalTipsValue, totalRecievedValue: totalRecievedValue(input1: (actuallyRecievedField.text)!, input2: (shouldRecieveLabel.text)!), whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName)
			
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		print("viewDidAppear")
		let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		
		do {
			// Get the directory contents urls (including subfolders urls)
			let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
			print(directoryContents)
			
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
		whoMadeBankLabel.text = deliveryDay?.whoMadeBankName
		whoClosedBankLabel.text = deliveryDay?.whoClosedBankName
		
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
		let difference = Double(removeFirstCharactersFrom(inputString: actuallyRecievedField.text!))! - amountShouldReceive
		
		deliveriesCount.text = String(deliveries.count)
		totalSalesLabel.text = "$" + "\(String(format: "%.2f", ticketAmountFinal))"
		totalAmountGivenLabel.text = "$" + "\(String(format: "%.2f", amountGivenFinal))"
		totalTipsLabel.text = "$" + "\(String(format: "%.2f", totalTipsFinal))"
		paidoutLabel.text = "$" + "\(String(format: "%.2f", paidoutTotal))"
		shouldRecieveLabel.text = "$" + "\(String(format: "%.2f", amountShouldReceive))"
		if deliveries.count != 0 {
			if ticketAmountFinal != 0 {
				salesMaxLabel.text = "$" + "\(String(format: "%.2f", ticketAmountArray.max()!))"
				salesMinLabel.text = "$" + "\(String(format: "%.2f", ticketAmountArray.min()!))"
				salesAverageLabel.text = "$" + "\(String(format: "%.2f", ticketAmountAverage))"
				tipsMaxLabel.text = "$" + "\(String(format: "%.2f", totalTipsArray.max()!))"
				tipsMinLabel.text = "$" + "\(String(format: "%.2f", totalTipsArray.min()!))"
				tipsAverageLabel.text = "$" + "\(String(format: "%.2f", totalTipsAverage))"
			}
		}
		totalDropsLabel.text = "$" + "\(String(format: "%.2f", totalDropsFinal))"
		bankBalanceLabel.text = "$" + "\(String(format: "%.2f", bankBalance))"
		differenceLabel.text = "$" + "\(String(format: "%.2f", difference))"
		noTipCountLabel.text = String(self.noTipArrayCount)
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
}
