//
//  DeliveryDayStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/22/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryDayStatisticsTableViewController : UITableViewController {
	
	// MARK: StoryBoard Outlets
	
	@IBOutlet var deliveryDaysCountLabel: UILabel!
	@IBOutlet var deliveriesCountLabel: UILabel!
	@IBOutlet var totalTipsLabel: UILabel!
	//@IBOutlet var totalTipsAverageLabel: UILabel!
//    @IBOutlet var totalTipsMaxLabel: UILabel!
//    @IBOutlet var totalTipsMinLabel: UILabel!
//    @IBOutlet var dropLabel: UILabel!
//    @IBOutlet var dropAverageLabel: UILabel!
//    @IBOutlet var dropMaxLabel: UILabel!
//    @IBOutlet var dropMinLabel: UILabel!
	@IBOutlet var paidoutLabel: UILabel!
	@IBOutlet var noTipSalesLabel: UILabel!
	//@IBOutlet var noTipSalesPercentageLabel: UILabel!
	@IBOutlet var noTipCountLabel: UILabel!
//    @IBOutlet var noTipDeliveryPercentageLabel: UILabel!
//    @IBOutlet var noTipSalesAverageLabel: UILabel!
//    @IBOutlet var noTipSalesMaxLabel: UILabel!
//    @IBOutlet var noTipSalesMinLabel: UILabel!
    @IBOutlet var totalReceivedLabel: UILabel!
	@IBOutlet var totalReceivedAverageLabel: UILabel!
	@IBOutlet var totalReceivedMaxLabel: UILabel!
	@IBOutlet var totalReceivedMinLabel: UILabel!
	@IBOutlet var totalSalesBLabel: UILabel!
//    @IBOutlet var ticketAmountLabel: UILabel!
//    @IBOutlet var ticketAmountAverageLabel: UILabel!
//    @IBOutlet var ticketAmountMaxLabel: UILabel!
//    @IBOutlet var ticketAmountMinLabel: UILabel!
	@IBOutlet var cashSalesLabel: UILabel!
	@IBOutlet var cashSalesPercentageLabel: UILabel!
	@IBOutlet var cashCountLabel: UILabel!
	@IBOutlet var cashDeliveryPercentageLabel: UILabel!
//    @IBOutlet var cashSalesAverageLabel: UILabel!
//    @IBOutlet var cashSalesMaxLabel: UILabel!
//    @IBOutlet var cashSalesMinLabel: UILabel!
	@IBOutlet var checkSalesLabel: UILabel!
	@IBOutlet var checkSalesPercentageLabel: UILabel!
	@IBOutlet var checkCountLabel: UILabel!
	@IBOutlet var checkDeliveryPercentageLabel: UILabel!
//    @IBOutlet var checkSalesAverageLabel: UILabel!
//    @IBOutlet var checkSalesMaxLabel: UILabel!
//    @IBOutlet var checkSalesMinLabel: UILabel!
	@IBOutlet var creditSalesLabel: UILabel!
	@IBOutlet var creditSalesPercentageLabel: UILabel!
	@IBOutlet var creditCountLabel: UILabel!
	@IBOutlet var creditDeliveryPercentageLabel: UILabel!
//    @IBOutlet var creditSalesAverageLabel: UILabel!
//    @IBOutlet var creditSalesMaxLabel: UILabel!
//    @IBOutlet var creditSalesMinLabel: UILabel!
	@IBOutlet var chargeSalesLabel: UILabel!
	@IBOutlet var chargeSalesPercentageLabel: UILabel!
	@IBOutlet var chargeCountLabel: UILabel!
	@IBOutlet var chargeDeliveryPercentageLabel: UILabel!
//    @IBOutlet var chargeSalesAverageLabel: UILabel!
//    @IBOutlet var chargeSalesMaxLabel: UILabel!
//    @IBOutlet var chargeSalesMinLabel: UILabel!
	@IBOutlet var otherSalesLabel: UILabel!
	@IBOutlet var otherSalesPercentageLabel: UILabel!
	@IBOutlet var otherCountLabel: UILabel!
	@IBOutlet var otherDeliveryPercentageLabel: UILabel!
