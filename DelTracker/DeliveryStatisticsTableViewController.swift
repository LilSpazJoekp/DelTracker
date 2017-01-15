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
			let shouldRecieveRounded = round(shouldRecieve * 100) / 100
			if actuallyReceivedField.text != nil {
				let actuallyReceived = Double(self.removeFirstCharactersFrom(inputString: self.actuallyReceivedField.text!))
				let actuallyReceivedRounded = round(actuallyReceived! * 100) / 100
				let difference = actuallyReceivedRounded - shouldRecieveRounded
				let differenceRounded = round(difference * 100) / 100
				differenceLabel.text = "$" + "\(String(format: "%.2f", differenceRounded))"
				if differenceRounded < 0 {
					differenceLabel.textColor = UIColor.red
				} else {
					differenceLabel.textColor = UIColor.white
				}
			} else {
				let actuallyReceived = 0.00
				let difference = shouldRecieveRounded - actuallyReceived
				let differenceRounded = round(difference * 100) / 100
				differenceLabel.text = "$" + "\(String(format: "%.2f", differenceRounded))"
				if differenceRounded < 0 {
					differenceLabel.textColor = UIColor.red
				} else {
					differenceLabel.textColor = UIColor.white
				}
			}
		}
	}
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
	var deliveryDays = [DeliveryDay]()
	var deliveryDay: DeliveryDay?
	var deliveryDayViewController: DeliveryDayViewController?
	var deliveries = [Delivery]()
	var drops = [Drop]()
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
	var whoMadeBank: Person?
	var whoClosedBank: Person?
	static var shortcutAction: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBarController?.tabBar.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		keyboardToolbar.backgroundColor = UIColor(red:0.09, green:0.11, blue:0.11, alpha:1.0)
		actuallyReceivedField.delegate = self
		deliveriesCount.delegate = self
		/*if let savedDeliveryDays = loadDeliveryDays() {
		deliveryDays += savedDeliveryDays
		}
		if DeliveryStatisticsTableViewController.shortcutAction == "viewDeliveriesShortcut" || DeliveryStatisticsTableViewController.shortcutAction == "addDeliveryShortcut" {
		self.tabBarController?.selectedIndex = 1
		} else if DeliveryDayTableViewController.status != "adding" {
		let selectedDeliveryDay = deliveryDays[Int(DeliveryDayTableViewController.status)!]
		if selectedDeliveryDay.manual {
		manualDeliverySwitch.isHidden = true
		manualDeliveryDayLabel.isHidden = true
		whoMadeBank = selectedDeliveryDay.whoMadeBankName
		whoClosedBank = selectedDeliveryDay.whoClosedBankName
		actuallyReceivedField.text = selectedDeliveryDay.totalReceivedValue
		deliveriesCount.text = selectedDeliveryDay.deliveryDayCountValue
		calculateManual()
		manualDeliverySwitch.isOn = selectedDeliveryDay.manual
		deliveriesCount.isEnabled = manualDeliverySwitch.isOn
		self.tabBarController?.tabBar.items![1].isEnabled = !manualDeliverySwitch.isOn
		self.tabBarController?.tabBar.items![2].isEnabled = !manualDeliverySwitch.isOn
		addBarButtons()
		} else {
		whoMadeBank = selectedDeliveryDay.whoMadeBankName
		whoClosedBank = selectedDeliveryDay.whoClosedBankName
		actuallyReceivedField.text = selectedDeliveryDay.totalReceivedValue
		manualDeliverySwitch.isHidden = true
		manualDeliveryDayLabel.isHidden = true
		}
		}*/
	}
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
			let totalTipsValue = "$" + "\(String(format: "%.2f", Double(totalReceived)! - totalPaidout))"
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
			let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
			ticketAmountArray.append(ticketAmountRounded)
			let ticketAmountTotaled = ticketAmountArray.reduce(0, + )
			self.ticketAmountFinal = ticketAmountTotaled
			// Sum of amountGiven
			var amountGivenDropped = delivery.amountGivenValue
			amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
			let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
			amountGivenArray.append(amountGivenRounded)
			let amountGivenTotaled = amountGivenArray.reduce(0, + )
			self.amountGivenFinal = amountGivenTotaled
			// Sum of totalTips
			var totalTipsDropped = delivery.totalTipsValue
			totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
			let totalTipsRounded = round(Double(totalTipsDropped)! * 100) / 100
			totalTipsArray.append(totalTipsRounded)
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
			*/} else if segue.identifier == "whoMadeBank" {
			let destination = segue.destination as! PersonTableViewController
			destination.title = "Who Made Bank"
			if let selectedPerson = whoMadeBankLabel.text {
				destination.selectedPerson = selectedPerson
			}
		} else if segue.identifier == "whoClosedBank" {
			let destination = segue.destination as! PersonTableViewController
			destination.title = "Who Closed Bank"
			if let selectedPerson = whoClosedBankLabel.text {
				destination.selectedPerson = selectedPerson
			}
		}
	}
	@IBAction func unwindToDeliveryStatisticsTableList(_ sender: UIStoryboardSegue) {
		/*if let sourceViewController = sender.source as? DeliveryDayViewController, let deliveryDay = sourceViewController.deliveryDay {
		if DeliveryDayTableViewController.status != "adding" {
		let selectedIndexPath = Int(DeliveryDayTableViewController.status)
		deliveryDays[selectedIndexPath!] = deliveryDay
		}
		saveDeliveryDays()
		} else*/ if let sourceViewController = sender.source as? PersonTableViewController, let person = sourceViewController.whoDidBank {
			if sourceViewController.title == "Who Made Bank" {
				self.whoMadeBank = person
			} else if sourceViewController.title == "Who Closed Bank"{
				self.whoClosedBank = person
			}
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
		/*if let savedDeliveries = loadDeliveries() {
		deliveries = savedDeliveries
		for (index, _) in deliveries.enumerated() {
		let delivery = deliveries[index]
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		ticketAmountArray.append(ticketAmountRounded)
		let ticketAmountTotaled = ticketAmountArray.reduce(0, + )
		self.ticketAmountFinal = ticketAmountTotaled
		
		// Sum of amountGiven
		var amountGivenDropped = delivery.amountGivenValue
		amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
		let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
		amountGivenArray.append(amountGivenRounded)
		let amountGivenTotaled = amountGivenArray.reduce(0, + )
		self.amountGivenFinal = amountGivenTotaled
		
		// Sum of cashTips
		var cashTipsDropped = delivery.cashTipsValue
		cashTipsDropped.remove(at: (delivery.cashTipsValue.startIndex))
		let cashTipsRounded = round(Double(cashTipsDropped)! * 100) / 100
		cashTipsArray.append(cashTipsRounded)
		let cashTipsTotaled = cashTipsArray.reduce(0, + )
		self.cashTipsFinal = cashTipsTotaled
		
		// Sum of totalTips
		var totalTipsDropped = delivery.totalTipsValue
		totalTipsDropped.remove(at: (delivery.totalTipsValue.startIndex))
		let totalTipsRounded = round(Double(totalTipsDropped)! * 100) / 100
		if totalTipsRounded > 0.0 {
		totalTipsMinArray.append(totalTipsRounded)
		}
		totalTipsArray.append(totalTipsRounded)
		let totalTipsTotaled = totalTipsArray.reduce(0, + )
		self.totalTipsFinal = totalTipsTotaled
		
		//NoTipSwitchArray
		noTipArray.append(delivery.noTipSwitchValue)
		
		//Payment Method Sales Total
		if delivery.paymentMethod == "1" {
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		cashSalesArray.append(ticketAmountRounded)
		let cashSalesTotaled = cashSalesArray.reduce(0, + )
		self.cashSalesFinal = cashSalesTotaled
		} else if delivery.paymentMethod == "2" {
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		checkSalesArray.append(ticketAmountRounded)
		let checkSalesTotaled = checkSalesArray.reduce(0, + )
		self.checkSalesFinal = checkSalesTotaled
		} else if delivery.paymentMethod == "3" {
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		creditSalesArray.append(ticketAmountRounded)
		let creditSalesTotaled = creditSalesArray.reduce(0, + )
		self.creditSalesFinal = creditSalesTotaled
		} else if delivery.paymentMethod == "4" {
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		chargeSalesArray.append(ticketAmountRounded)
		let chargeSalesTotaled = chargeSalesArray.reduce(0, + )
		self.chargeSalesFinal = chargeSalesTotaled
		var amountGivenDropped = delivery.amountGivenValue
		amountGivenDropped.remove(at: (delivery.amountGivenValue.startIndex))
		let amountGivenRounded = round(Double(amountGivenDropped)! * 100) / 100
		chargeGivenArray.append(amountGivenRounded)
		let chargeGivenTotaled = chargeGivenArray.reduce(0, + )
		self.chargeGivenFinal = chargeGivenTotaled
		} else if delivery.paymentMethod == "5" {
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		otherSalesArray.append(ticketAmountRounded)
		let otherSalesTotaled = otherSalesArray.reduce(0, + )
		self.otherSalesFinal = otherSalesTotaled
		}
		if delivery.noTipSwitchValue == "true" {
		var ticketAmountDropped = delivery.ticketAmountValue
		ticketAmountDropped.remove(at: (delivery.ticketAmountValue.startIndex))
		let ticketAmountRounded = round(Double(ticketAmountDropped)! * 100) / 100
		noTipSalesArray.append(ticketAmountRounded)
		let noTipSalesTotaled = noTipSalesArray.reduce(0, + )
		self.noTipSalesFinal = noTipSalesTotaled
		}
		}
		}
		//		if let savedDrops = loadDrops() {
		//			drops = savedDrops
		//			for (index, _) in drops.enumerated() {
		//				let drop = drops[index]
		//				totalDropsArray.append(drop.amount)
		//				let totalDropsTotaled = totalDropsArray.reduce(0, +)
		//				self.totalDropsFinal = totalDropsTotaled
		//			}
		//		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMddyy"
		let dateFormatted = dateFormatter.date(from: DeliveryDayViewController.selectedDateGlobal)
		dateFormatter.dateFormat = "MM/dd/yy"
		let dateFormattedFinal = dateFormatter.string(from: dateFormatted!)
		var startingBankDropped: String = startingBankField.text ?? "$0.00"
		startingBankDropped.remove(at: (startingBankField.text?.startIndex)!)
		let ticketAmountAverage = ticketAmountArray.reduce(0.0) {
		return $0 + $1 / Double(ticketAmountArray.count)
		}
		let totalTipsAverage = totalTipsArray.reduce(0.0) {
		return $0 + $1 / Double(totalTipsArray.count)
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
		if manualDeliverySwitch.isOn {
		whoMadeBankLabel.text = whoMadeBank
		whoClosedBankLabel.text = whoClosedBank
		} else if deliveries.count != 0 {
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
		tipsMinLabel.text = "$" + "\(String(format: "%.2f", totalTipsMinArray.min()!))"
		noTipCountLabel.text = String(self.noTipArrayCount)
		noTipSalesLabel.text = "$" + "\(String(format: "%.2f", noTipSalesFinal))"
		let tips = self.amountGivenFinal - self.ticketAmountFinal + self.cashTipsFinal
		let paidOut = Double(self.deliveries.count) * 1.25
		let shouldRecieve = tips + paidOut
		let shouldRecieveRounded = round(shouldRecieve * 100) / 100
		let actuallyReceived = Double(self.removeFirstCharactersFrom(inputString: self.actuallyReceivedField.text!))
		let actuallyReceivedRounded = round(actuallyReceived! * 100) / 100
		let difference = actuallyReceivedRounded - shouldRecieveRounded
		let differenceRounded = round(difference * 100) / 100
		differenceLabel.text = "$" + "\(String(format: "%.2f", differenceRounded))"
		if differenceRounded < 0 {
		differenceLabel.textColor = UIColor.red
		} else {
		differenceLabel.textColor = UIColor.white
		}
		}
		bankBalanceLabel.text = "$" + "\(String(format: "%.2f", bankBalance))"
		totalDropsLabel.text = "$" + "\(String(format: "%.2f", totalDropsFinal))"
		amountShouldRecieveBankDetailsLabel.text = "$" + "\(String(format: "%.2f", amountShouldReceive))"
		}
		currentDeliverDayDateLabel.text = dateFormattedFinal
		self.tabBarController?.tabBar.items![1].badgeValue = String(deliveries.count)
		self.tabBarController?.tabBar.items![2].badgeValue = String(drops.count)*/
		whoMadeBankLabel.text = whoMadeBank?.name
		whoClosedBankLabel.text = whoClosedBank?.name
	}
	func calculateManual() {
		if manualDeliverySwitch.isOn {
			let numberOfDeliveries: Double = Double(deliveriesCount.text!)!
			let totalPaidout = numberOfDeliveries * 1.25
			let totalReceived = removeFirstCharactersFrom(inputString: actuallyReceivedField.text!)
			let totalTips = Double(totalReceived)! - totalPaidout
			totalTipsLabel.text = "$" + "\(String(format: "%.2f", totalTips))"
			paidoutLabel.text = "$" + "\(String(format: "%.2f", totalPaidout))"
		}
	}
	let keyboardToolbar = UIToolbar()
	let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryStatisticsTableViewController.goToPreviousField))
	let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryStatisticsTableViewController.goToNextField))
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
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	// MARK: NSCoding
	
	
}
