//
//  DeliveryStatisticsTableViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/28/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//


import UIKit
import CoreData

class DeliveryStatisticsTableViewController : UITableViewController, UITextFieldDelegate {
	
	// MARK: StoryBoard Outlets
	
	@IBOutlet var saveDeliveryDay: UIBarButtonItem!
	@IBOutlet var manualDeliveryDayLabel: UILabel!
	@IBOutlet var manualDeliverySwitch: UISwitch!
	@IBOutlet var deliveriesCount: UITextField!
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
	@IBOutlet var actuallyReceivedField: CurrencyField!
	@IBOutlet var differenceLabel: UILabel!
	
	// MARK: StoryBoard Actions
	
	@IBAction func manualDeliverySwitchChanged(_ sender: Any) {
		deliveriesCount.isEnabled = manualDeliverySwitch.isOn
		self.tabBarController?.tabBar.items![1].isEnabled = !manualDeliverySwitch.isOn
		self.tabBarController?.tabBar.items![2].isEnabled = !manualDeliverySwitch.isOn
		tableView.reloadData()
		if manualDeliverySwitch.isOn {
			addBarButtons()
			previousBarButton.isEnabled = false
			deliveriesCount.becomeFirstResponder()
			deliveriesCount.selectedTextRange = deliveriesCount.textRange(from: deliveriesCount.beginningOfDocument, to: deliveriesCount.endOfDocument)
		} else {
			deliveriesCount.resignFirstResponder()
		}
	}
	@IBAction func endEditing(_ sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
		calculateManual()
	}
	@IBAction func ReceivedTextFieldEditingEnded(_ sender: UITextField) {
		if manualDeliverySwitch.isOn {
			calculateManual()
		} else {
			let tips = self.amountGivenFinal - self.ticketAmountFinal + self.cashTipsFinal
			let paidOut = Double(self.deliveries.count) * 1.25
			let shouldRecieve = tips + paidOut
			if actuallyReceivedField.text != nil {
				if var actuallyReceived = actuallyReceivedField.text {
					let difference = actuallyReceived.removeDollarSign() - shouldRecieve
					differenceLabel.text = difference.convertToCurrency()
					differenceLabel.checkForNegative()
				}
			} else {
				let actuallyReceived = 0.00
				let difference = shouldRecieve - actuallyReceived
				differenceLabel.text = difference.convertToCurrency()
				differenceLabel.checkForNegative()
			}
		}
	}
	
	// MARK: Variables and Constants
	