//    @IBOutlet var otherSalesAverageLabel: UILabel!
//    @IBOutlet var otherSalesMaxLabel: UILabel!
//    @IBOutlet var otherSalesMinLabel: UILabel!
//    @IBOutlet var noneSalesLabel: UILabel!
//    @IBOutlet var noneSalesPercentageLabel: UILabel!
//    @IBOutlet var noneCountLabel: UILabel!
//    @IBOutlet var noneDeliveryPercentageLabel: UILabel!
//    @IBOutlet var noneSalesAverageLabel: UILabel!
//    @IBOutlet var noneSalesMaxLabel: UILabel!
//    @IBOutlet var noneSalesMinLabel: UILabel!
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
	var manualDeliveryDays = [DeliveryDay]()
	var deliveries = [Delivery]()
	var drops = [Drop]()
	var deliveryDaysCount = "0"
	var deliveriesCount = "0"
	var totalTips = "$0.00"
	var totalTipsAverage = "$0.00"
	var totalTipsMax = "$0.00"
	var totalTipsMin = "$0.00"
	var drop = "$0.00"
	var dropAverage = "$0.00"
	var dropMax = "$0.00"
	var dropMin = "$0.00"
	var paidout = "$0.00"
	var noTipCount = "0"
	var noTipSalesPercentage = "0%"
	var noTipDeliveryPercentage = "0%"
	var noTipSales = "$0.00"
	var noTipSalesAverage = "$0.00"
	var noTipSalesMax = "$0.00"
	var noTipSalesMin = "$0.00"
	var totalReceived = "$0.00"
	var totalReceivedAverage = "$0.00"
	var totalReceivedMax = "$0.00"
	var totalReceivedMin = "$0.00"
	var ticketAmount = "$0.00"
	var ticketAmountAverage = "$0.00"
	var ticketAmountMax = "$0.00"
	var ticketAmountMin = "$0.00"
	var cashCount = "0"
	var cashSalesPercentage = "0%"
	var cashDeliveryPercentage = "0%"
	var cashSales = "$0.00"
	var cashSalesAverage = "$0.00"
	var cashSalesMax = "$0.00"
	var cashSalesMin = "$0.00"
	var checkCount = "0"
	var checkSalesPercentage = "0%"
	var checkDeliveryPercentage = "0%"
	var checkSales = "$0.00"
	var checkSalesAverage = "$0.00"
	var checkSalesMax = "$0.00"
	var checkSalesMin = "$0.00"
	var creditCount = "0"
	var creditSalesPercentage = "0%"
	var creditDeliveryPercentage = "0%"
	var creditSales = "$0.00"
	var creditSalesAverage = "$0.00"
	var creditSalesMax = "$0.00"
	var creditSalesMin = "$0.00"
	var chargeCount = "0"
	var chargeSalesPercentage = "0%"
	var chargeDeliveryPercentage = "0%"
	var chargeSales = "$0.00"
	var chargeSalesAverage = "$0.00"
	var chargeSalesMax = "$0.00"
	var chargeSalesMin = "$0.00"
	var otherCount = "0"
	var otherSalesPercentage = "0%"
	var otherDeliveryPercentage = "0%"
	var otherSales = "$0.00"
	var otherSalesAverage = "$0.00"
	var otherSalesMax = "$0.00"
	var otherSalesMin = "$0.00"
	var noneCount = "0"
	var noneSalesPercentage = "0%"
	var noneDeliveryPercentage = "0%"
	var noneSales = "$0.00"
	var noneSalesAverage = "$0.00"
	var noneSalesMax = "$0.00"
	var noneSalesMin = "$0.00"
	var difference = "$0.00"
	var offCount = "0"
	var offPercentage = "0%"
	var highestOver = "$0.00"
	var differenceOver = "$0.00"
	var overCount = "0"
	var overPercentage = "0%"
	var highestUnder = "$0.00"
	var differenceUnder = "$0.00"
	var underCount = "0"
	var underPercentage = "0%"
	var whoMadeBankTheMostCount = "0"
	var whoMadeBankTheMostPercentage = "0%"
	var whoMadeBankTheMost = "None"
	var whoMadeBankArray: [String] = []
	var whoClosedBankTheMostCount = "0"
	var whoClosedBankTheMostPercentage = "0%"
	var whoClosedBankTheMost = "None"
	var whoClosedBankArray: [String] = []
	var totalReceivedDictionaryFinal: [NSDictionary]?
	var ticketAmountDictionaryFinal: [NSDictionary]?
	var amountGivenDictionaryFinal: [NSDictionary]?
	var cashTipsDictionaryFinal: [NSDictionary]?
	var totalTipsDictionaryFinal: [NSDictionary]?
	var dropDictionaryFinal: [NSDictionary]?
	var noneSalesDictionaryFinal: [NSDictionary]?
	var cashSalesDictionaryFinal: [NSDictionary]?
	var checkSalesDictionaryFinal: [NSDictionary]?
	var creditSalesDictionaryFinal: [NSDictionary]?
	var chargeSalesDictionaryFinal: [NSDictionary]?
	var chargeGivenDictionaryFinal: [NSDictionary]?
	var otherSalesDictionaryFinal: [NSDictionary]?
	var noTipSalesDictionaryFinal: [NSDictionary]?
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	var mainContext: NSManagedObjectContext? = nil
	
	// MARK: View Life Cycle
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.tabBarController?.tabBar.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.main.async {
			self.deliveryDaysCountLabel.text = self.deliveryDaysCount
			self.deliveriesCountLabel.text = self.deliveriesCount
			self.totalTipsLabel.text = self.totalTips
//            self.totalTipsAverageLabel.text = self.totalTipsAverage
//            self.totalTipsMaxLabel.text = self.totalTipsMax
//            self.totalTipsMinLabel.text = self.totalTipsMin
//            self.dropLabel.text = self.drop
//            self.dropAverageLabel.text = self.dropAverage
//            self.dropMaxLabel.text = self.dropMax
//            self.dropMinLabel.text = self.dropMin
			self.paidoutLabel.text = self.paidout
			self.noTipCountLabel.text = self.noTipCount
//            self.noTipSalesPercentageLabel.text = self.noTipSalesPercentage
//            self.noTipDeliveryPercentageLabel.text = self.noTipDeliveryPercentage
			self.noTipSalesLabel.text = self.noTipSales
//            self.noTipSalesAverageLabel.text = self.noTipSalesAverage
//            self.noTipSalesMaxLabel.text = self.noTipSalesMax
//            self.noTipSalesMinLabel.text = self.noTipSalesMin
			self.totalReceivedLabel.text = self.totalReceived
			self.totalReceivedAverageLabel.text = self.totalReceivedAverage
			self.totalReceivedMaxLabel.text = self.totalReceivedMax
			self.totalReceivedMinLabel.text = self.totalReceivedMin
			self.totalSalesBLabel.text = self.ticketAmount
//            self.ticketAmountLabel.text = self.ticketAmount
//            self.ticketAmountAverageLabel.text = self.ticketAmountAverage
//            self.ticketAmountMaxLabel.text = self.ticketAmountMax
//            self.ticketAmountMinLabel.text = self.ticketAmountMin
			self.cashCountLabel.text = self.cashCount
			self.cashSalesPercentageLabel.text = self.cashSalesPercentage
			self.cashDeliveryPercentageLabel.text = self.cashDeliveryPercentage
			self.cashSalesLabel.text = self.cashSales
//            self.cashSalesAverageLabel.text = self.cashSalesAverage
//            self.cashSalesMaxLabel.text = self.cashSalesMax
//            self.cashSalesMinLabel.text = self.cashSalesMin
			self.checkCountLabel.text = self.checkCount
			self.checkSalesPercentageLabel.text = self.checkSalesPercentage
			self.checkDeliveryPercentageLabel.text = self.checkDeliveryPercentage
			self.checkSalesLabel.text = self.checkSales
//            self.checkSalesAverageLabel.text = self.checkSalesAverage
//            self.checkSalesMaxLabel.text = self.checkSalesMax
//            self.checkSalesMinLabel.text = self.checkSalesMin
			self.creditCountLabel.text = self.creditCount
			self.creditSalesPercentageLabel.text = self.creditSalesPercentage
			self.creditDeliveryPercentageLabel.text = self.creditDeliveryPercentage
			self.creditSalesLabel.text = self.creditSales
//            self.creditSalesAverageLabel.text = self.creditSalesAverage
//            self.creditSalesMaxLabel.text = self.creditSalesMax
//            self.creditSalesMinLabel.text = self.creditSalesMin
			self.chargeCountLabel.text = self.chargeCount
			self.chargeSalesPercentageLabel.text = self.chargeSalesPercentage
			self.chargeDeliveryPercentageLabel.text = self.chargeDeliveryPercentage
			self.chargeSalesLabel.text = self.chargeSales
//            self.chargeSalesAverageLabel.text = self.chargeSalesAverage
//            self.chargeSalesMaxLabel.text = self.chargeSalesMax
//            self.chargeSalesMinLabel.text = self.chargeSalesMin
			self.otherCountLabel.text = self.otherCount
			self.otherSalesPercentageLabel.text = self.otherSalesPercentage
			self.otherDeliveryPercentageLabel.text = self.otherDeliveryPercentage
			self.otherSalesLabel.text = self.otherSales
//            self.otherSalesAverageLabel.text = self.otherSalesAverage
//            self.otherSalesMaxLabel.text = self.otherSalesMax
//            self.otherSalesMinLabel.text = self.otherSalesMin
//            self.noneCountLabel.text = self.noneCount
//            self.noneSalesPercentageLabel.text = self.noneSalesPercentage
//            self.noneDeliveryPercentageLabel.text = self.noneDeliveryPercentage
//            self.noneSalesLabel.text = self.noneSales
//            self.noneSalesAverageLabel.text = self.noneSalesAverage
//            self.noneSalesMaxLabel.text = self.noneSalesMax
//            self.noneSalesMinLabel.text = self.noneSalesMin
			self.differenceLabel.text = self.difference
			self.offCountLabel.text = self.offCount
			self.offPercentageLabel.text = self.offPercentage
			self.highestOverLabel.text = self.highestOver
			self.differenceOverLabel.text = self.differenceOver
			self.overCountLabel.text = self.overCount
			self.overPercentageLabel.text = self.overPercentage
			self.highestUnderLabel.text = self.highestUnder
			self.differenceUnderLabel.text = self.differenceUnder
			self.underCountLabel.text = self.underCount
			self.underPercentageLabel.text = self.underPercentage
			if self.deliveryDaysCount != "0" {/*
				let whoMadeBankCountedSet = NSCountedSet(array: self.whoMadeBankArray)
				let whoMadeBankMost = whoMadeBankCountedSet.max {
				whoMadeBankCountedSet.count(for: $0) < whoMadeBankCountedSet.count(for: $1)
				}
				self.whoMadeBankTheMost = whoMadeBankMost as! String
				let whoClosedBankCountedSet = NSCountedSet(array: self.whoClosedBankArray)
				let whoClosedBankMost = whoClosedBankCountedSet.max {
				whoClosedBankCountedSet.count(for: $0) < whoClosedBankCountedSet.count(for: $1)
				}
				self.whoClosedBankTheMost = whoClosedBankMost as! String
				self.whoMadeBankTheMostCountLabel.text = "\(whoMadeBankCountedSet.count(for: whoMadeBankMost!))"
				self.whoMadeBankTheMostPercentageLabel.text = whoMadeBankCountedSet.count(for: whoMadeBankMost!).getPercentage(Int(self.deliveryDaysCount)!)
				self.whoClosedBankTheMostCountLabel.text = "\(whoClosedBankCountedSet.count(for: whoClosedBankMost!))"
				self.whoClosedBankTheMostPercentageLabel.text = whoClosedBankCountedSet.count(for: whoClosedBankMost!).getPercentage(Int(self.deliveryDaysCount)!)*/
				self.tableView.reloadData()
			}
			/*self.whoMadeBankTheMostCountLabel.text = self.whoMadeBankTheMostCount
			self.whoMadeBankTheMostPercentageLabel.text = self.whoMadeBankTheMostPercentage
			self.whoMadeBankTheMostLabel.text = self.whoMadeBankTheMost
			self.whoClosedBankTheMostCountLabel.text = self.whoClosedBankTheMostCount
			self.whoClosedBankTheMostPercentageLabel.text = self.whoClosedBankTheMostPercentage
			self.whoClosedBankTheMostLabel.text = self.whoClosedBankTheMost*/
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
	
	// MARK: Table View
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
	{
		let title = UILabel()
		title.textColor = UIColor.white
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = title.textColor
	}
	func loadData() {
		guard let context = mainContext else {
			return
		}
		
		let totalReceivedRequest = NSFetchRequest<NSDictionary>(entityName: "DeliveryDay")
		let totalReceived = NSExpressionDescription()
		let totalReceivedMax = NSExpressionDescription()
		let totalReceivedMin = NSExpressionDescription()
		let totalReceivedAvg = NSExpressionDescription()
		let totalReceivedExpression = NSExpression(forKeyPath: #keyPath(DeliveryDay.totalReceived))
		totalReceived.name = "totalReceived"
		totalReceived.expression = NSExpression(forFunction: "sum:", arguments: [totalReceivedExpression])
		totalReceived.expressionResultType = .doubleAttributeType
		totalReceivedMax.name = "totalReceivedMax"
		totalReceivedMax.expression = NSExpression(forFunction: "max:", arguments: [totalReceivedExpression])
		totalReceivedMax.expressionResultType = .doubleAttributeType
		totalReceivedMin.name = "totalReceivedMin"
		totalReceivedMin.expression = NSExpression(forFunction: "min:", arguments: [totalReceivedExpression])
		totalReceivedMin.expressionResultType = .doubleAttributeType
		totalReceivedAvg.name = "totalReceivedAvg"
		totalReceivedAvg.expression = NSExpression(forFunction: "average:", arguments: [totalReceivedExpression])
		totalReceivedAvg.expressionResultType = .doubleAttributeType
		totalReceivedRequest.resultType = .dictionaryResultType
		totalReceivedRequest.propertiesToFetch = [totalReceived, totalReceivedMax, totalReceivedMin, totalReceivedAvg]
		
		let otherPaymentMethodRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let otherPaymentMethodPredicate = NSPredicate(format: "paymentMethod == %@", "5")
		let otherPaymentMethodSales = NSExpressionDescription()
		let otherPaymentMethodSalesMax = NSExpressionDescription()
		let otherPaymentMethodSalesMin = NSExpressionDescription()
		let otherPaymentMethodSalesAvg = NSExpressionDescription()
		let otherPaymentMethodExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		otherPaymentMethodSales.name = "otherPaymentMethodSales"
		otherPaymentMethodSales.expression = NSExpression(forFunction: "sum:", arguments: [otherPaymentMethodExpression])
		otherPaymentMethodSales.expressionResultType = .doubleAttributeType
		otherPaymentMethodSalesMax.name = "otherPaymentMethodSalesMax"
		otherPaymentMethodSalesMax.expression = NSExpression(forFunction: "max:", arguments: [otherPaymentMethodExpression])
		otherPaymentMethodSalesMax.expressionResultType = .doubleAttributeType
		otherPaymentMethodSalesMin.name = "otherPaymentMethodSalesMin"
		otherPaymentMethodSalesMin.expression = NSExpression(forFunction: "min:", arguments: [otherPaymentMethodExpression])
		otherPaymentMethodSalesMin.expressionResultType = .doubleAttributeType
		otherPaymentMethodSalesAvg.name = "otherPaymentMethodSalesAvg"
		otherPaymentMethodSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [otherPaymentMethodExpression])
		otherPaymentMethodSalesAvg.expressionResultType = .doubleAttributeType
		otherPaymentMethodRequest.resultType = .dictionaryResultType
		otherPaymentMethodRequest.predicate = otherPaymentMethodPredicate
		otherPaymentMethodRequest.propertiesToFetch = [otherPaymentMethodSales, otherPaymentMethodSalesMax, otherPaymentMethodSalesMin, otherPaymentMethodSalesAvg]
		
		let allDeliveryDaysRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let allDeliveryDaysSales = NSExpressionDescription()
		let allDeliveryDaysSalesMax = NSExpressionDescription()
		let allDeliveryDaysSalesMin = NSExpressionDescription()
		let allDeliveryDaysSalesAvg = NSExpressionDescription()
		let allDeliveryDaysExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		allDeliveryDaysSales.name = "allDeliveryDaysSales"
		allDeliveryDaysSales.expression = NSExpression(forFunction: "sum:", arguments: [allDeliveryDaysExpression])
		allDeliveryDaysSales.expressionResultType = .doubleAttributeType
		allDeliveryDaysSalesMax.name = "allDeliveryDaysSalesMax"
		allDeliveryDaysSalesMax.expression = NSExpression(forFunction: "max:", arguments: [allDeliveryDaysExpression])
		allDeliveryDaysSalesMax.expressionResultType = .doubleAttributeType
		allDeliveryDaysSalesMin.name = "allDeliveryDaysSalesMin"
		allDeliveryDaysSalesMin.expression = NSExpression(forFunction: "min:", arguments: [allDeliveryDaysExpression])
		allDeliveryDaysSalesMin.expressionResultType = .doubleAttributeType
		allDeliveryDaysSalesAvg.name = "allDeliveryDaysSalesAvg"
		allDeliveryDaysSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [allDeliveryDaysExpression])
		allDeliveryDaysSalesAvg.expressionResultType = .doubleAttributeType
		
		
		allDeliveryDaysRequest.resultType = .dictionaryResultType
		allDeliveryDaysRequest.propertiesToFetch = [allDeliveryDaysSales, allDeliveryDaysSalesMax, allDeliveryDaysSalesMin, allDeliveryDaysSalesAvg]
		
		let cashPaymentMethodRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let cashPaymentMethodPredicate = NSPredicate(format: "paymentMethod == %@", "1")
		let cashPaymentMethodSales = NSExpressionDescription()
		let cashPaymentMethodSalesMax = NSExpressionDescription()
		let cashPaymentMethodSalesMin = NSExpressionDescription()
		let cashPaymentMethodSalesAvg = NSExpressionDescription()
		let cashPaymentMethodExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		cashPaymentMethodSales.name = "cashPaymentMethodSales"
		cashPaymentMethodSales.expression = NSExpression(forFunction: "sum:", arguments: [cashPaymentMethodExpression])
		cashPaymentMethodSales.expressionResultType = .doubleAttributeType
		cashPaymentMethodSalesMax.name = "cashPaymentMethodSalesMax"
		cashPaymentMethodSalesMax.expression = NSExpression(forFunction: "max:", arguments: [cashPaymentMethodExpression])
		cashPaymentMethodSalesMax.expressionResultType = .doubleAttributeType
		cashPaymentMethodSalesMin.name = "cashPaymentMethodSalesMin"
		cashPaymentMethodSalesMin.expression = NSExpression(forFunction: "min:", arguments: [cashPaymentMethodExpression])
		cashPaymentMethodSalesMin.expressionResultType = .doubleAttributeType
		cashPaymentMethodSalesAvg.name = "cashPaymentMethodSalesAvg"
		cashPaymentMethodSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [cashPaymentMethodExpression])
		cashPaymentMethodSalesAvg.expressionResultType = .doubleAttributeType
		
		
		cashPaymentMethodRequest.resultType = .dictionaryResultType
		cashPaymentMethodRequest.predicate = cashPaymentMethodPredicate
		cashPaymentMethodRequest.propertiesToFetch = [cashPaymentMethodSales, cashPaymentMethodSalesMax, cashPaymentMethodSalesMin, cashPaymentMethodSalesAvg]
		
		let cashTipsRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let cashTipsSales = NSExpressionDescription()
		let cashTipsSalesMax = NSExpressionDescription()
		let cashTipsSalesMin = NSExpressionDescription()
		let cashTipsSalesAvg = NSExpressionDescription()
		let cashTipsExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		cashTipsSales.name = "cashTipsSales"
		cashTipsSales.expression = NSExpression(forFunction: "sum:", arguments: [cashTipsExpression])
		cashTipsSales.expressionResultType = .doubleAttributeType
		cashTipsSalesMax.name = "cashTipsSalesMax"
		cashTipsSalesMax.expression = NSExpression(forFunction: "max:", arguments: [cashTipsExpression])
		cashTipsSalesMax.expressionResultType = .doubleAttributeType
		cashTipsSalesMin.name = "cashTipsSalesMin"
		cashTipsSalesMin.expression = NSExpression(forFunction: "min:", arguments: [cashTipsExpression])
		cashTipsSalesMin.expressionResultType = .doubleAttributeType
		cashTipsSalesAvg.name = "cashTipsSalesAvg"
		cashTipsSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [cashTipsExpression])
		cashTipsSalesAvg.expressionResultType = .doubleAttributeType
		cashTipsRequest.resultType = .dictionaryResultType
		cashTipsRequest.propertiesToFetch = [cashTipsSales, cashTipsSalesMax, cashTipsSalesMin, cashTipsSalesAvg]
		
		let chargePaymentMethodRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let chargePaymentMethodPredicate = NSPredicate(format: "paymentMethod == %@", "4")
		let chargePaymentMethodSales = NSExpressionDescription()
		let chargePaymentMethodSalesMax = NSExpressionDescription()
		let chargePaymentMethodSalesMin = NSExpressionDescription()
		let chargePaymentMethodSalesAvg = NSExpressionDescription()
		let chargePaymentMethodExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		chargePaymentMethodSales.name = "chargePaymentMethodSales"
		chargePaymentMethodSales.expression = NSExpression(forFunction: "sum:", arguments: [chargePaymentMethodExpression])
		chargePaymentMethodSales.expressionResultType = .doubleAttributeType
		chargePaymentMethodSalesMax.name = "chargePaymentMethodSalesMax"
		chargePaymentMethodSalesMax.expression = NSExpression(forFunction: "max:", arguments: [chargePaymentMethodExpression])
		chargePaymentMethodSalesMax.expressionResultType = .doubleAttributeType
		chargePaymentMethodSalesMin.name = "chargePaymentMethodSalesMin"
		chargePaymentMethodSalesMin.expression = NSExpression(forFunction: "min:", arguments: [chargePaymentMethodExpression])
		chargePaymentMethodSalesMin.expressionResultType = .doubleAttributeType
		chargePaymentMethodSalesAvg.name = "chargePaymentMethodSalesAvg"
		chargePaymentMethodSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [chargePaymentMethodExpression])
		chargePaymentMethodSalesAvg.expressionResultType = .doubleAttributeType
		chargePaymentMethodRequest.resultType = .dictionaryResultType
		chargePaymentMethodRequest.predicate = chargePaymentMethodPredicate
		chargePaymentMethodRequest.propertiesToFetch = [chargePaymentMethodSales, chargePaymentMethodSalesMax, chargePaymentMethodSalesMin, chargePaymentMethodSalesAvg]
		
		let checkPaymentMethodRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let checkPaymentMethodPredicate = NSPredicate(format: "paymentMethod == %@", "2")
		let checkPaymentMethodSales = NSExpressionDescription()
		let checkPaymentMethodSalesMax = NSExpressionDescription()
		let checkPaymentMethodSalesMin = NSExpressionDescription()
		let checkPaymentMethodSalesAvg = NSExpressionDescription()
		let checkPaymentMethodExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		checkPaymentMethodSales.name = "checkPaymentMethodSales"
		checkPaymentMethodSales.expression = NSExpression(forFunction: "sum:", arguments: [checkPaymentMethodExpression])
		checkPaymentMethodSales.expressionResultType = .doubleAttributeType
		checkPaymentMethodSalesMax.name = "checkPaymentMethodSalesMax"
		checkPaymentMethodSalesMax.expression = NSExpression(forFunction: "max:", arguments: [checkPaymentMethodExpression])
		checkPaymentMethodSalesMax.expressionResultType = .doubleAttributeType
		checkPaymentMethodSalesMin.name = "checkPaymentMethodSalesMin"
		checkPaymentMethodSalesMin.expression = NSExpression(forFunction: "min:", arguments: [checkPaymentMethodExpression])
		checkPaymentMethodSalesMin.expressionResultType = .doubleAttributeType
		checkPaymentMethodSalesAvg.name = "checkPaymentMethodSalesAvg"
		checkPaymentMethodSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [checkPaymentMethodExpression])
		checkPaymentMethodSalesAvg.expressionResultType = .doubleAttributeType
		checkPaymentMethodRequest.resultType = .dictionaryResultType
		checkPaymentMethodRequest.predicate = checkPaymentMethodPredicate
		checkPaymentMethodRequest.propertiesToFetch = [checkPaymentMethodSales, checkPaymentMethodSalesMax, checkPaymentMethodSalesMin, checkPaymentMethodSalesAvg]
		
		let creditPaymentMethodRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let creditPaymentMethodPredicate = NSPredicate(format: "paymentMethod == %@", "3")
		let creditPaymentMethodSales = NSExpressionDescription()
		let creditPaymentMethodSalesMax = NSExpressionDescription()
		let creditPaymentMethodSalesMin = NSExpressionDescription()
		let creditPaymentMethodSalesAvg = NSExpressionDescription()
		let creditPaymentMethodExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		creditPaymentMethodSales.name = "creditPaymentMethodSales"
		creditPaymentMethodSales.expression = NSExpression(forFunction: "sum:", arguments: [creditPaymentMethodExpression])
		creditPaymentMethodSales.expressionResultType = .doubleAttributeType
		creditPaymentMethodSalesMax.name = "creditPaymentMethodSalesMax"
		creditPaymentMethodSalesMax.expression = NSExpression(forFunction: "max:", arguments: [creditPaymentMethodExpression])
		creditPaymentMethodSalesMax.expressionResultType = .doubleAttributeType
		creditPaymentMethodSalesMin.name = "creditPaymentMethodSalesMin"
		creditPaymentMethodSalesMin.expression = NSExpression(forFunction: "min:", arguments: [creditPaymentMethodExpression])
		creditPaymentMethodSalesMin.expressionResultType = .doubleAttributeType
		creditPaymentMethodSalesAvg.name = "creditPaymentMethodSalesAvg"
		creditPaymentMethodSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [creditPaymentMethodExpression])
		creditPaymentMethodSalesAvg.expressionResultType = .doubleAttributeType
		creditPaymentMethodRequest.resultType = .dictionaryResultType
		creditPaymentMethodRequest.predicate = creditPaymentMethodPredicate
		creditPaymentMethodRequest.propertiesToFetch = [creditPaymentMethodSales, creditPaymentMethodSalesMax, creditPaymentMethodSalesMin, creditPaymentMethodSalesAvg]
		
		let manualDeliveryDaysRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let manualDeliveryDaysSales = NSExpressionDescription()
		let manualDeliveryDaysSalesMax = NSExpressionDescription()
		let manualDeliveryDaysSalesMin = NSExpressionDescription()
		let manualDeliveryDaysSalesAvg = NSExpressionDescription()
		let manualDeliveryDaysExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		manualDeliveryDaysSales.name = "manualDeliveryDaysSales"
		manualDeliveryDaysSales.expression = NSExpression(forFunction: "sum:", arguments: [manualDeliveryDaysExpression])
		manualDeliveryDaysSales.expressionResultType = .doubleAttributeType
		manualDeliveryDaysSalesMax.name = "manualDeliveryDaysSalesMax"
		manualDeliveryDaysSalesMax.expression = NSExpression(forFunction: "max:", arguments: [manualDeliveryDaysExpression])
		manualDeliveryDaysSalesMax.expressionResultType = .doubleAttributeType
		manualDeliveryDaysSalesMin.name = "manualDeliveryDaysSalesMin"
		manualDeliveryDaysSalesMin.expression = NSExpression(forFunction: "min:", arguments: [manualDeliveryDaysExpression])
		manualDeliveryDaysSalesMin.expressionResultType = .doubleAttributeType
		manualDeliveryDaysSalesAvg.name = "manualDeliveryDaysSalesAvg"
		manualDeliveryDaysSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [manualDeliveryDaysExpression])
		manualDeliveryDaysSalesAvg.expressionResultType = .doubleAttributeType
		manualDeliveryDaysRequest.resultType = .dictionaryResultType
		manualDeliveryDaysRequest.propertiesToFetch = [manualDeliveryDaysSales, manualDeliveryDaysSalesMax, manualDeliveryDaysSalesMin, manualDeliveryDaysSalesAvg]
		
		let nonePaymentMethodRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let nonePaymentMethodPredicate = NSPredicate(format: "paymentMethod == %@", "0")
		let nonePaymentMethodSales = NSExpressionDescription()
		let nonePaymentMethodSalesMax = NSExpressionDescription()
		let nonePaymentMethodSalesMin = NSExpressionDescription()
		let nonePaymentMethodSalesAvg = NSExpressionDescription()
		let nonePaymentMethodExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		nonePaymentMethodSales.name = "nonePaymentMethodSales"
		nonePaymentMethodSales.expression = NSExpression(forFunction: "sum:", arguments: [nonePaymentMethodExpression])
		nonePaymentMethodSales.expressionResultType = .doubleAttributeType
		nonePaymentMethodSalesMax.name = "nonePaymentMethodSalesMax"
		nonePaymentMethodSalesMax.expression = NSExpression(forFunction: "max:", arguments: [nonePaymentMethodExpression])
		nonePaymentMethodSalesMax.expressionResultType = .doubleAttributeType
		nonePaymentMethodSalesMin.name = "nonePaymentMethodSalesMin"
		nonePaymentMethodSalesMin.expression = NSExpression(forFunction: "min:", arguments: [nonePaymentMethodExpression])
		nonePaymentMethodSalesMin.expressionResultType = .doubleAttributeType
		nonePaymentMethodSalesAvg.name = "nonePaymentMethodSalesAvg"
		nonePaymentMethodSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [nonePaymentMethodExpression])
		nonePaymentMethodSalesAvg.expressionResultType = .doubleAttributeType
		nonePaymentMethodRequest.resultType = .dictionaryResultType
		nonePaymentMethodRequest.predicate = nonePaymentMethodPredicate
		nonePaymentMethodRequest.propertiesToFetch = [nonePaymentMethodSales, nonePaymentMethodSalesMax, nonePaymentMethodSalesMin, nonePaymentMethodSalesAvg]
		
		let noTipDeliveriesRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let noTipDeliveriesPredicate = NSPredicate(format: "noTip == %@", "1")
		let noTipDeliveriesSales = NSExpressionDescription()
		let noTipDeliveriesSalesMax = NSExpressionDescription()
		let noTipDeliveriesSalesMin = NSExpressionDescription()
		let noTipDeliveriesSalesAvg = NSExpressionDescription()
		let noTipDeliveriesExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		noTipDeliveriesSales.name = "noTipDeliveriesSales"
		noTipDeliveriesSales.expression = NSExpression(forFunction: "sum:", arguments: [noTipDeliveriesExpression])
		noTipDeliveriesSales.expressionResultType = .doubleAttributeType
		noTipDeliveriesSalesMax.name = "noTipDeliveriesSalesMax"
		noTipDeliveriesSalesMax.expression = NSExpression(forFunction: "max:", arguments: [noTipDeliveriesExpression])
		noTipDeliveriesSalesMax.expressionResultType = .doubleAttributeType
		noTipDeliveriesSalesMin.name = "noTipDeliveriesSalesMin"
		noTipDeliveriesSalesMin.expression = NSExpression(forFunction: "min:", arguments: [noTipDeliveriesExpression])
		noTipDeliveriesSalesMin.expressionResultType = .doubleAttributeType
		noTipDeliveriesSalesAvg.name = "noTipDeliveriesSalesAvg"
		noTipDeliveriesSalesAvg.expression = NSExpression(forFunction: "average:", arguments: [noTipDeliveriesExpression])
		noTipDeliveriesSalesAvg.expressionResultType = .doubleAttributeType
		noTipDeliveriesRequest.resultType = .dictionaryResultType
		noTipDeliveriesRequest.predicate = noTipDeliveriesPredicate
		noTipDeliveriesRequest.propertiesToFetch = [noTipDeliveriesSales, noTipDeliveriesSalesMax, noTipDeliveriesSalesMin, noTipDeliveriesSalesAvg]
		
		let deliveryCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		deliveryCountRequest.resultType = .countResultType
		
		let deliveryDayCountRequest = NSFetchRequest<NSNumber>(entityName: "DeliveryDay")
		deliveryDayCountRequest.resultType = .countResultType
		
		let dropCountRequest = NSFetchRequest<NSNumber>(entityName: "Drop")
		dropCountRequest.resultType = .countResultType
		
		let noTipCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		let noTipPredicate = NSPredicate(format: "noTip == %@", "1")
		noTipCountRequest.resultType = .countResultType
		noTipCountRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [noTipPredicate])
		
		let noneCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		noneCountRequest.resultType = .countResultType
		noneCountRequest.predicate = NSPredicate(format: "paymentMethod == %@", "0")
		
		let cashCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		cashCountRequest.resultType = .countResultType
		cashCountRequest.predicate = NSPredicate(format: "paymentMethod == %@", "1")
		
		let checkCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		checkCountRequest.resultType = .countResultType
		checkCountRequest.predicate = NSPredicate(format: "paymentMethod == %@", "2")
		
		let creditCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		creditCountRequest.resultType = .countResultType
		creditCountRequest.predicate = NSPredicate(format: "paymentMethod == %@", "3")
		
		let chargeCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		chargeCountRequest.resultType = .countResultType
		chargeCountRequest.predicate = NSPredicate(format: "paymentMethod == %@", "4")
		
		let otherCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		otherCountRequest.resultType = .countResultType
		otherCountRequest.predicate = NSPredicate(format: "paymentMethod == %@", "5")
		
		let ticketAmountTotalRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let ticketAmountTotal = NSExpressionDescription()
		let ticketAmountMax = NSExpressionDescription()
		let ticketAmountMin = NSExpressionDescription()
		let ticketAmountAverage = NSExpressionDescription()
		let ticketAmountExpression = NSExpression(forKeyPath: #keyPath(Delivery.ticketAmount))
		ticketAmountTotal.name = "ticketAmountTotal"
		ticketAmountTotal.expression = NSExpression(forFunction: "sum:", arguments: [ticketAmountExpression])
		ticketAmountTotal.expressionResultType = .doubleAttributeType
		ticketAmountMax.name = "ticketAmountMax"
		ticketAmountMax.expression = NSExpression(forFunction: "max:", arguments: [ticketAmountExpression])
		ticketAmountMax.expressionResultType = .doubleAttributeType
		ticketAmountMin.name = "ticketAmountMin"
		ticketAmountMin.expression = NSExpression(forFunction: "min:", arguments: [ticketAmountExpression])
		ticketAmountMin.expressionResultType = .doubleAttributeType
		ticketAmountAverage.name = "ticketAmountAverage"
		ticketAmountAverage.expression = NSExpression(forFunction: "average:", arguments: [ticketAmountExpression])
		ticketAmountAverage.expressionResultType = .doubleAttributeType
		ticketAmountTotalRequest.resultType = .dictionaryResultType
		ticketAmountTotalRequest.propertiesToFetch = [ticketAmountTotal, ticketAmountMax, ticketAmountMin, ticketAmountAverage]
		
		let totalTipsTotalRequest = NSFetchRequest<NSDictionary>(entityName: "Delivery")
		let totalTipNonZeroPredicate = NSPredicate(format: "totalTips != %@", "0.0")
		let totalTipsTotal = NSExpressionDescription()
		let totalTipsMax = NSExpressionDescription()
		let totalTipsMin = NSExpressionDescription()
		let totalTipsAverage = NSExpressionDescription()
		let totalTipsExpression = NSExpression(forKeyPath: #keyPath(Delivery.totalTips))
		totalTipsTotal.name = "totalTipsTotal"
		totalTipsTotal.expression = NSExpression(forFunction: "sum:", arguments: [totalTipsExpression])
		totalTipsTotal.expressionResultType = .doubleAttributeType
		totalTipsMax.name = "totalTipsMax"
		totalTipsMax.expression = NSExpression(forFunction: "max:", arguments: [totalTipsExpression])
		totalTipsMax.expressionResultType = .doubleAttributeType
		totalTipsMin.name = "totalTipsMin"
		totalTipsMin.expression = NSExpression(forFunction: "min:", arguments: [totalTipsExpression])
		totalTipsMin.expressionResultType = .doubleAttributeType
		totalTipsAverage.name = "totalTipsAverage"
		totalTipsAverage.expression = NSExpression(forFunction: "average:", arguments: [totalTipsExpression])
		totalTipsAverage.expressionResultType = .doubleAttributeType
		totalTipsTotalRequest.resultType = .dictionaryResultType
		totalTipsTotalRequest.propertiesToFetch = [totalTipsTotal, totalTipsMax, totalTipsMin, totalTipsAverage]
		totalTipsTotalRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [totalTipNonZeroPredicate])
		
		let dropTotalRequest = NSFetchRequest<NSDictionary>(entityName: "Drop")
		let dropTotal = NSExpressionDescription()
		let dropMax = NSExpressionDescription()
		let dropMin = NSExpressionDescription()
		let dropAverage = NSExpressionDescription()
		let dropExpression = NSExpression(forKeyPath: #keyPath(Drop.amount))
		dropTotal.name = "dropTotal"
		dropTotal.expression = NSExpression(forFunction: "sum:", arguments: [dropExpression])
		dropTotal.expressionResultType = .doubleAttributeType
		dropMax.name = "dropMax"
		dropMax.expression = NSExpression(forFunction: "max:", arguments: [dropExpression])
		dropMax.expressionResultType = .doubleAttributeType
		dropMin.name = "dropMin"
		dropMin.expression = NSExpression(forFunction: "min:", arguments: [dropExpression])
		dropMin.expressionResultType = .doubleAttributeType
		dropAverage.name = "dropAverage"
		dropAverage.expression = NSExpression(forFunction: "average:", arguments: [dropExpression])
		dropAverage.expressionResultType = .doubleAttributeType
		dropTotalRequest.resultType = .dictionaryResultType
		dropTotalRequest.propertiesToFetch = [dropTotal, dropMax, dropMin, dropAverage]
		
		do {
			let deliveryCountResult = try context.fetch(deliveryCountRequest)
			let deliveryCount = deliveryCountResult.first?.doubleValue
			deliveriesCount = "\(Int(deliveryCount!))"
			
			let deliveryDayCountResult = try context.fetch(deliveryDayCountRequest)
			let deliveryDayCount = deliveryDayCountResult.first?.doubleValue
			deliveryDaysCount = "\(Int(deliveryDayCount!))"
			
			let noneCountResult = try context.fetch(noneCountRequest)
			let noneCount = noneCountResult.first?.doubleValue
			
			let cashCountResult = try context.fetch(cashCountRequest)
			let cashCount = cashCountResult.first?.doubleValue
			
			let checkCountResult = try context.fetch(checkCountRequest)
			let checkCount = checkCountResult.first?.doubleValue
			
			let creditCountResult = try context.fetch(creditCountRequest)
			let creditCount = creditCountResult.first?.doubleValue
			
			let chargeCountResult = try context.fetch(chargeCountRequest)
			let chargeCount = chargeCountResult.first?.doubleValue
			
			let otherCountResult = try context.fetch(otherCountRequest)
			let otherCount = otherCountResult.first?.doubleValue
			
			let noTipCountResult = try context.fetch(noTipCountRequest)
			let noTipCount = noTipCountResult.first?.doubleValue
			
			if deliveryCount != 0.0 {
				let paidout = deliveryCount! * 1.25
				self.paidout = paidout.convertToCurrency()
				do {
					self.ticketAmountDictionaryFinal = try context.fetch(ticketAmountTotalRequest)
					if self.ticketAmountDictionaryFinal! != [] as [NSDictionary] {
						let ticketAmountFinalDictionary = ticketAmountDictionaryFinal?.first
						let ticketAmountAverage = (ticketAmountFinalDictionary?["ticketAmountAverage"] as! Double?)!
						self.ticketAmountAverage = ticketAmountAverage.convertToCurrency()
						let ticketAmountMax = (ticketAmountFinalDictionary?["ticketAmountMax"] as! Double?)!
						self.ticketAmountMax = ticketAmountMax.convertToCurrency()
						let ticketAmountMin = (ticketAmountFinalDictionary?["ticketAmountMin"] as! Double?)!
						self.ticketAmountMin = ticketAmountMin.convertToCurrency()
						let ticketAmount = (ticketAmountFinalDictionary?["ticketAmountTotal"] as! Double?)!
						self.ticketAmount = ticketAmount.convertToCurrency()
						
						self.totalReceivedDictionaryFinal = try context.fetch(totalReceivedRequest)
						let totalReceivedFinalDictionary = totalReceivedDictionaryFinal?.first
						let totalReceivedAverage: Double = totalReceivedFinalDictionary?["totalReceivedAvg"] as! Double
						self.totalReceivedAverage = totalReceivedAverage.convertToCurrency()
						let totalReceivedMax: Double = totalReceivedFinalDictionary?["totalReceivedMax"] as! Double
						self.totalReceivedMax = totalReceivedMax.convertToCurrency()
						let totalReceivedMin: Double = totalReceivedFinalDictionary?["totalReceivedMin"] as! Double
						self.totalReceivedMin = totalReceivedMin.convertToCurrency()
						let totalReceived: Double = totalReceivedFinalDictionary?["totalReceived"] as! Double
						self.totalReceived = totalReceived.convertToCurrency()
						
						self.totalTipsDictionaryFinal = try context.fetch(totalTipsTotalRequest)
						let totalTipsFinalDictionary = totalTipsDictionaryFinal?.first
						let totalTipsAverage: Double = totalTipsFinalDictionary?["totalTipsAverage"] as! Double
						self.totalTipsAverage = totalTipsAverage.convertToCurrency()
						let totalTipsMax: Double = totalTipsFinalDictionary?["totalTipsMax"] as! Double
						self.totalTipsMax = totalTipsMax.convertToCurrency()
						let totalTipsMin: Double = totalTipsFinalDictionary?["totalTipsMin"] as! Double
						self.totalTipsMin = totalTipsMin.convertToCurrency()
						let totalTips: Double = totalTipsFinalDictionary?["totalTipsTotal"] as! Double
						self.totalTips = totalTips.convertToCurrency()
						
						self.cashSalesDictionaryFinal = try context.fetch(cashPaymentMethodRequest)
						if self.cashSalesDictionaryFinal! != [] as [NSDictionary] {
							if let cashSalesDictionaryFinal = self.cashSalesDictionaryFinal {
								let cashSalesFinalDictionary = cashSalesDictionaryFinal.first
								let cashSalesTotal: Double = cashSalesFinalDictionary?["cashPaymentMethodSales"] as! Double
								self.cashSales = cashSalesTotal.convertToCurrency()
								if cashSalesTotal != 0 {
									let cashSalesMax: Double = cashSalesFinalDictionary?["cashPaymentMethodSalesMax"] as! Double
									self.cashSalesMax = cashSalesMax.convertToCurrency()
									let cashSalesMin: Double = cashSalesFinalDictionary?["cashPaymentMethodSalesMin"] as! Double
									self.cashSalesMin = cashSalesMin.convertToCurrency()
									let cashSalesAvg: Double = cashSalesFinalDictionary?["cashPaymentMethodSalesAvg"] as! Double
									self.cashSalesAverage = cashSalesAvg.convertToCurrency()
									if let cashCount = cashCount {
										self.cashCount = "\(Int(cashCount))"
										self.cashSalesPercentage = cashSalesTotal.getDoublePercentage(ticketAmount)
										self.cashDeliveryPercentage = cashCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						
						self.checkSalesDictionaryFinal = try context.fetch(checkPaymentMethodRequest)
						if self.checkSalesDictionaryFinal! != [] as [NSDictionary] {
							if let checkSalesDictionaryFinal = self.checkSalesDictionaryFinal {
								let checkSalesFinalDictionary = checkSalesDictionaryFinal.first
								let checkSalesTotal: Double = checkSalesFinalDictionary?["checkPaymentMethodSales"] as! Double
								self.checkSales = checkSalesTotal.convertToCurrency()
								if checkSalesTotal != 0 {
									let checkSalesMax: Double = checkSalesFinalDictionary?["checkPaymentMethodSalesMax"] as! Double
									self.checkSalesMax = checkSalesMax.convertToCurrency()
									let checkSalesMin: Double = checkSalesFinalDictionary?["checkPaymentMethodSalesMin"] as! Double
									self.checkSalesMin = checkSalesMin.convertToCurrency()
									let checkSalesAvg: Double = checkSalesFinalDictionary?["checkPaymentMethodSalesAvg"] as! Double
									self.checkSalesAverage = checkSalesAvg.convertToCurrency()
									if let checkCount = checkCount {
										self.checkCount = "\(Int(checkCount))"
										self.checkSalesPercentage = checkSalesTotal.getDoublePercentage(ticketAmount)
										self.checkDeliveryPercentage = checkCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						
						self.creditSalesDictionaryFinal = try context.fetch(creditPaymentMethodRequest)
						if self.creditSalesDictionaryFinal! != [] as [NSDictionary] {
							if let creditSalesDictionaryFinal = self.creditSalesDictionaryFinal {
								let creditSalesFinalDictionary = creditSalesDictionaryFinal.first
								let creditSalesTotal: Double = creditSalesFinalDictionary?["creditPaymentMethodSales"] as! Double
								self.creditSales = creditSalesTotal.convertToCurrency()
								if creditSalesTotal != 0 {
									let creditSalesMax: Double = creditSalesFinalDictionary?["creditPaymentMethodSalesMax"] as! Double
									self.creditSalesMax = creditSalesMax.convertToCurrency()
									let creditSalesMin: Double = creditSalesFinalDictionary?["creditPaymentMethodSalesMin"] as! Double
									self.creditSalesMin = creditSalesMin.convertToCurrency()
									let creditSalesAvg: Double = creditSalesFinalDictionary?["creditPaymentMethodSalesAvg"] as! Double
									self.creditSalesAverage = creditSalesAvg.convertToCurrency()
									if let creditCount = creditCount {
										self.creditCount = "\(Int(creditCount))"
										self.creditSalesPercentage = creditSalesTotal.getDoublePercentage(ticketAmount)
										self.creditDeliveryPercentage = creditCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						
						self.chargeSalesDictionaryFinal = try context.fetch(chargePaymentMethodRequest)
						if self.chargeSalesDictionaryFinal! != [] as [NSDictionary] {
							if let chargeSalesDictionaryFinal = self.chargeSalesDictionaryFinal {
								let chargeSalesFinalDictionary = chargeSalesDictionaryFinal.first
								let chargeSalesTotal: Double = chargeSalesFinalDictionary?["chargePaymentMethodSales"] as! Double
								self.chargeSales = chargeSalesTotal.convertToCurrency()
								if chargeSalesTotal != 0 {
									let chargeSalesMax: Double = chargeSalesFinalDictionary?["chargePaymentMethodSalesMax"] as! Double
									self.chargeSalesMax = chargeSalesMax.convertToCurrency()
									let chargeSalesMin: Double = chargeSalesFinalDictionary?["chargePaymentMethodSalesMin"] as! Double
									self.chargeSalesMin = chargeSalesMin.convertToCurrency()
									let chargeSalesAvg: Double = chargeSalesFinalDictionary?["chargePaymentMethodSalesAvg"] as! Double
									self.chargeSalesAverage = chargeSalesAvg.convertToCurrency()
									if let chargeCount = chargeCount {
										self.chargeCount = "\(Int(chargeCount))"
										self.chargeSalesPercentage = chargeSalesTotal.getDoublePercentage(ticketAmount)
										self.chargeDeliveryPercentage = chargeCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						
						self.otherSalesDictionaryFinal = try context.fetch(otherPaymentMethodRequest)
						if self.otherSalesDictionaryFinal! != [] as [NSDictionary] {
							if let otherSalesDictionaryFinal = self.otherSalesDictionaryFinal {
								print(otherSalesDictionaryFinal)
								let otherSalesFinalDictionary = otherSalesDictionaryFinal.first
								let otherSalesTotal: Double = otherSalesFinalDictionary?["otherPaymentMethodSales"] as! Double
								self.otherSales = otherSalesTotal.convertToCurrency()
								if otherSalesTotal != 0 {
									let otherSalesMax: Double = otherSalesFinalDictionary?["otherPaymentMethodSalesMax"] as! Double
									self.otherSalesMax = otherSalesMax.convertToCurrency()
									let otherSalesMin: Double = otherSalesFinalDictionary?["otherPaymentMethodSalesMin"] as! Double
									self.otherSalesMin = otherSalesMin.convertToCurrency()
									let otherSalesAvg: Double = otherSalesFinalDictionary?["otherPaymentMethodSalesAvg"] as! Double
									self.otherSalesAverage = otherSalesAvg.convertToCurrency()
									if let otherCount = otherCount {
										self.otherCount = "\(Int(otherCount))"
										self.otherSalesPercentage = otherSalesTotal.getDoublePercentage(ticketAmount)
										self.otherDeliveryPercentage = otherCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						self.noneSalesDictionaryFinal = try context.fetch(nonePaymentMethodRequest)
						if self.noneSalesDictionaryFinal! != [] as [NSDictionary] {
							if let noneSalesDictionaryFinal = self.noneSalesDictionaryFinal {
								let noneSalesFinalDictionary = noneSalesDictionaryFinal.first
								let noneSalesTotal: Double = noneSalesFinalDictionary?["nonePaymentMethodSales"] as! Double
								self.noneSales = noneSalesTotal.convertToCurrency()
								if noneSalesTotal != 0 {
									let noneSalesMax: Double = noneSalesFinalDictionary?["nonePaymentMethodSalesMax"] as! Double
									self.noneSalesMax = noneSalesMax.convertToCurrency()
									let noneSalesMin: Double = noneSalesFinalDictionary?["nonePaymentMethodSalesMin"] as! Double
									self.noneSalesMin = noneSalesMin.convertToCurrency()
									let noneSalesAvg: Double = noneSalesFinalDictionary?["nonePaymentMethodSalesAvg"] as! Double
									self.noneSalesAverage = noneSalesAvg.convertToCurrency()
									if let noneCount = noneCount {
										self.noneCount = "\(Int(noneCount))"
										self.noneSalesPercentage = noneSalesTotal.getDoublePercentage(ticketAmount)
										self.noneDeliveryPercentage = noneCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						
						self.noTipSalesDictionaryFinal = try context.fetch(noTipDeliveriesRequest)
						if self.noTipSalesDictionaryFinal! != [] as [NSDictionary] {
							if let noTipSalesDictionaryFinal = self.noTipSalesDictionaryFinal {
								let noTipSalesFinalDictionary = noTipSalesDictionaryFinal.first
								let noTipSalesTotal: Double = noTipSalesFinalDictionary?["noTipDeliveriesSales"] as! Double
								self.noTipSales = noTipSalesTotal.convertToCurrency()
								if noTipSalesTotal != 0 {
									let noTipSalesMax: Double = noTipSalesFinalDictionary?["noTipDeliveriesSalesMax"] as! Double
									self.noTipSalesMax = noTipSalesMax.convertToCurrency()
									let noTipSalesMin: Double = noTipSalesFinalDictionary?["noTipDeliveriesSalesMin"] as! Double
									self.noTipSalesMin = noTipSalesMin.convertToCurrency()
									let noTipSalesAvg: Double = noTipSalesFinalDictionary?["noTipDeliveriesSalesAvg"] as! Double
									self.noTipSalesAverage = noTipSalesAvg.convertToCurrency()
									if let noTipCount = noTipCount {
										self.noTipCount = "\(Int(noTipCount))"
										self.noTipSalesPercentage = noTipSalesTotal.getDoublePercentage(ticketAmount)
										self.noTipDeliveryPercentage = noTipCount.getDoublePercentage(deliveryCount!)
									}
								}
							}
						}
						
						
						self.dropDictionaryFinal = try context.fetch(dropTotalRequest)
						if self.dropDictionaryFinal! != [] as [NSDictionary] {
							if let dropDictionaryFinal = self.dropDictionaryFinal {
								let dropFinalDictionary = dropDictionaryFinal.first
								let drop: Double = dropFinalDictionary?["dropTotal"] as! Double
								self.drop = drop.convertToCurrency()
								if drop != 0 {
									let dropAverage: Double = dropFinalDictionary?["dropAverage"] as! Double
									self.dropAverage = dropAverage.convertToCurrency()
									let dropMax: Double = dropFinalDictionary?["dropMax"] as! Double
									self.dropMax = dropMax.convertToCurrency()
									let dropMin: Double = dropFinalDictionary?["dropMin"] as! Double
									self.dropMin = dropMin.convertToCurrency()
								}
							}
						}
						
						
						let deliveryCountResult = try context.fetch(deliveryCountRequest)
						let deliveryCount = deliveryCountResult.first?.doubleValue
						
						//let dropCountResult = try context.fetch(dropCountRequest)
						//let dropCount = dropCountResult.first?.doubleValue
						
						let noTipCountResult = try context.fetch(noTipCountRequest)
						let noTipCount = noTipCountResult.first?.doubleValue
						self.noTipCountLabel.text = "\(Int(noTipCount!))"
						
						let paidout = deliveryCount! * 1.25
						self.paidoutLabel.text = paidout.convertToCurrency()
						
						//self.differenceLabel.checkForNegative()
					}
				} catch let nserror as NSError {
					let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
					alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
					self.present(alert, animated: true, completion: nil)
				}
			}
		} catch let nserror as NSError {
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func activityIndicator(msg: String, _ indicator: Bool ) {
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
}
