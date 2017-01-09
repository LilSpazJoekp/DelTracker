//
//  DeliveryDayStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/22/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

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
	var coreDeliveries = [Delivery]()
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
	var tNumberArray: [Int] = []
	var tAmountArray: [Double] = []
	var aGivenArray: [Double] = []
	var cTipsArray: [Double] = []
	var tTipsArray: [Double] = []
	var deliveriesArray: [DeliveryDayStatisticsTableViewController.deliveryStruct] = []
	
	struct deliveryStruct {
		var ticketNumberValue: String
		var ticketAmountValue: String
		var noTipSwitchValue: String
		var amountGivenValue: String
		var cashTipsValue: String
		var totalTipsValue: String
		var paymentMethodValue: String
		var deliveryTimeValue: String
		var ticketPhotoValue: UIImage?
	}
	
	// MARK: View Life Cycle
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.tabBarController?.tabBar.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//DispatchQueue.main.async {
		self.deliveryDaysCountLabel.text = String(self.deliveryDayCount)
		self.deliveriesCountLabel.text = String(self.deliveryCount)
		self.totalSalesALabel.text = self.ticketAmountFinal.convertToCurrency()
		self.totalTipsLabel.text = self.totalTipsFinal.convertToCurrency()
		let paidutDouble: Double = Double(self.deliveryCount) * 1.25
		self.paidoutLabel.text = paidutDouble.convertToCurrency()
		self.amountReceivedLabel.text = self.totalReceivedValueFinal.convertToCurrency()
		self.noTipCountLabel.text = String(self.noTipSalesArray.count)
		self.noTipSalesLabel.text = self.noTipSalesFinal.convertToCurrency()
		self.noTipPercentageLabel.text = self.noTipSalesArray.count.getPercentage(self.deliveryCount)
		var averageRecievedPerDayDouble: Double
		if self.totalReceivedValueArray.count > 0 {
			averageRecievedPerDayDouble = self.totalReceivedValueFinal / Double(self.totalReceivedValueArray.count)
		} else {
			averageRecievedPerDayDouble = 0.0
		}
		self.averageReceivedPerDayLabel.text = averageRecievedPerDayDouble.convertToCurrency()
		self.highestReceivedDayLabel.text = self.totalReceivedValueArray.max()?.convertToCurrency()
		self.lowestReceivedDayLabel.text = self.totalReceivedValueArray.min()?.convertToCurrency()
		self.totalSalesBLabel.text = self.ticketAmountFinal.convertToCurrency()
		self.cashCountLabel.text = String(self.cashSalesArray.count)
		self.cashSalesPercentageLabel.text = self.cashSalesFinal.getDoublePercentage(self.ticketAmountFinal)
		self.cashDeliveryPercentageLabel.text = self.cashSalesArray.count.getPercentage(self.deliveryCount)
		self.cashSalesLabel.text = self.cashSalesFinal.convertToCurrency()
		self.checkCountLabel.text = String(self.checkSalesArray.count)
		self.checkSalesPercentageLabel.text = self.checkSalesFinal.getDoublePercentage(self.ticketAmountFinal)
		self.checkDeliveryPercentageLabel.text = self.checkSalesArray.count.getPercentage(self.deliveryCount)
		self.checkSalesLabel.text = self.checkSalesFinal.convertToCurrency()
		self.creditCountLabel.text = String(self.creditSalesArray.count)
		self.creditSalesPercentageLabel.text = self.creditSalesFinal.getDoublePercentage(self.ticketAmountFinal)
		self.creditDeliveryPercentageLabel.text = self.creditSalesArray.count.getPercentage(self.deliveryCount)
		self.creditSalesLabel.text = self.creditSalesFinal.convertToCurrency()
		self.chargeCountLabel.text = String(self.chargeSalesArray.count)
		self.chargeSalesPercentageLabel.text = self.chargeSalesFinal.getDoublePercentage(self.ticketAmountFinal)
		self.chargeDeliveryPercentageLabel.text = self.chargeSalesArray.count.getPercentage(self.deliveryCount)
		self.chargeSalesLabel.text = self.chargeSalesFinal.convertToCurrency()
		self.otherCountLabel.text = String(self.otherSalesArray.count)
		self.otherSalesPercentageLabel.text = self.otherSalesFinal.getDoublePercentage(self.ticketAmountFinal)
		self.otherDeliveryPercentageLabel.text = self.otherSalesArray.count.getPercentage(self.deliveryCount)
		self.otherSalesLabel.text = self.otherSalesFinal.convertToCurrency()
		self.differenceLabel.text = self.differenceFinal.convertToCurrency()
		self.offCountLabel.text = String(self.differenceArray.count)
		self.offPercentageLabel.text = self.differenceArray.count.getPercentage(self.deliveryDayCount)
		self.highestOverLabel.text = self.differenceOverArray.max()?.convertToCurrency()
		self.differenceOverLabel.text = self.differenceOverFinal.convertToCurrency()
		self.overCountLabel.text = String(self.differenceOverArray.count)
		self.overPercentageLabel.text = self.differenceOverArray.count.getPercentage(self.differenceArray.count)
		self.highestUnderLabel.text = self.differenceUnderArray.min()?.convertToCurrency()
		self.differenceUnderLabel.text = self.differenceUnderFinal.convertToCurrency()
		self.underCountLabel.text = String(self.differenceUnderArray.count)
		self.underPercentageLabel.text = self.differenceUnderArray.count.getPercentage(self.differenceArray.count)
		let whoMadeBankCountedSet = NSCountedSet(array: self.whoMadeBankArray)
		let whoMadeBankMost = whoMadeBankCountedSet.max {
			whoMadeBankCountedSet.count(for: $0) < whoMadeBankCountedSet.count(for: $1)
		}
		let whoClosedBankCountedSet = NSCountedSet(array: self.whoClosedBankArray)
		let whoClosedBankMost = whoMadeBankCountedSet.max {
			whoClosedBankCountedSet.count(for: $0) < whoClosedBankCountedSet.count(for: $1)
		}
		if self.deliveryDays != [] {
			self.whoMadeBankTheMostCountLabel.text = "\(whoMadeBankCountedSet.count(for: whoMadeBankMost!))"
			self.whoMadeBankTheMostPercentageLabel.text = whoMadeBankCountedSet.count(for: whoMadeBankMost!).getPercentage(self.deliveryDayCount)
			self.whoMadeBankTheMostLabel.text = whoMadeBankMost as! String?
			self.whoClosedBankTheMostCountLabel.text = "\(whoClosedBankCountedSet.count(for: whoClosedBankMost!))"
			self.whoClosedBankTheMostPercentageLabel.text = whoClosedBankCountedSet.count(for: whoClosedBankMost!).getPercentage(self.deliveryDayCount)
			self.whoClosedBankTheMostLabel.text = whoClosedBankMost as! String?
			self.tableView.reloadData()
		}
		self.messageFrame.removeFromSuperview()
		//}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		activityIndicator(msg: "   Loading...", true)
		
		//DispatchQueue.main.async {
		self.loadData()
		//}
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
		let coreDataStack = UIApplication.shared.delegate as! AppDelegate
		let context = coreDataStack.persistentContainer.viewContext
		if let savedDeliveryDays = loadDeliveryDays() {
			deliveryDays = savedDeliveryDays
			for (index, _) in deliveryDays.enumerated() {
				self.deliveryDayCount += 1
				let deliveryDay = deliveryDays[index]
				let requestAllDeliveryDays = NSFetchRequest<DeliveryDayCore>(entityName: "DeliveryDayCore")
				requestAllDeliveryDays.returnsObjectsAsFaults = false
				do {
					let deliveryDays = try context.fetch(requestAllDeliveryDays)
					if deliveryDays.count > 0 {
						print("deliveryDays.count \(deliveryDays.count)")
						for deliveryDay in deliveryDays {
							print("deliveryDay \(deliveryDay)")
						}
					}
				} catch {
					let nserror = error as NSError
					fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
				}/*
				let dateFormatter = DateFormatter()
				dateFormatter.timeZone = TimeZone.current
				dateFormatter.dateFormat = "MMddyy"
				let convertedDeliveryDate = dateFormatter.date(from:deliveryDay.deliveryDateValue)
				print(deliveryDay.deliveryDateValue)
				print(convertedDeliveryDate as Any)
				let newDeliveryDay = DeliveryDayCore(context: context)
				newDeliveryDay.setValue(convertedDeliveryDate, forKey: "date")
				newDeliveryDay.setValue(Int16(deliveryDay.deliveryDayCountValue), forKey: "deliveryCount")
				newDeliveryDay.setValue(deliveryDay.totalTipsValue.removeDollarSign(), forKey: "totalTips")
				newDeliveryDay.setValue(deliveryDay.totalReceivedValue.removeDollarSign(), forKey: "totalReceived")
				newDeliveryDay.setValue(deliveryDay.whoMadeBankName, forKey: "whoMadeBank")
				newDeliveryDay.setValue(deliveryDay.whoClosedBankName, forKey: "whoClosedBank")
				newDeliveryDay.setValue(deliveryDay.manual, forKey: "manual")
				do {
					try context.save()
					print("Save Successful \(newDeliveryDay)")
				} catch {
					print("Failed to save")
					let nserror = error as NSError
					fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
				}*/
				DeliveryDayViewController.selectedDateGlobal = deliveryDay.deliveryDateValue
				whoMadeBankArray.append(deliveryDay.whoMadeBankName)
				whoClosedBankArray.append(deliveryDay.whoClosedBankName)
				
				// Total Delivery Day Tips - paidout
				totalTipsValueArray.append(deliveryDay.totalTipsValue.removeDollarSign())
				let totalTipsValueTotaled = totalTipsValueArray.reduce(0, +)
				self.totalTipsValueFinal = totalTipsValueTotaled
				
				// Total Delivery Day Received
				totalReceivedValueArray.append(deliveryDay.totalReceivedValue.removeDollarSign())
				let totalReceivedValueTotaled = totalReceivedValueArray.reduce(0, +)
				self.totalReceivedValueFinal = totalReceivedValueTotaled
				
				// Difference
				let deliveryDayDifference = Double(String(format: "%.2f", Double(deliveryDay.totalReceivedValue.removeDollarSign() - (deliveryDay.totalTipsValue.removeDollarSign() + (Double(deliveryDay.deliveryDayCountValue)! * 1.25)))))!
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
							let delivery = deliveries[index]/*
							let dateFormatter = DateFormatter()
							dateFormatter.timeZone = TimeZone.current
							dateFormatter.dateFormat = "hh:mm:ss a, MMddyy"
							var convertedDeliveryTime = dateFormatter.date(from: "12:00:00 AM, " + deliveryDay.deliveryDateValue)
							if delivery.deliveryTimeValue != "" {
							convertedDeliveryTime = dateFormatter.date(from: delivery.deliveryTimeValue + ", " + deliveryDay.deliveryDateValue)!
							}
							print(delivery.deliveryTimeValue)
							print(convertedDeliveryTime as Any)
							let newDelivery = DeliveryCore(context: context)
							newDelivery.setValue(Int16(delivery.ticketNumberValue)!, forKey: "ticketNumber")
							newDelivery.setValue(delivery.ticketAmountValue.removeDollarSign(), forKey: "ticketAmount")
							newDelivery.setValue(delivery.amountGivenValue.removeDollarSign(), forKey: "amountGiven")
							newDelivery.setValue(delivery.cashTipsValue.removeDollarSign(), forKey: "cashTips")
							newDelivery.setValue(delivery.totalTipsValue.removeDollarSign(), forKey: "totalTips")
							newDelivery.setValue(Int16(delivery.paymentMethodValue)!, forKey: "paymentMethod")
							newDelivery.setValue(Bool(delivery.noTipSwitchValue)!, forKey: "noTip")
							newDelivery.setValue(convertedDeliveryTime as NSDate?, forKey: "deliveryTime")
							if let ticketPhoto = delivery.ticketPhotoValue {
							newDelivery.setValue(UIImageJPEGRepresentation(ticketPhoto, 1.0) as NSData?, forKey: "ticketPhoto")
							}
							do {
							try context.save()
							print("Save Successful \(newDelivery)")
							} catch {
							print("Failed to save")
							let nserror = error as NSError
							fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
							}*/
							ticketAmountArray.append(delivery.ticketAmountValue.removeDollarSign())
							let ticketAmountTotaled = ticketAmountArray.reduce(0, +)
							self.ticketAmountFinal = ticketAmountTotaled
							self.tAmountArray = ticketAmountArray
							
							// Sum of amountGiven
							amountGivenArray.append(delivery.amountGivenValue.removeDollarSign())
							let amountGivenTotaled = amountGivenArray.reduce(0, +)
							self.amountGivenFinal = amountGivenTotaled
							self.aGivenArray = amountGivenArray
							
							// Sum of cashTips
							cashTipsArray.append(delivery.cashTipsValue.removeDollarSign())
							let cashTipsTotaled = cashTipsArray.reduce(0, +)
							self.cashTipsFinal = cashTipsTotaled
							self.cTipsArray = cashTipsArray
							
							// Sum of totalTips
							totalTipsArray.append(delivery.totalTipsValue.removeDollarSign())
							let totalTipsTotaled = totalTipsArray.reduce(0, +)
							self.totalTipsFinal = totalTipsTotaled
							self.tTipsArray = totalTipsArray
							
							//NoTipSwitchArray
							noTipArray.append(delivery.noTipSwitchValue)
							
							//Payment Method Sales Total
							if delivery.paymentMethodValue == "1" {
								cashSalesArray.append(delivery.ticketAmountValue.removeDollarSign())
								let cashSalesTotaled = cashSalesArray.reduce(0, +)
								self.cashSalesFinal = cashSalesTotaled
							} else if delivery.paymentMethodValue == "2" {
								checkSalesArray.append(delivery.ticketAmountValue.removeDollarSign())
								let checkSalesTotaled = checkSalesArray.reduce(0, +)
								self.checkSalesFinal = checkSalesTotaled
							} else if delivery.paymentMethodValue == "3" {
								creditSalesArray.append(delivery.ticketAmountValue.removeDollarSign())
								let creditSalesTotaled = creditSalesArray.reduce(0, +)
								self.creditSalesFinal = creditSalesTotaled
							} else if delivery.paymentMethodValue == "4" {
								chargeSalesArray.append(delivery.ticketAmountValue.removeDollarSign())
								let chargeSalesTotaled = chargeSalesArray.reduce(0, +)
								self.chargeSalesFinal = chargeSalesTotaled
								chargeGivenArray.append(delivery.amountGivenValue.removeDollarSign())
								let chargeGivenTotaled = chargeGivenArray.reduce(0, +)
								self.chargeGivenFinal = chargeGivenTotaled
							} else if delivery.paymentMethodValue == "5" {
								otherSalesArray.append(delivery.ticketAmountValue.removeDollarSign())
								let otherSalesTotaled = otherSalesArray.reduce(0, +)
								self.otherSalesFinal = otherSalesTotaled
							}
							if delivery.noTipSwitchValue == "true" {
								noTipSalesArray.append(delivery.ticketAmountValue.removeDollarSign())
								let noTipSalesTotaled = noTipSalesArray.reduce(0, +)
								self.noTipSalesFinal = noTipSalesTotaled
							}
						}
					}
				}
			}
			differenceArray.append(contentsOf: differenceOverArray)
			differenceArray.append(contentsOf: differenceUnderArray)
			let differenceTotaled = differenceArray.reduce(0, +)
			self.differenceFinal = differenceTotaled
			let requestAllDeliveries = NSFetchRequest<DeliveryCore>(entityName: "DeliveryCore")
			requestAllDeliveries.returnsObjectsAsFaults = false
			do {
				coreDeliveries.removeAll()
				let deliveries = try context.fetch(requestAllDeliveries)
				if deliveries.count > 0 {
					print("deliveries.count \(deliveries.count)")
					for delivery in deliveries {
						print("delivery \(delivery)")
						let dateFormatter = DateFormatter()
						dateFormatter.dateFormat = "hh:mm:ss a"
						dateFormatter.timeZone = TimeZone.current
						var ticketPhoto: UIImage?
						var deliveryTime: String
						if delivery.ticketPhoto != nil {
							ticketPhoto = UIImage(data: delivery.ticketPhoto as! Data)
						} else {
							ticketPhoto = nil
						}
						if delivery.deliveryTime != nil {
							deliveryTime = dateFormatter.string(from: delivery.deliveryTime as! Date)
						} else {
							deliveryTime = ""
						}
						let convertDelivery = Delivery(ticketNumberValue: "\(delivery.ticketNumber)", ticketAmountValue: delivery.ticketAmount.convertToCurrency(), noTipSwitchValue: "\(delivery.noTip)", amountGivenValue: delivery.amountGiven.convertToCurrency(), cashTipsValue: delivery.cashTips.convertToCurrency(), totalTipsValue: delivery.totalTips.convertToCurrency(), paymentMethodValue: "\(delivery.paymentMethod)", deliveryTimeValue: deliveryTime, ticketPhotoValue: ticketPhoto)
						self.coreDeliveries.append(convertDelivery!)
					}
				}
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
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
	
	// MARK: NSCoding
	
	func loadDeliveryDays() -> [DeliveryDay]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: DeliveryDay.ArchiveURL.path) as? [DeliveryDay]
	}
	func loadDeliveries() -> [Delivery]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Delivery.ArchiveURL.path) as? [Delivery]
	}
}
