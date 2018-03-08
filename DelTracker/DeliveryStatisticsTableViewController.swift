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
	@IBOutlet var noTipCountLabel: UILabel!
	@IBOutlet var amountShouldRecieveTotalsLabel: UILabel!
	@IBOutlet var paidoutLabel: UILabel!
	@IBOutlet var totalSalesLabel: UILabel!
	@IBOutlet var totalAmountGivenLabel: UILabel!
	@IBOutlet var totalTipsLabel: UILabel!
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
	@IBOutlet var noTipSalesLabel: UILabel!
	@IBOutlet var totalDropsLabel: UILabel!
	@IBOutlet var whoMadeBankLabel: UILabel!
	@IBOutlet var whoClosedBankLabel: UILabel!
	@IBOutlet var bankBalanceLabel: UILabel!
	@IBOutlet var currentDeliverDayDateLabel: UILabel!
	@IBOutlet var startingBankField: CurrencyField!
	@IBOutlet var amountShouldRecieveBankDetailsLabel: UILabel!
	@IBOutlet var actuallyReceivedField: CurrencyField!
	@IBOutlet var differenceLabel: UILabel!
	
	// MARK: StoryBoard Actions
	
	@IBAction func manualDeliverySwitchChanged(_ sender: Any) {
		deliveriesCount.isEnabled = manualDeliverySwitch.isOn
		deliveryDay?.manual = manualDeliverySwitch.isOn
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
		loadTableData()
	}
	@IBAction func ReceivedTextFieldEditingEnded(_ sender: UITextField) {
		loadTableData()
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
	var ticketAmountFinal: [NSDictionary]?
	var amountGivenFinal: [NSDictionary]?
	var cashTipsFinal: [NSDictionary]?
	var totalTipsFinal: [NSDictionary]?
	var totalDropsFinal: [NSDictionary]?
	var noneSalesFinal: [NSDictionary]?
	var cashSalesFinal: [NSDictionary]?
	var checkSalesFinal: [NSDictionary]?
	var creditSalesFinal: [NSDictionary]?
	var chargeSalesFinal: [NSDictionary]?
	var chargeGivenFinal: [NSDictionary]?
	var otherSalesFinal: [NSDictionary]?
	var noTipSalesFinal: [NSDictionary]?
	static var startingBank = 0.0
	var totalTicketAmount = 0.0
	var averageTicketAmount = 0.0
	var minTicketAmount = 0.0
	var maxTicketAmount = 0.0
	var whoMadeBank: Person?
	var whoClosedBank: Person?
	var sender: String?
	var saved: Bool = false
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
			manualDeliverySwitch.isOn = deliveryDay.manual
			manualDeliverySwitch.isHidden = !deliveryDay.manual
			manualDeliverySwitch.isUserInteractionEnabled = !deliveryDay.manual
			manualDeliveryDayLabel.isHidden = !deliveryDay.manual
			deliveriesCount.isUserInteractionEnabled = !deliveryDay.manual
			whoMadeBankLabel.text = deliveryDay.whoMadeBank
			whoClosedBankLabel.text = deliveryDay.whoClosedBank
			actuallyReceivedField.text = deliveryDay.totalReceived.convertToCurrency()
			currentDeliverDayDateLabel.text = deliveryDay.date?.convertToDateString()
			differenceLabel.checkForNegative()
			loadTableData()
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		loadTableData()
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	/*func loadTableData() {
		guard let context = mainContext else {
			return
		}
		
		let deliveryDayPredicate = NSPredicate(format: "deliveryDay == %@", deliveryDay!)
		let noTipCountRequest = NSFetchRequest<NSNumber>(entityName: "Delivery")
		let noTipPredicate = NSPredicate(format: "noTip == %@", "1")
		noTipCountRequest.resultType = .countResultType
		noTipCountRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [deliveryDayPredicate, noTipPredicate])
		
		var dropAmountFinal: Double = 0
		var dropAmountArray: [Double] = []
		var dropCount: Double?
		if let drops = deliveryDay?.drops?.array as? [Drop] {
			dropCount = Double((deliveryDay?.drops?.count)!)
			for (index, _) in drops.enumerated() {
				let drop = drops[index]
				dropAmountFinal += drop.amount
				dropAmountArray.append(drop.amount)
			}
			self.totalDropsLabel.text = dropAmountFinal.convertToCurrency()
		}
		self.tabBarController?.tabBar.items![2].badgeValue = "\(Int(dropCount!))"
		var ticketAmountFinal: Double = 0
		var ticketAmountArray: [Double] = []
		var amountGivenFinal: Double = 0
		var amountGivenArray: [Double] = []
		var cashTipsFinal: Double = 0
		var cashTipsArray: [Double] = []
		var totalTipsFinal: Double = 0
		var totalTipsArray: [Double] = []
		var noTipSalesFinal: Double = 0
		var noTipSalesArray: [Double] = []
		var noneSalesFinal: Double = 0
		var noneSalesArray: [Double] = []
		var cashSalesFinal: Double = 0
		var cashSalesArray: [Double] = []
		var checkSalesFinal: Double = 0
		var checkSalesArray: [Double] = []
		var creditSalesFinal: Double = 0
		var creditSalesArray: [Double] = []
		var chargeSalesFinal: Double = 0
		var chargeSalesArray: [Double] = []
		var otherSalesFinal: Double = 0
		var otherSalesArray: [Double] = []
		var deliveryCount: Double?
		if let deliveries = deliveryDay?.deliveries?.array as? [Delivery] {
			deliveryCount = Double((deliveryDay?.deliveries?.count)!)
			self.deliveriesCount.text = "\(Int(deliveryCount!))"
			self.tabBarController?.tabBar.items![1].badgeValue = "\(Int(deliveryCount!))"
			for (index, _) in deliveries.enumerated() {
				let delivery = deliveries[index]
				ticketAmountFinal += delivery.ticketAmount
				ticketAmountArray.append(delivery.ticketAmount)
				amountGivenFinal += delivery.amountGiven
				amountGivenArray.append(delivery.amountGiven)
				cashTipsFinal += delivery.cashTips
				cashTipsArray.append(delivery.cashTips)
				if !delivery.noTip {
					totalTipsFinal += delivery.totalTips
					totalTipsArray.append(delivery.totalTips)
				} else {
					noTipSalesFinal += delivery.ticketAmount
					noTipSalesArray.append(delivery.ticketAmount)
				}
				switch delivery.paymentMethod {
				case 0:
					noneSalesFinal += delivery.ticketAmount
					noneSalesArray.append(delivery.ticketAmount)
				case 1:
					cashSalesFinal += delivery.ticketAmount
					cashSalesArray.append(delivery.ticketAmount)
				case 2:
					checkSalesFinal += delivery.ticketAmount
					checkSalesArray.append(delivery.ticketAmount)
				case 3:
					creditSalesFinal += delivery.ticketAmount
					creditSalesArray.append(delivery.ticketAmount)
				case 4:
					chargeSalesFinal += delivery.ticketAmount
					chargeSalesArray.append(delivery.ticketAmount)
				case 5:
					otherSalesFinal += delivery.ticketAmount
					otherSalesArray.append(delivery.ticketAmount)
				default:
					print("default")
				}
			}
		}
		self.salesAverageLabel.text = ticketAmountArray.getAverageMinMax(ticketAmountFinal).avg.convertToCurrency()
		self.salesMinLabel.text = ticketAmountArray.getAverageMinMax(ticketAmountFinal).min.convertToCurrency()
		self.salesMaxLabel.text = ticketAmountArray.getAverageMinMax(ticketAmountFinal).max.convertToCurrency()
		self.totalSalesLabel.text = ticketAmountFinal.convertToCurrency()
		totalAmountGivenLabel.text = amountGivenFinal.convertToCurrency()
		totalTipsLabel.text = totalTipsFinal.convertToCurrency()
		salesAverageLabel.text = ticketAmountArray.getAverageMinMax(ticketAmountFinal).avg.convertToCurrency()
		salesMinLabel.text = ticketAmountArray.getAverageMinMax(ticketAmountFinal).min.convertToCurrency()
		salesMaxLabel.text = ticketAmountArray.getAverageMinMax(ticketAmountFinal).max.convertToCurrency()
		cashSalesLabel.text = cashSalesFinal.convertToCurrency()
		checkSalesLabel.text = checkSalesFinal.convertToCurrency()
		creditSalesLabel.text = creditSalesFinal.convertToCurrency()
		chargeSalesLabel.text = chargeSalesFinal.convertToCurrency()
		otherSalesLabel.text = otherSalesFinal.convertToCurrency()
		tipsAverageLabel.text = totalTipsArray.getAverageMinMax(totalTipsFinal).avg.convertToCurrency()
		tipsMinLabel.text = totalTipsArray.getAverageMinMax(totalTipsFinal).min.convertToCurrency()
		tipsMaxLabel.text = totalTipsArray.getAverageMinMax(totalTipsFinal).max.convertToCurrency()
		noTipSalesLabel.text = noTipSalesFinal.convertToCurrency()
		do {
			let noTipCountResult = try context.fetch(noTipCountRequest)
			let noTipCount = noTipCountResult.first?.doubleValue
			self.noTipCountLabel.text = "\(Int(noTipCount!))"
		} catch let nserror as NSError {
			let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		
		let paidout = deliveryCount! * 1.25
		self.paidoutLabel.text = paidout.convertToCurrency()
		
		let amountShouldReceive = paidout + totalTipsFinal
		self.amountShouldRecieveTotalsLabel.text = amountShouldReceive.convertToCurrency()
		self.amountShouldRecieveBankDetailsLabel.text = amountShouldReceive.convertToCurrency()
		
		if let actuallyReceived = self.actuallyReceivedField.text?.removeDollarSign() {
			let difference = actuallyReceived - amountShouldReceive
			self.differenceLabel.text = difference.convertToCurrency()
			self.differenceLabel.checkForNegative()
			self.deliveryDay?.totalReceived = actuallyReceived
		}
		if let startingBankBalance = self.startingBankField.text?.removeDollarSign() {
			DeliveryStatisticsTableViewController.startingBank = startingBankBalance
			let bankBalance = startingBankBalance + ticketAmountFinal - chargeSalesFinal - dropAmountFinal
			self.bankBalanceLabel.text = bankBalance.convertToCurrency()
		}
		if let deliveryDay = self.deliveryDay {
			if !deliveryDay.manual {
				self.manualDeliverySwitch.isHidden = !deliveryDay.manual
				self.manualDeliverySwitch.isUserInteractionEnabled = !deliveryDay.manual
				self.manualDeliveryDayLabel.isHidden = !deliveryDay.manual
				self.deliveriesCount.isUserInteractionEnabled = !deliveryDay.manual
			}
			self.whoMadeBankLabel.text = deliveryDay.whoMadeBank
			self.whoClosedBankLabel.text = deliveryDay.whoClosedBank
			self.actuallyReceivedField.text = deliveryDay.totalReceived.convertToCurrency()
			self.currentDeliverDayDateLabel.text = deliveryDay.date?.convertToDateString()
			self.differenceLabel.checkForNegative()
		}
		
		if self.sender == "Who Made Bank" {
			self.whoMadeBankLabel.text = deliveryDay?.whoMadeBank
		} else if self.sender == "Who Closed Bank" {
			self.whoClosedBankLabel.text = deliveryDay?.whoClosedBank
		}
		if manualDeliverySwitch.isOn {
			if self.sender == "Who Made Bank" {
				whoMadeBankLabel.text = deliveryDay?.whoMadeBank
			} else if self.sender == "Who Closed Bank" {
				self.whoClosedBankLabel.text = deliveryDay?.whoClosedBank
			} else if let deliveryDay = deliveryDay {
				deliveryDay.manual = manualDeliverySwitch.isOn
				deliveriesCount.text = "\(deliveryDay.count)"
				whoMadeBankLabel.text = deliveryDay.whoMadeBank
				whoClosedBankLabel.text = deliveryDay.whoClosedBank
				actuallyReceivedField.text = deliveryDay.totalReceived.convertToCurrency()
				currentDeliverDayDateLabel.text = deliveryDay.date?.convertToDateString()
			}
		}
	}*/
	
	
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
		if manualDeliverySwitch.isOn {
		}
		if segue.identifier == "whoMadeBank" {
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
		} else if let destination = segue.destination as? DeliveryDayTableViewController {
			destination.navigationController?.isNavigationBarHidden = false
			deliveryDay?.date = deliveryDay?.date
			deliveryDay?.totalTips = (totalTipsLabel.text?.removeDollarSign())!
			deliveryDay?.whoMadeBank = whoMadeBankLabel.text
			deliveryDay?.whoClosedBank = whoClosedBankLabel.text
			deliveryDay?.totalReceived = (actuallyReceivedField.text?.removeDollarSign())!
			deliveryDay?.manual = false
			do {
				try mainContext?.save()
			} catch {
				let nserror = error as NSError
				func printToConsole() {
					print("Unresolved error \(nserror), \(nserror.userInfo)")
				}
				let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
				let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)
				let printAction = UIAlertAction(title: "Print", style: UIAlertActionStyle.default, handler: {
					action in printToConsole()
				})
				alert.addAction(okayAction)
				alert.addAction(printAction)
				self.present(alert, animated: true, completion: nil)
			}

		}
	}
	@IBAction func unwindToDeliveryStatisticsTableList(_ sender: UIStoryboardSegue) {
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
    @objc func goToPreviousField(_: Any?) {
		if actuallyReceivedField.isFirstResponder {
			actuallyReceivedField.resignFirstResponder()
			deliveriesCount.becomeFirstResponder()
			deliveriesCount.selectedTextRange = deliveriesCount.textRange(from: deliveriesCount.beginningOfDocument, to: deliveriesCount.endOfDocument)
			previousBarButton.isEnabled = false
			nextBarButton.isEnabled = true
		}
	}
    @objc func goToNextField() {
		if deliveriesCount.isFirstResponder {
			deliveriesCount.resignFirstResponder()
			actuallyReceivedField.becomeFirstResponder()
			actuallyReceivedField.selectedTextRange = actuallyReceivedField.textRange(from: actuallyReceivedField.beginningOfDocument, to: actuallyReceivedField.endOfDocument)
			previousBarButton.isEnabled = true
			nextBarButton.isEnabled = false
		}
	}
}