	var deliveryDay: DeliveryDay?
	var deliveryDays = [DeliveryDay]()
	var delivery: Delivery?
	var deliveries = [Delivery]()
	var drop: Drop?
	var drops = [Drop]()
	var deliveryDayViewController: DeliveryDayViewController?
	var tabBar: DeliveryTabBarViewController?
	var ticketAmountArray: [Double] = []
	var ticketAmountFinal: Double = 0.0
	var amountGivenArray: [Double] = []
	var amountGivenFinal: Double = 0.0
	var cashTipsArray: [Double] = []
	var cashTipsFinal: Double = 0.0
	var totalTipsArray: [Double] = []
	var totalTipsFinal: Double = 0.0
	var totalTipsMinArray: [Double] = []
	var totalDropsArray: [Double] = []
	var totalDropsFinal: Double = 0.0
	var noTipArray: [Bool] = []
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
	var whoMadeBank: Person?
	var whoClosedBank: Person?
	var sender: String?
	var mainContext: NSManagedObjectContext? = nil
	static var shortcutAction: String = ""
	let keyboardToolbar = UIToolbar()
	let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryStatisticsTableViewController.goToPreviousField))
	let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryStatisticsTableViewController.goToNextField))
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBarController?.tabBar.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		keyboardToolbar.backgroundColor = UIColor(red:0.09, green:0.11, blue:0.11, alpha:1.0)
		actuallyReceivedField.delegate = self
		deliveriesCount.delegate = self
		if let deliveryDay = deliveryDay {
			deliveries = deliveryDay.deliveries?.array as! [Delivery]
			drops = deliveryDay.drops?.array as! [Drop]
		}
	}
	override func viewDidAppear(_ animated: Bool) {
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		chargeGivenArray.removeAll()
		cashTipsArray.removeAll()
		totalTipsArray.removeAll()
		totalTipsMinArray.removeAll()
		noTipArray.removeAll()
		totalDropsArray.removeAll()
		cashSalesArray.removeAll()
		checkSalesArray.removeAll()
		creditSalesArray.removeAll()
		chargeSalesArray.removeAll()
		otherSalesArray.removeAll()
		noTipSalesArray.removeAll()
		//deliveries.sumValue(delivery!.ticketAmount)
		for (index, _) in deliveries.enumerated() {
			let delivery = deliveries[index]
			ticketAmountArray.append(delivery.ticketAmount)
			
			// Sum of amountGiven
			amountGivenArray.append(delivery.amountGiven)
			let amountGivenTotaled = amountGivenArray.reduce(0, + )
			self.amountGivenFinal = amountGivenTotaled
			
			// Sum of cashTips
			cashTipsArray.append(delivery.cashTips)
			let cashTipsTotaled = cashTipsArray.reduce(0, + )
			self.cashTipsFinal = cashTipsTotaled
			
			// Sum of totalTips
			if delivery.totalTips > 0.0 {
				totalTipsMinArray.append(delivery.totalTips)
			}
			totalTipsArray.append(delivery.totalTips)
			let totalTipsTotaled = totalTipsArray.reduce(0, + )
			self.totalTipsFinal = totalTipsTotaled
			
			//NoTipSwitchArray
			noTipArray.append(delivery.noTip)
			
			//Payment Method Sales Total
			switch delivery.paymentMethod {
			case 1:
				cashSalesArray.append(delivery.ticketAmount)
				let cashSalesTotaled = cashSalesArray.reduce(0, + )
				self.cashSalesFinal = cashSalesTotaled
			case 2:
				checkSalesArray.append(delivery.ticketAmount)
				let checkSalesTotaled = checkSalesArray.reduce(0, + )
				self.checkSalesFinal = checkSalesTotaled
			case 3:
				creditSalesArray.append(delivery.ticketAmount)
				let creditSalesTotaled = creditSalesArray.reduce(0, + )
				self.creditSalesFinal = creditSalesTotaled
			case 4:
				chargeSalesArray.append(delivery.ticketAmount)
				let chargeSalesTotaled = chargeSalesArray.reduce(0, + )
				self.chargeSalesFinal = chargeSalesTotaled
				chargeGivenArray.append(delivery.amountGiven)
			case 5:
				otherSalesArray.append(delivery.ticketAmount)
			default: break				
			}
			if delivery.noTip {
				noTipSalesArray.append(delivery.ticketAmount)
			}
			let ticketAmountTotaled = ticketAmountArray.reduce(0, + )
			self.ticketAmountFinal = ticketAmountTotaled
			let chargeGivenTotaled = chargeGivenArray.reduce(0, + )
			self.chargeGivenFinal = chargeGivenTotaled
			let otherSalesTotaled = otherSalesArray.reduce(0, + )
			self.otherSalesFinal = otherSalesTotaled
			let noTipSalesTotaled = noTipSalesArray.reduce(0, + )
			self.noTipSalesFinal = noTipSalesTotaled
		}
		for (index, _) in drops.enumerated() {
			let drop = drops[index]
			totalDropsArray.append(drop.amount)
			let totalDropsTotaled = totalDropsArray.reduce(0, +)
			self.totalDropsFinal = totalDropsTotaled
		}
		let startingBank = startingBankField.text?.removeDollarSign() ?? 0.0
		let ticketAmountAverage = ticketAmountArray.reduce(0.0) {
			return $0 + $1 / Double(ticketAmountArray.count)
		}
		let totalTipsAverage = totalTipsArray.reduce(0.0) {
			return $0 + $1 / Double(totalTipsArray.count)
		}
		let paidoutTotal = Double(deliveries.count) * 1.25
		let amountShouldReceive = (amountGivenFinal - chargeGivenFinal) - (cashSalesFinal + checkSalesFinal + creditSalesFinal + otherSalesFinal) + paidoutTotal + cashTipsFinal
		let bankBalance = (cashSalesFinal + checkSalesFinal + creditSalesFinal + otherSalesFinal + startingBank - totalDropsFinal)
		if noTipArray.contains(true) {
			let noTipArrayFilter = noTipArray.filter {
				el in el == true
			}
			self.noTipArrayCount = noTipArrayFilter.count
		} else {
			self.noTipArrayCount = 0
		}
		if manualDeliverySwitch.isOn {
			if self.sender == "Who Made Bank" {
				whoMadeBankLabel.text = whoMadeBank?.name
			} else if self.sender == "Who Closed Bank" {
				whoClosedBankLabel.text = whoClosedBank?.name
			} else {
				whoClosedBankLabel.text = whoClosedBank?.name
				whoMadeBankLabel.text = whoMadeBank?.name
			}
		} else if deliveries.count != 0 {
			deliveriesCount.text = String(deliveries.count)
			totalSalesLabel.text = ticketAmountFinal.convertToCurrency()
			totalAmountGivenLabel.text = amountGivenFinal.convertToCurrency()
			totalTipsLabel.text = totalTipsFinal.convertToCurrency()
			paidoutLabel.text = paidoutTotal.convertToCurrency()
			amountShouldRecieveTotalsLabel.text = amountShouldReceive.convertToCurrency()
			if ticketAmountFinal != 0 {
				salesAverageLabel.text = ticketAmountAverage.convertToCurrency()
				salesMaxLabel.text = ticketAmountArray.max()!.convertToCurrency()
				salesMinLabel.text = ticketAmountArray.min()!.convertToCurrency()
				cashSalesLabel.text = cashSalesFinal.convertToCurrency()
				checkSalesLabel.text = checkSalesFinal.convertToCurrency()
				creditSalesLabel.text = creditSalesFinal.convertToCurrency()
				chargeSalesLabel.text = chargeSalesFinal.convertToCurrency()
				otherSalesLabel.text = otherSalesFinal.convertToCurrency()
				tipsAverageLabel.text = totalTipsAverage.convertToCurrency()
				tipsMaxLabel.text = totalTipsArray.max()!.convertToCurrency()
				tipsMinLabel.text = totalTipsMinArray.min()!.convertToCurrency()
				noTipCountLabel.text = String(self.noTipArrayCount)
				noTipSalesLabel.text = noTipSalesFinal.convertToCurrency()
				let tips = self.amountGivenFinal - self.ticketAmountFinal + self.cashTipsFinal
				let paidOut = Double(self.deliveries.count) * 1.25
				let shouldRecieve = tips + paidOut
				var actuallyReceived: Double = 0.0
				if var actuallyReceivedText = actuallyReceivedField.text {
					actuallyReceived = actuallyReceivedText.removeDollarSign()
				}
				let difference = actuallyReceived - shouldRecieve
				differenceLabel.text = difference.convertToCurrency()
				if difference < 0 {
					differenceLabel.textColor = UIColor.red
				} else {
					differenceLabel.textColor = UIColor.white
				}
			}
			bankBalanceLabel.text = bankBalance.convertToCurrency()
			totalDropsLabel.text = totalDropsFinal.convertToCurrency()
			amountShouldRecieveBankDetailsLabel.text = amountShouldReceive.convertToCurrency()
		}
		currentDeliverDayDateLabel.text = deliveryDay?.date?.convertToDateString()
		//self.tabBarController?.tabBar.items![1].badge = String(deliveries.count)
		//self.tabBarController?.tabBar.items![2].badge = String(drops.count)
		if self.sender == "Who Made Bank" {
			whoMadeBankLabel.text = whoMadeBank?.name
		} else if self.sender == "Who Closed Bank" {
			whoClosedBankLabel.text = whoClosedBank?.name
		} else {
			whoClosedBankLabel.text = whoClosedBank?.name
			whoMadeBankLabel.text = whoMadeBank?.name
		}
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	// MARK: Table View Life Cycle
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let title = UILabel()
		title.textColor = UIColor.white
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = title.textColor
	}
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if manualDeliverySwitch.isOn {
			if section == 1 {
				return 0.0
			} else if section == 2 {
				return 0.0
			} else {
				return 28
			}
		} else {
			return 28
		}
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if manualDeliverySwitch.isOn {
			if indexPath == [0, 1] {
				return 0.0
			} else if indexPath == [0, 2] {
				return 0.0
			} else if indexPath == [0, 5] {
				return 0.0
			} else if indexPath == [1, 0] {
				return 0.0
			} else if indexPath == [1, 1] {
				return 0.0
			} else if indexPath == [1, 2] {
				return 0.0
			} else if indexPath == [1, 3] {
				return 0.0
			} else if indexPath == [1, 4] {
				return 0.0
			} else if indexPath == [1, 5] {
				return 0.0
			} else if indexPath == [1, 6] {
				return 0.0
			} else if indexPath == [1, 7] {
				return 0.0
			} else if indexPath == [2, 0] {
				return 0.0
			} else if indexPath == [2, 1] {
				return 0.0
			} else if indexPath == [2, 2] {
				return 0.0
			} else if indexPath == [2, 3] {
				return 0.0
			} else if indexPath == [2, 4] {
				return 0.0
			} else if indexPath == [3, 1] {
				return 0.0
			} else if indexPath == [3, 2] {
				return 0.0
			} else if indexPath == [3, 3] {
				return 0.0
			} else if indexPath == [3, 6] {
				return 0.0
			} else if indexPath == [3, 8] {
				return 0.0
			} else {
				return 44.00
			}
		} else {
			return 44.00
		}
	}
	
	// MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		ticketAmountArray.removeAll()
		amountGivenArray.removeAll()
		totalTipsArray.removeAll()
		if manualDeliverySwitch.isOn {/*
			let numberOfDeliveries: Double = Double(deliveriesCount.text!)!
			let totalPaidout = numberOfDeliveries * 1.25
			let totalReceived = removeFirstCharactersFrom(inputString: actuallyReceivedField.text!)
			let totalTips = "\(Double(totalReceived)! - totalPaidout)"
			totalTipsLabel.text = "$" + totalTips
			let deliveryCountValue = deliveriesCount.text ?? "0"
			let deliveryDateValue = String(DeliveryDayViewController.selectedDateGlobal) ?? "010116"
			let totalTipsValue = Double(totalReceived)! - totalPaidout.convertToCurrency()
			let whoMadeBankName = self.whoMadeBank
			let whoClosedBankName = self.whoClosedBank
			let totalReceivedValue = actuallyReceivedField.text ?? "$0.00"
			let manual = true
			deliveryDay = DeliveryDay(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryCountValue, totalTipsValue: totalTipsValue, totalReceivedValue: totalReceivedValue, whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName, manual: manual)*/
			/*} else if let savedDeliveries = loadDeliveries() {
			deliveries = savedDeliveries
			for (index, _) in deliveries.enumerated() {
			let delivery = deliveries[index]
			var ticketAmountDropped = delivery.ticketAmountValue
			ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
			let ticketAmount = round(Double(ticketAmountDropped)! * 100) / 100
			ticketAmountArray.append(ticketAmount)
			let ticketAmountTotaled = ticketAmountArray.reduce(0, + )
			self.ticketAmountFinal = ticketAmountTotaled
			// Sum of amountGiven
			var amountGivenDropped = delivery.amountGivenValue
			amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
			let amountGiven = round(Double(amountGivenDropped)! * 100) / 100
			amountGivenArray.append(amountGiven)
			let amountGivenTotaled = amountGivenArray.reduce(0, + )
			self.amountGivenFinal = amountGivenTotaled
			// Sum of totalTips
			var totalTipsDropped = delivery.totalTipsValue
			totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
			let totalTips = round(Double(totalTipsDropped)! * 100) / 100
			totalTipsArray.append(totalTips)
			let totalTipsTotaled = totalTipsArray.reduce(0, + )
			self.totalTipsFinal = totalTipsTotaled
			}
			let deliveryCountValue = String(deliveries.count)
			let deliveryDateValue = String(DeliveryDayViewController.selectedDateGlobal) ?? "010116"
			let totalTipsValue = "S" + "\(String(format: "%.2f", totalTipsFinal))"
			let whoMadeBankName = self.whoMadeBank
			let whoClosedBankName = self.whoClosedBank
			let totalReceivedValue = actuallyReceivedField.text
			let manual = false
			deliveryDay = DeliveryDay(deliveryDateValue: deliveryDateValue, deliveryDayCountValue: deliveryCountValue, totalTipsValue: totalTipsValue, totalReceivedValue: totalReceivedValue!, whoMadeBankName: whoMadeBankName, whoClosedBankName: whoClosedBankName, manual: manual)
			*/
		} else if segue.identifier == "whoMadeBank" {
			let destination = segue.destination as! PersonTableViewController
			destination.title = "Who Made Bank"
			if let selectedPerson = whoMadeBankLabel.text {
				destination.whoMadeBankSelectedPerson = selectedPerson
			}
			if let selectedPerson = whoClosedBankLabel.text {
				destination.whoClosedBankSelectedPerson = selectedPerson
			}
		} else if segue.identifier == "whoClosedBank" {
			let destination = segue.destination as! PersonTableViewController
			destination.title = "Who Closed Bank"
			if let selectedPerson = whoMadeBankLabel.text {
				destination.whoMadeBankSelectedPerson = selectedPerson
			}
			if let selectedPerson = whoClosedBankLabel.text {
				destination.whoClosedBankSelectedPerson = selectedPerson
			}
		} else if let destinationViewController = segue.destination as? DeliveryDayTableViewController {
			destinationViewController.navigationController?.setNavigationBarHidden(false, animated: true)
		}
	}
	@IBAction func unwindToDeliveryStatisticsTableList(_ sender: UIStoryboardSegue) {
		/*if let sourceViewController = sender.source as? DeliveryDayViewController, let deliveryDay = sourceViewController.deliveryDay {
		if DeliveryDayTableViewController.status != "adding" {
		let selectedIndexPath = Int(DeliveryDayTableViewController.status)
		deliveryDays[selectedIndexPath!] = deliveryDay
		}
		saveDeliveryDays()
		} else*/
		if let sourceViewController = sender.source as? PersonTableViewController {
			if let whoMadeBank = sourceViewController.whoMadeBank {
				if sourceViewController.title == "Who Made Bank" {
					self.whoMadeBank = whoMadeBank
					self.sender = "Who Made Bank"
				}
			}
			if let whoClosedBank = sourceViewController.whoClosedBank {
				if sourceViewController.title == "Who Closed Bank" {
					self.whoClosedBank = whoClosedBank
					self.sender = "Who Closed Bank"
				}
			}
		}
	}
	
	// MARK: Actions
	
	func calculateManual() {
		if manualDeliverySwitch.isOn {
			let numberOfDeliveries: Double = Double(deliveriesCount.text!)!
			let totalPaidout = numberOfDeliveries * 1.25
			let totalReceived = removeFirstCharactersFrom(inputString: actuallyReceivedField.text!)
			let totalTips = Double(totalReceived)! - totalPaidout
			totalTipsLabel.text = totalTips.convertToCurrency()
			paidoutLabel.text = totalPaidout.convertToCurrency()
		}
	}
	func addBarButtons() {
		nextBarButton.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		previousBarButton.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		keyboardToolbar.barTintColor = UIColor(red:0.09, green:0.11, blue:0.11, alpha:1.0)
		keyboardToolbar.sizeToFit()
		keyboardToolbar.items = [flexBarButton, previousBarButton, nextBarButton]
		if manualDeliverySwitch.isOn {
			deliveriesCount.inputAccessoryView = keyboardToolbar
			actuallyReceivedField.inputAccessoryView = keyboardToolbar
		}
	}
	func goToPreviousField(_: Any?) {
		if actuallyReceivedField.isFirstResponder {
			actuallyReceivedField.resignFirstResponder()
			deliveriesCount.becomeFirstResponder()
			deliveriesCount.selectedTextRange = deliveriesCount.textRange(from: deliveriesCount.beginningOfDocument, to: deliveriesCount.endOfDocument)
			previousBarButton.isEnabled = false
			nextBarButton.isEnabled = true
		}
	}
	func goToNextField() {
		if deliveriesCount.isFirstResponder {
			deliveriesCount.resignFirstResponder()
			actuallyReceivedField.becomeFirstResponder()
			actuallyReceivedField.selectedTextRange = actuallyReceivedField.textRange(from: actuallyReceivedField.beginningOfDocument, to: actuallyReceivedField.endOfDocument)
			previousBarButton.isEnabled = true
			nextBarButton.isEnabled = false
		}
	}
	func removeFirstCharactersFrom(inputString: (String)) -> String {
		var tempString = inputString
		tempString.remove(at: (tempString.startIndex))
		return tempString
	}
	
	// MARK: CoreData
	
	func saveDeliveryDays() {
		guard let mainContext = mainContext else {
			return
		}
		if deliveryDay == nil {
			let newDeliveryDay = DeliveryDay(context: mainContext)
			//newDeliveryDay.date = deliveryDatePicker.date as NSDate?
			deliveryDay = newDeliveryDay
		}
	}
}
