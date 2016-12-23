//
//  DeliveryDayStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/22/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryDayStatisticsTableViewController: UITableViewController {
	var tabBar: DeliveryDayTabBarViewController?
	// MARK: StoryBoard Outlets
	
	@IBOutlet var deliveryDaysCountLabel: UILabel!
	@IBOutlet var deliveriesCountLabel: UILabel!
	@IBOutlet var totalSalesALabel: UILabel!
	@IBOutlet var totalTipsLabel: UILabel!
	@IBOutlet var paidoutLabel: UILabel!
	@IBOutlet var amountRecievedLabel: UILabel!
	@IBOutlet var noTipCountLabel: UILabel!
	@IBOutlet var noTipSalesLabel: UILabel!
	@IBOutlet var noTipPercentageLabel: UILabel!
	@IBOutlet var averageReceivedPerDayLabel: UILabel!
	@IBOutlet var highestReceivedDayLabel: UILabel!
	@IBOutlet var lowestReceivedDayLabel: UILabel!
	@IBOutlet var totalSalesBLabel: UILabel!
	@IBOutlet var cashSalesLabel: UILabel!
	@IBOutlet var cashSalesPercentageLabel: UILabel!
	@IBOutlet var checkSalesLabel: UILabel!
	@IBOutlet var checkSalesPercentageLabel: UILabel!
	@IBOutlet var creditSalesLabel: UILabel!
	@IBOutlet var creditSalesPercentageLabel: UILabel!
	@IBOutlet var chargeSalesLabel: UILabel!
	@IBOutlet var chargeSalesPercentageLabel: UILabel!
	@IBOutlet var otherSalesLabel: UILabel!
	@IBOutlet var otherSalesPercentageLabel: UILabel!
	@IBOutlet var differenceLabel: UILabel!
	@IBOutlet var offCountLabel: UILabel!
	@IBOutlet var highestOver: UILabel!
	@IBOutlet var highestUnder: UILabel!
	@IBOutlet var whoMadeBankTheMostLabel: UILabel!
	@IBOutlet var whoClosedBankTheMostLabel: UILabel!
	
	// MARK: Variables
	
	var deliveryDays = [DeliveryDay]()
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
	
	// MARK: View Life Cycle
	
	override func viewWillAppear(_ animated: Bool) {
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		chargeGivenArray.removeAll()
		cashTipsArray.removeAll()
		totalTipsArray.removeAll()
		noTipArray.removeAll()
		totalDropsArray.removeAll()
		cashSalesArray.removeAll()
		checkSalesArray.removeAll()
		creditSalesArray.removeAll()
		chargeSalesArray.removeAll()
		otherSalesArray.removeAll()
		noTipSalesArray.removeAll()
		self.tabBarController?.tabBar.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		if let savedDeliveryDays = loadDeliveryDays() {
			deliveryDays = savedDeliveryDays
			for (index, _) in deliveryDays.enumerated() {
				let deliveryDay = deliveryDays[index]
				DeliveryDayViewController.selectedDateGlobal = deliveryDay.deliveryDateValue
				print(DeliveryDayViewController.selectedDateGlobal)
				if !deliveryDay.manual {
					var savedDeliveries: [Delivery] = []
					if loadDeliveries() != nil {
						savedDeliveries.removeAll()
						deliveries.removeAll()
						Delivery.ArchiveURL = Delivery.DocumentsDirectory.appendingPathComponent("\(deliveryDay.deliveryDateValue)")
						savedDeliveries = loadDeliveries()!
						deliveries = savedDeliveries
						for (index, _) in deliveries.enumerated() {
							let delivery = deliveries[index]
							var ticketAmountDropped = delivery.ticketAmountValue
							ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
							let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
							ticketAmountArray.append(ticketAmountRounded)
							let ticketAmountTotaled = ticketAmountArray.reduce(0, +)
							self.ticketAmountFinal = ticketAmountTotaled
							print("self.ticketAmountFinal " + String(self.ticketAmountFinal))
							print(ticketAmountArray)
							
							// Sum of amountGiven
							var amountGivenDropped = delivery.amountGivenValue
							amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
							let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
							amountGivenArray.append(amountGivenRounded)
							let amountGivenTotaled = amountGivenArray.reduce(0, +)
							self.amountGivenFinal = amountGivenTotaled
							print("self.amountGivenFinal " + String(self.amountGivenFinal))
							print(amountGivenArray)
							
							// Sum of cashTips
							var cashTipsDropped = delivery.cashTipsValue
							cashTipsDropped.remove(at: (delivery.cashTipsValue.startIndex))
							let cashTipsRounded = round(Double(cashTipsDropped)! * 100) / 100
							cashTipsArray.append(cashTipsRounded)
							let cashTipsTotaled = cashTipsArray.reduce(0, +)
							self.cashTipsFinal = cashTipsTotaled
							print("self.cashTipsFinal " + String(self.cashTipsFinal))
							print(cashTipsArray)
							
							// Sum of totalTips
							var totalTipsDropped = delivery.totalTipsValue
							totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
							let totalTipsRounded = round(Double(totalTipsDropped)! * 100) / 100
							totalTipsArray.append(totalTipsRounded)
							let totalTipsTotaled = totalTipsArray.reduce(0, +)
							self.totalTipsFinal = totalTipsTotaled
							print("self.totalTipsFinal " + String(self.totalTipsFinal))
							print(totalTipsArray)
							
							//NoTipSwitchArray
							noTipArray.append(delivery.noTipSwitchValue)
							print("noTipArray ")
							print(noTipArray)
							
							//Payment Method Sales Total
							if delivery.paymentMethodValue == "1" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								cashSalesArray.append(ticketAmountRounded)
								let cashSalesTotaled = cashSalesArray.reduce(0, +)
								self.cashSalesFinal = cashSalesTotaled
								print("self.cashSalesFinal " + String(self.cashSalesFinal))
								print(cashSalesArray)
							} else if delivery.paymentMethodValue == "2" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								checkSalesArray.append(ticketAmountRounded)
								let checkSalesTotaled = checkSalesArray.reduce(0, +)
								self.checkSalesFinal = checkSalesTotaled
								print("self.checkSalesFinal " + String(self.checkSalesFinal))
								print(checkSalesArray)
							} else if delivery.paymentMethodValue == "3" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								creditSalesArray.append(ticketAmountRounded)
								let creditSalesTotaled = creditSalesArray.reduce(0, +)
								self.creditSalesFinal = creditSalesTotaled
								print("self.creditSalesFinal " + String(self.creditSalesFinal))
								print(creditSalesArray)
							} else if delivery.paymentMethodValue == "4" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								chargeSalesArray.append(ticketAmountRounded)
								let chargeSalesTotaled = chargeSalesArray.reduce(0, +)
								self.chargeSalesFinal = chargeSalesTotaled
								print("self.chargeSalesFinal " + String(self.chargeSalesFinal))
								print(chargeSalesArray)
								var amountGivenDropped = delivery.amountGivenValue
								amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
								let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
								chargeGivenArray.append(amountGivenRounded)
								let chargeGivenTotaled = chargeGivenArray.reduce(0, +)
								self.chargeGivenFinal = chargeGivenTotaled
								print("self.chargeGivenFinal " + String(self.chargeGivenFinal))
								print(chargeGivenArray)
							} else if delivery.paymentMethodValue == "5" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								otherSalesArray.append(ticketAmountRounded)
								let otherSalesTotaled = otherSalesArray.reduce(0, +)
								self.otherSalesFinal = otherSalesTotaled
								print("self.otherSalesFinal " + String(self.otherSalesFinal))
								print(otherSalesArray)
							}
							if delivery.noTipSwitchValue == "true" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								noTipSalesArray.append(ticketAmountRounded)
								let noTipSalesTotaled = noTipSalesArray.reduce(0, +)
								self.noTipSalesFinal = noTipSalesTotaled
								print("self.noTipSalesFinal " + String(self.noTipSalesFinal))
								print(noTipSalesArray)
							}
						}
					}
				}
			}
		}
	}
	
	// MARK: TableView Configuration
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
	{
		let title = UILabel()
		title.textColor = UIColor.white
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = title.textColor
	}
	
}

// MARK: NSCodeing

func loadDeliveryDays() -> [DeliveryDay]? {
	return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
}
func loadDeliveries() -> [Delivery]? {
	return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
}
