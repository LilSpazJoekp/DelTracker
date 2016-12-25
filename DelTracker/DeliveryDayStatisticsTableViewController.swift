//
//  DeliveryDayStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/22/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryDayStatisticsTableViewController: UITableViewController {
	
	// MARK: StoryBoard Outlets
	
	@IBOutlet var deliveryDaysCountLabel: UILabel!
	@IBOutlet var deliveriesCountLabel: UILabel!
	@IBOutlet var totalSalesALabel: UILabel!
	@IBOutlet var totalTipsLabel: UILabel!
	@IBOutlet var paidoutLabel: UILabel!
	@IBOutlet var amountReceivedLabel: UILabel!
	@IBOutlet var noTipCountLabel: UILabel!
	@IBOutlet var noTipSalesLabel: UILabel!
	@IBOutlet var noTipPercentageLabel: UILabel!
	@IBOutlet var averageReceivedPerDayLabel: UILabel!
	@IBOutlet var highestReceivedDayLabel: UILabel!
	@IBOutlet var lowestReceivedDayLabel: UILabel!
	@IBOutlet var totalSalesBLabel: UILabel!
	@IBOutlet var cashCountLabel: UILabel!
	@IBOutlet var cashSalesPercentageLabel: UILabel!
	@IBOutlet var cashDeliveryPercentageLabel: UILabel!
	@IBOutlet var cashSalesLabel: UILabel!
	@IBOutlet var checkCountLabel: UILabel!
	@IBOutlet var checkSalesPercentageLabel: UILabel!
	@IBOutlet var checkDeliveryPercentageLabel: UILabel!
	@IBOutlet var checkSalesLabel: UILabel!
	@IBOutlet var creditCountLabel: UILabel!
	@IBOutlet var creditSalesPercentageLabel: UILabel!
	@IBOutlet var creditDeliveryPercentageLabel: UILabel!
	@IBOutlet var creditSalesLabel: UILabel!
	@IBOutlet var chargeCountLabel: UILabel!
	@IBOutlet var chargeSalesPercentageLabel: UILabel!
	@IBOutlet var chargeDeliveryPercentageLabel: UILabel!
	@IBOutlet var chargeSalesLabel: UILabel!
	@IBOutlet var otherCountLabel: UILabel!
	@IBOutlet var otherSalesPercentageLabel: UILabel!
	@IBOutlet var otherDeliveryPercentageLabel: UILabel!
	@IBOutlet var otherSalesLabel: UILabel!
	@IBOutlet var differenceLabel: UILabel!
	@IBOutlet var offCountLabel: UILabel!
	@IBOutlet var offPercentageLabel: UILabel!
	@IBOutlet var highestOverLabel: UILabel!
	@IBOutlet var differenceOverLabel: UILabel!
	@IBOutlet var overCountLabel: UILabel!
	@IBOutlet var overPercentageLabel: UILabel!
	@IBOutlet var highestUnderLabel: UILabel!
	@IBOutlet var differenceUnderLabel: UILabel!
	@IBOutlet var underCountLabel: UILabel!
	@IBOutlet var underPercentageLabel: UILabel!
	@IBOutlet var whoMadeBankTheMostCountLabel: UILabel!
	@IBOutlet var whoMadeBankTheMostPercentageLabel: UILabel!
	@IBOutlet var whoMadeBankTheMostLabel: UILabel!
	@IBOutlet var whoClosedBankTheMostCountLabel: UILabel!
	@IBOutlet var whoClosedBankTheMostPercentageLabel: UILabel!
	@IBOutlet var whoClosedBankTheMostLabel: UILabel!
	
	// MARK: Variables
	
	var tabBar: DeliveryDayTabBarViewController?
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
	var totalTipsValueArray: [Double] = []
	var totalTipsValueFinal: Double = 0.0
	var totalDropsArray: [Double] = []
	var totalDropsFinal: Double = 0.0
	var totalReceivedValueArray: [Double] = []
	var totalReceivedValueFinal: Double = 0.0
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
	var whoMadeBankArray: [String] = []
	var whoClosedBankArray: [String] = []
	var differenceArray: [Double] = []
	var differenceFinal: Double = 0.0
	var differenceOverArray: [Double] = []
	var differenceOverFinal: Double = 0.0
	var differenceUnderArray: [Double] = []
	var differenceUnderFinal: Double = 0.0
	var deliveryDayCount: Int = 0
	var deliveryCount: Int = 0
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	
	// MARK: View Life Cycle
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.tabBarController?.tabBar.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.main.async {
			self.deliveryDaysCountLabel.text = String(self.deliveryDayCount)
			self.deliveriesCountLabel.text = String(self.deliveryCount)
			self.totalSalesALabel.text = self.convertToCurrency(inputDouble: self.ticketAmountFinal)
			self.totalTipsLabel.text = self.convertToCurrency(inputDouble: self.totalTipsFinal)
			self.paidoutLabel.text = self.convertToCurrency(inputDouble: Double(self.deliveryCount) * 1.25)
			self.amountReceivedLabel.text = self.convertToCurrency(inputDouble: self.totalReceivedValueFinal)
			self.noTipCountLabel.text = String(self.noTipSalesArray.count)
			self.noTipSalesLabel.text = self.convertToCurrency(inputDouble: self.noTipSalesFinal)
			self.noTipPercentageLabel.text = self.getPercentage(self.noTipSalesArray.count, self.deliveryCount)
			self.averageReceivedPerDayLabel.text = self.convertToCurrency(inputDouble: (self.totalReceivedValueFinal / Double(self.totalReceivedValueArray.count)))
			self.highestReceivedDayLabel.text = self.convertToCurrency(inputDouble: self.totalReceivedValueArray.max() ?? 0.0)
			self.lowestReceivedDayLabel.text = self.convertToCurrency(inputDouble: self.totalReceivedValueArray.min() ?? 0.0)
			self.totalSalesBLabel.text = self.convertToCurrency(inputDouble: self.ticketAmountFinal)
			self.cashCountLabel.text = String(self.cashSalesArray.count)
			self.cashSalesPercentageLabel.text = self.getDoublePercentage(self.cashSalesFinal, self.ticketAmountFinal)
			self.cashDeliveryPercentageLabel.text = self.getPercentage(self.cashSalesArray.count, self.deliveryCount)
			self.cashSalesLabel.text = self.convertToCurrency(inputDouble: self.cashSalesFinal)
			self.checkCountLabel.text = String(self.checkSalesArray.count)
			self.checkSalesPercentageLabel.text = self.getDoublePercentage(self.checkSalesFinal, self.ticketAmountFinal)
			self.checkDeliveryPercentageLabel.text = self.getPercentage(self.checkSalesArray.count, self.deliveryCount)
			self.checkSalesLabel.text = self.convertToCurrency(inputDouble: self.checkSalesFinal)
			self.creditCountLabel.text = String(self.creditSalesArray.count)
			self.creditSalesPercentageLabel.text = self.getDoublePercentage(self.creditSalesFinal, self.ticketAmountFinal)
			self.creditDeliveryPercentageLabel.text = self.getPercentage(self.creditSalesArray.count, self.deliveryCount)
			self.creditSalesLabel.text = self.convertToCurrency(inputDouble: self.creditSalesFinal)
			self.chargeCountLabel.text = String(self.chargeSalesArray.count)
			self.chargeSalesPercentageLabel.text = self.getDoublePercentage(self.chargeSalesFinal, self.ticketAmountFinal)
			self.chargeDeliveryPercentageLabel.text = self.getPercentage(self.chargeSalesArray.count, self.deliveryCount)
			self.chargeSalesLabel.text = self.convertToCurrency(inputDouble: self.chargeSalesFinal)
			self.otherCountLabel.text = String(self.otherSalesArray.count)
			self.otherSalesPercentageLabel.text = self.getDoublePercentage(self.otherSalesFinal, self.ticketAmountFinal)
			self.otherDeliveryPercentageLabel.text = self.getPercentage(self.otherSalesArray.count, self.deliveryCount)
			self.otherSalesLabel.text = self.convertToCurrency(inputDouble: self.otherSalesFinal)
			self.differenceLabel.text = self.convertToCurrency(inputDouble: self.differenceFinal)
			self.offCountLabel.text = String(self.differenceArray.count)
			self.offPercentageLabel.text = self.getPercentage(self.differenceArray.count, self.deliveryDayCount)
			self.highestOverLabel.text = self.convertToCurrency(inputDouble: self.differenceOverArray.max() ?? 0.0)
			self.differenceOverLabel.text = self.convertToCurrency(inputDouble: self.differenceOverFinal)
			self.overCountLabel.text = String(self.differenceOverArray.count)
			self.overPercentageLabel.text = self.getPercentage(self.differenceOverArray.count, self.differenceArray.count)
			self.highestUnderLabel.text = self.convertToCurrency(inputDouble: self.differenceUnderArray.min() ?? 0.0)
			self.differenceUnderLabel.text = self.convertToCurrency(inputDouble: self.differenceUnderFinal)
			self.underCountLabel.text = String(self.differenceUnderArray.count)
			self.underPercentageLabel.text = self.getPercentage(self.differenceUnderArray.count, self.differenceArray.count)
			let whoMadeBankCountedSet = NSCountedSet(array: self.whoMadeBankArray)
			let whoMadeBankMost = whoMadeBankCountedSet.max {
				whoMadeBankCountedSet.count(for: $0) < whoMadeBankCountedSet.count(for: $1)
			}
			let whoClosedBankCountedSet = NSCountedSet(array: self.whoClosedBankArray)
			let whoClosedBankMost = whoMadeBankCountedSet.max {
				whoClosedBankCountedSet.count(for: $0) < whoClosedBankCountedSet.count(for: $1)
			}
			self.whoMadeBankTheMostCountLabel.text = "\(whoMadeBankCountedSet.count(for: whoMadeBankMost!))"
			self.whoMadeBankTheMostPercentageLabel.text = self.getPercentage(whoMadeBankCountedSet.count(for: whoMadeBankMost!), self.deliveryDayCount)
			self.whoMadeBankTheMostLabel.text = whoMadeBankMost as! String?
			self.whoClosedBankTheMostCountLabel.text = "\(whoClosedBankCountedSet.count(for: whoClosedBankMost!))"
			self.whoClosedBankTheMostPercentageLabel.text = self.getPercentage(whoClosedBankCountedSet.count(for: whoClosedBankMost!), self.deliveryDayCount)
			self.whoClosedBankTheMostLabel.text = whoClosedBankMost as! String?
			self.tableView.reloadData()
		self.messageFrame.removeFromSuperview()
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		activityIndicator(msg: "   Loading...", true)
		DispatchQueue.main.async {
			self.loadData()
		}
		self.tableView.reloadData()
	}
	
	// MARK: TableView Configuration
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
	{
		let title = UILabel()
		title.textColor = UIColor.white
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = title.textColor
	}
	func convertToCurrency(inputDouble: Double) -> String {
		let outputString = "$" + "\(String(format: "%.2f", inputDouble))"
		return outputString
	}
	func loadData() {
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		chargeGivenArray.removeAll()
		cashTipsArray.removeAll()
		totalTipsArray.removeAll()
		totalTipsValueArray.removeAll()
		noTipArray.removeAll()
		totalDropsArray.removeAll()
		totalReceivedValueArray.removeAll()
		cashSalesArray.removeAll()
		checkSalesArray.removeAll()
		creditSalesArray.removeAll()
		chargeSalesArray.removeAll()
		otherSalesArray.removeAll()
		noTipSalesArray.removeAll()
		differenceArray.removeAll()
		differenceOverArray.removeAll()
		differenceUnderArray.removeAll()
		whoMadeBankArray.removeAll()
		whoClosedBankArray.removeAll()
		deliveryDayCount = 0
		deliveryCount = 0
		if let savedDeliveryDays = loadDeliveryDays() {
			deliveryDays = savedDeliveryDays
			for (index, _) in deliveryDays.enumerated() {
				self.deliveryDayCount += 1
				let deliveryDay = deliveryDays[index]
				DeliveryDayViewController.selectedDateGlobal = deliveryDay.deliveryDateValue
				whoMadeBankArray.append(deliveryDay.whoMadeBankName)
				whoClosedBankArray.append(deliveryDay.whoClosedBankName)
				
				// Total Delivery Day Tips - paidout
				var totalTipsValueDropped = deliveryDay.totalTipsValue
				totalTipsValueDropped.remove(at: (deliveryDay.totalTipsValue.startIndex))
				let totalTipsValueRounded = round(Double(totalTipsValueDropped)! * 100) / 100
				totalTipsValueArray.append(Double(String(format: "%.2f", totalTipsValueRounded))!)
				let totalTipsValueTotaled = totalTipsValueArray.reduce(0, +)
				self.totalTipsValueFinal = totalTipsValueTotaled
				
				// Total Delivery Day Received
				var totalReceivedValueDropped = deliveryDay.totalReceivedValue
				totalReceivedValueDropped.remove(at: (deliveryDay.totalReceivedValue.startIndex))
				let totalReceivedValueRounded = round(Double(totalReceivedValueDropped)! * 100) / 100
				totalReceivedValueArray.append(Double(String(format: "%.2f", totalReceivedValueRounded))!)
				let totalReceivedValueTotaled = totalReceivedValueArray.reduce(0, +)
				self.totalReceivedValueFinal = totalReceivedValueTotaled
				
				// Difference
				let deliveryDayDifference = Double(String(format: "%.2f", Double(totalReceivedValueRounded - (totalTipsValueRounded + (Double(deliveryDay.deliveryDayCountValue)! * 1.25)))))!
				if deliveryDayDifference > 0.0 {
					differenceOverArray.append(Double(String(format: "%.2f", deliveryDayDifference))!)
				} else if deliveryDayDifference < 0.0 {
					differenceUnderArray.append(Double(String(format: "%.2f", deliveryDayDifference))!)
				}
				let differenceOverTotaled = differenceOverArray.reduce(0, +)
				self.differenceOverFinal = differenceOverTotaled
				let differenceUnderTotaled = differenceUnderArray.reduce(0, +)
				self.differenceUnderFinal = differenceUnderTotaled
				deliveries.removeAll()
				Delivery.ArchiveURL = Delivery.DocumentsDirectory.appendingPathComponent("\(deliveryDay.deliveryDateValue)")
				if !deliveryDay.manual {
					var savedDeliveries: [Delivery] = []
					if loadDeliveries() != nil {
						savedDeliveries.removeAll()
						deliveries.removeAll()
						Delivery.ArchiveURL = Delivery.DocumentsDirectory.appendingPathComponent("\(deliveryDay.deliveryDateValue)")
						savedDeliveries = loadDeliveries()!
						deliveries = savedDeliveries
						for (index, _) in deliveries.enumerated() {
							self.deliveryCount += 1
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
							} else if delivery.paymentMethodValue == "2" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								checkSalesArray.append(ticketAmountRounded)
								let checkSalesTotaled = checkSalesArray.reduce(0, +)
								self.checkSalesFinal = checkSalesTotaled
							} else if delivery.paymentMethodValue == "3" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								creditSalesArray.append(ticketAmountRounded)
								let creditSalesTotaled = creditSalesArray.reduce(0, +)
								self.creditSalesFinal = creditSalesTotaled
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
							} else if delivery.paymentMethodValue == "5" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								otherSalesArray.append(ticketAmountRounded)
								let otherSalesTotaled = otherSalesArray.reduce(0, +)
								self.otherSalesFinal = otherSalesTotaled
							}
							if delivery.noTipSwitchValue == "true" {
								var ticketAmountDropped = delivery.ticketAmountValue
								ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
								let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
								noTipSalesArray.append(ticketAmountRounded)
								let noTipSalesTotaled = noTipSalesArray.reduce(0, +)
								self.noTipSalesFinal = noTipSalesTotaled
							}
						}
					}
				}
			}
		}
		differenceArray.append(contentsOf: differenceOverArray)
		differenceArray.append(contentsOf: differenceUnderArray)
		let differenceTotaled = differenceArray.reduce(0, +)
		self.differenceFinal = differenceTotaled
	}
	func getPercentage(_ first: Int, _ second: Int) -> String {
		let firstDouble = Double(first)
		let secondDouble = Double(second)
		let resultPercentage = (firstDouble / secondDouble) * 100
		let resultString = String(format: "%.1f", resultPercentage) + "%"
		return resultString
	}
	func getDoublePercentage(_ first: Double, _ second: Double) -> String {
		let firstDouble = first
		let secondDouble = second
		let resultPercentage = (firstDouble / secondDouble) * 100
		let resultString = String(format: "%.1f", resultPercentage) + "%"
		return resultString
	}
	func activityIndicator(msg:String, _ indicator:Bool ) {
		print(msg)
		strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
		strLabel.text = msg
		strLabel.textColor = UIColor.white
		messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 90, width: 180, height: 50))
		messageFrame.layer.cornerRadius = 15
		messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
		if indicator {
			activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
			activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			activityIndicator.startAnimating()
			messageFrame.addSubview(activityIndicator)
		}
		messageFrame.addSubview(strLabel)
		view.addSubview(messageFrame)
	}
	// MARK: NSCodeing
	
	func loadDeliveryDays() -> [DeliveryDay]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
}
