//
//  DeliveryViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class DeliveryViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate, BarcodeDelegate {
	
	// MARK: - Storyboard Actions
	
	@IBAction func ticketNumberEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = false
		nextBarButton.isEnabled = true
		ticketNumberField.selectAllText()
	}
	@IBAction func ticketNumberChanged(_ sender: UITextField) {
		if ticketNumberField.text?.count == 3 {
			ticketNumberField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
			ticketAmountField.selectAllText()
		}
	}
	@IBAction func ticketAmountEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = true
		ticketAmountField.selectAllText()
	}
	@IBAction func ticketAmountEditingEnded(_ sender: UITextField) {
		amountGivenField.isEnabled = true
		amountGivenField.isUserInteractionEnabled = true
	}
	@IBAction func amountGivenEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = true
		amountGivenField.selectAllText()
	}
	@IBAction func amountGivenEditingEnded(_ sender: UITextField) {
		calculateTips()
		cashTipsField?.isEnabled = true
		cashTipsField?.isUserInteractionEnabled = true
	}
	@IBAction func cashTipsEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = false
		cashTipsField?.selectAllText()
	}
	@IBAction func cashTipsEditingEnded(_ sender: UITextField) {
		calculateTips()
	}
	@IBAction func saveDelivery(_ sender: UIBarButtonItem) {
		calculateTips()
		OperationQueue.main.addOperation() {
			self.activityIndicator(msg: "   Saving...", true)
		}
		saveDelivery()
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func cancelAdd(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func overrideDeliveryTimeChanged(_ sender: UISwitch) {
		if timeOverrideSwitch.isOn {
			deliveryTime.isEnabled = true
			setTimeToNowButton?.isEnabled = true
		} else {
			if let delivery = delivery {
				if let date = delivery.deliveryTime {
					deliveryTime.setDate(date as Date, animated: true)
				}
			}
		}
	}
	@IBAction func setTimeToNowBarButton(_ sender: Any) {
		deliveryTime.setDate(NSDate() as Date, animated: true)
	}
	@IBAction func toggle(_ sender: Any) {
		toggleFlash()
	}
	
	// MARK: - Storyboard Outlets
	
	@IBOutlet var ticketNumberField: UITextField!
	@IBOutlet var viewTicketPhoto: UIButton!
	@IBOutlet var ticketAmountField: CurrencyField!
	@IBOutlet var quickTipSelector: UISegmentedControl!
	@IBOutlet var noTipSwitch: UISwitch!
	@IBOutlet var amountGivenField: CurrencyField!
	@IBOutlet var cashTipsField: CurrencyField?
	@IBOutlet var totalTips: UILabel!
	@IBOutlet var paymentMethodPicker: UIPickerView!
	@IBOutlet var setTimeToNowButton: UIBarButtonItem!
	@IBOutlet var timeOverrideSwitch: UISwitch!
	@IBOutlet var deliveryTime: UIDatePicker!
	
	// MARK: Vairables and Constants
	
	var delivery: Delivery?
	var deliveryDay: DeliveryDay?
	var selectedTime: Date = NSDate() as Date
	var light: Bool = false
	static var ticketPhoto: UIImage? = nil
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	var paymentMethodDataSource = ["None", "Cash", "Check", "Credit", "Charge", "Other"]
	let keyboardToolbar = UIToolbar()
	let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToPreviousField))
	let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToNextField))
	let doubleZero = UIButton(type: UIButtonType.custom)
	var mainContext: NSManagedObjectContext? = nil
	
	// MARK: - View Life Cycle
	
	func showIndicator(_ sender: UIBarButtonItem) {
		activityIndicator(msg: "   Saving...", true)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		if delivery != nil {
			navigationItem.title = "Edit Delivery"
		} else {
			navigationItem.title = "Add Delivery"
		}
		ticketNumberField.delegate = self
		ticketAmountField.delegate = self
		amountGivenField.delegate = self
		cashTipsField?.delegate = self
		configureTicketNumberField()
		configureTicketAmountField()
		configureNoTipSwitch()
		configureDoubleZeroButtonKey()
		addBarButtons()
		configureQuickTipSegmentControl()
		deliveryTime.setValue(UIColor.white, forKey: "textColor")
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		if let delivery = delivery {
			ticketNumberField.text = "\(delivery.ticketNumber)"
			ticketAmountField.text = delivery.ticketAmount.convertToCurrency()
			noTipSwitch.isOn = delivery.noTip
			amountGivenField.text = delivery.amountGiven.convertToCurrency()
			cashTipsField?.text = delivery.cashTips.convertToCurrency()
			totalTips.text = delivery.totalTips.convertToCurrency()
			if let ticketPhoto = delivery.ticketPhoto {
				DeliveryViewController.ticketPhoto = UIImage(data: ticketPhoto as Data)
			}
			paymentMethodPicker.selectRow(Int(delivery.paymentMethod), inComponent: 0, animated: true)
			if let date = delivery.deliveryTime {
				deliveryTime.setDate(date as Date, animated: true)
				deliveryTime.isEnabled = false
				setTimeToNowButton?.isEnabled = false
			}
		}
		if light {
			toggleFlash()
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		ticketNumberField.resignFirstResponder()
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		ticketNumberField.resignFirstResponder()
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
		if segue.identifier == "scan" {
			let barcodeViewController: BarcodeViewController = segue.destination as! BarcodeViewController
			barcodeViewController.delegate = self
		} else if segue.identifier == "viewPhoto" {
			let ticketPhotoViewController = segue.destination as! TicketPhotoViewController
			if let ticketPhoto = DeliveryViewController.ticketPhoto {
				ticketPhotoViewController.ticketPhoto = ticketPhoto
			}
		}
		if let destination = segue.destination as? DeliveryTableViewController {
			destination.navigationController?.tabBarController?.tabBar.isHidden = false
		}
	}
	func barcodeRead(barcode: String, light: Bool, photo: UIImage?) {
		self.ticketNumberField.delegate = self
		if light {
			self.light = light
		}
		DeliveryViewController.ticketPhoto = photo
		ticketNumberField.text = barcode
		viewTicketPhoto.isEnabled = true
		ticketAmountField.becomeFirstResponder()
	}
	func toggleFlash() {
		if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
			do {
				try device.lockForConfiguration()
				let torchOn = !device.isTorchActive
				try device.setTorchModeOnWithLevel(1.0)
				device.torchMode = torchOn ? .on : .off
				device.unlockForConfiguration()
			} catch {
				print("error")
			}
		}
	}
	
	// MARK: - CoreData
	
	func saveDelivery() {
		guard let mainContext = mainContext else {
			return
		}
		if let ticketNumber = ticketNumberField.text, var ticketAmount = ticketAmountField.text, var amountGiven = amountGivenField.text, var cashTips = cashTipsField?.text, var totalTips = totalTips.text {
			if delivery == nil {
				let newDelivery = Delivery(context: mainContext)
				if self.navigationItem.title == "Add Delivery" {
					if !timeOverrideSwitch.isOn {
						deliveryTime.setDate(NSDate() as Date, animated: true)
					}
				}
				newDelivery.ticketNumber = Int16(ticketNumber)!
				newDelivery.ticketAmount = ticketAmount.removeDollarSign()
				newDelivery.noTip = noTipSwitch.isOn
				newDelivery.amountGiven = amountGiven.removeDollarSign()
				newDelivery.cashTips = cashTips.removeDollarSign()
				newDelivery.totalTips = totalTips.removeDollarSign()
				if timeOverrideSwitch.isOn {
                    let overrideDate = deliveryTime.date.setDateOfTime((deliveryDay?.date)! as NSDate)
                    newDelivery.deliveryTime = overrideDate
				} else {
                    newDelivery.deliveryTime = deliveryTime.date as NSDate
				}
				newDelivery.paymentMethod = Int16(paymentMethodPicker.selectedRow(inComponent: 0))
				if let ticketPhoto = DeliveryViewController.ticketPhoto {
					let ticketPhotoData = UIImageJPEGRepresentation(ticketPhoto, 0.25)
                    newDelivery.ticketPhoto = ticketPhotoData as NSData?
				}
				delivery = newDelivery
			}
			if let delivery = delivery {
				delivery.ticketNumber = Int16(ticketNumber)!
				delivery.ticketAmount = ticketAmount.removeDollarSign()
				delivery.noTip = noTipSwitch.isOn
				delivery.amountGiven = amountGiven.removeDollarSign()
				delivery.cashTips = cashTips.removeDollarSign()
				delivery.totalTips = totalTips.removeDollarSign()
                delivery.deliveryTime = deliveryTime.date as NSDate
				delivery.paymentMethod = Int16(paymentMethodPicker.selectedRow(inComponent: 0))
				delivery.deliveryDay = deliveryDay
				deliveryDay?.addToDeliveries(delivery)
				if let ticketPhoto = DeliveryViewController.ticketPhoto {
					let ticketPhotoData = UIImageJPEGRepresentation(ticketPhoto, 0.25)
                    delivery.ticketPhoto = ticketPhotoData as NSData?
				}
				do {
					try mainContext.save()
				} catch {
					self.messageFrame.removeFromSuperview()
					let nserror = error as NSError
					//let alert = UIAlertController(title: "Error", message: "Unresolved error \(nserror), \(nserror.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
					//alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
					//self.present(alert, animated: true, completion: nil)
					print("Unresolved error \(nserror), \(nserror.userInfo)")
				}
				self.messageFrame.removeFromSuperview()
				_ = navigationController?.popViewController(animated: true)
			}
		}
	}
	
	// MARK: - Configuration
	
	func configureTicketNumberField() {
		ticketNumberField?.clearsOnInsertion = true
	}
	func configureTicketAmountField() {
		ticketNumberField.clearsOnInsertion = true
	}
	func configureQuickTipSegmentControl() {
		quickTipSelector.addTarget(self, action: #selector(DeliveryViewController.selectedSegmentDidChange(_: )), for: .valueChanged)
	}
	func configureNoTipSwitch() {
		noTipSwitch.setOn(false, animated: true)
		noTipSwitch.addTarget(self, action: #selector(DeliveryViewController.switchValueDidChange(_: )), for: .valueChanged)
	}
	func configureDoubleZeroButtonKey() {
		doubleZero.setTitle("00", for: UIControlState())
		doubleZero.titleLabel?.font = UIFont.systemFont(ofSize: 24)
		doubleZero.setTitleColor(UIColor.white, for: UIControlState())
		doubleZero.frame = CGRect(x: 0, y: 115, width: 137, height: 56)
		doubleZero.adjustsImageWhenHighlighted = true
		doubleZero.addTarget(self, action: #selector(DeliveryViewController.doubleZero(_: )), for: UIControlEvents.touchUpInside)
		doubleZero.setBackgroundColor(UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0), forState: UIControlState.highlighted)
	}
	
	
	// Quick Tip Segment Control
    @objc func selectedSegmentDidChange(_ segmentedControl: UISegmentedControl) {
		if segmentedControl.selectedSegmentIndex == 0 {
			cashTipsField?.text = "$5.00"
			segmentControlSelected()
		} else if segmentedControl.selectedSegmentIndex == 1 {
			cashTipsField?.text = "$4.00"
			segmentControlSelected()
		} else if segmentedControl.selectedSegmentIndex == 2 {
			cashTipsField?.text = "$3.00"
			segmentControlSelected()
		} else if segmentedControl.selectedSegmentIndex == 3 {
			cashTipsField?.text = "$2.00"
			segmentControlSelected()
		} else if segmentedControl.selectedSegmentIndex == 4 {
			cashTipsField?.text = "$1.00"
			segmentControlSelected()
		} else if segmentedControl.selectedSegmentIndex == 5 {
			cashTipsField?.text = "$0.00"
			cashTipsField?.isEnabled = true
			amountGivenField.isEnabled = true
			noTipSwitch?.isEnabled = true
			calculateTips()
		}
	}
	func segmentControlSelected() {
		cashTipsField?.isEnabled = false
		amountGivenField.isEnabled = false
		amountGivenField.text = ticketAmountField.text
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
		noTipSwitch.isOn = false
		noTipSwitch?.isEnabled = false
		calculateTips()
		if paymentMethodPicker.selectedRow(inComponent: 0) == 1 {
			calculateCashTips(cashPaymentMethod: true)
		} else {
			calculateCashTips(cashPaymentMethod: false)
		}
	}
	
	// Payment Method PickerView
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return paymentMethodDataSource.count;
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return paymentMethodDataSource[row]
	}
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		let titleData = paymentMethodDataSource[row]
		let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName: UIFont(name: "System", size: 15.0) as Any, NSForegroundColorAttributeName: UIColor.white])
		return myTitle
	}
	func paymentMethodChanged() {
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
		calculateTips()
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if row == 0 {
			//calculateCashTips(cashPaymentMethod: false)
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
		} else if row == 1 {
			if quickTipSelector.selectedSegmentIndex != 5 {
				calculateCashTips(cashPaymentMethod: true)
			}
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			paymentMethodChanged()
		} else if row == 2 {
			//calculateCashTips(cashPaymentMethod: false)
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			paymentMethodChanged()
		} else if row == 3 {
			//calculateCashTips(cashPaymentMethod: false)
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			paymentMethodChanged()
		} else if row == 4 {
			//calculateCashTips(cashPaymentMethod: false)
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			paymentMethodChanged()
		} else if row == 5 {
			//calculateCashTips(cashPaymentMethod: false)
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			paymentMethodChanged()
		}
	}
	func calculateCashTips(cashPaymentMethod: Bool) {
		if cashPaymentMethod {
			let ticketAmount = ticketAmountField.text?.removeDollarSign() ?? 0.0
			var amountGiven = amountGivenField.text?.removeDollarSign() ?? 0.0
			switch quickTipSelector.selectedSegmentIndex {
			case 0:
				amountGiven = ticketAmount + 5.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			case 1:
				amountGiven = ticketAmount + 4.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			case 2:
				amountGiven = ticketAmount + 3.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			case 3:
				amountGiven = ticketAmount + 2.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			case 4:
				amountGiven = ticketAmount + 1.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			case 5:
				amountGiven = ticketAmount + 0.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			default:
				amountGiven = ticketAmount + 0.0
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			}
		} else {
			let ticketAmount = ticketAmountField.text?.removeDollarSign() ?? 0.0
			var amountGiven = amountGivenField.text?.removeDollarSign() ?? 0.0
			switch quickTipSelector.selectedSegmentIndex {
			case 0:
				amountGiven = ticketAmount
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$5.00"
			case 1:
				amountGiven = ticketAmount
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$4.00"
			case 2:
				amountGiven = ticketAmount
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$3.00"
			case 3:
				amountGiven = ticketAmount
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$2.00"
			case 4:
				amountGiven = ticketAmount
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$1.00"
			case 5:
				if cashTipsField?.text == "$0.00" {
					amountGiven = ticketAmount
					amountGivenField.text = amountGiven.convertToCurrency()
					cashTipsField?.text = "$0.00"
				}
			default:
				amountGiven = ticketAmount
				amountGivenField.text = amountGiven.convertToCurrency()
				cashTipsField?.text = "$0.00"
			}
		}
	}
	
	// Toolbar Previous and Next Buttons
    @objc func goToPreviousField(_: Any?) {
		if ticketAmountField.isFirstResponder {
			ticketAmountField.resignFirstResponder()
			ticketNumberField.becomeFirstResponder()
			ticketNumberField.selectAllText()
		} else if amountGivenField.isFirstResponder {
			amountGivenField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
			ticketAmountField.selectAllText()
		} else if (cashTipsField?.isFirstResponder)! {
			cashTipsField?.resignFirstResponder()
			amountGivenField.becomeFirstResponder()
			amountGivenField.selectAllText()
		}
	}
    @objc func goToNextField() {
		if ticketNumberField.isFirstResponder {
			previousBarButton.isEnabled = true
			ticketNumberField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
			ticketAmountField.selectAllText()
		} else if ticketAmountField.isFirstResponder {
			ticketAmountField.resignFirstResponder()
			if quickTipSelector.selectedSegmentIndex == 5 {
				amountGivenField.isEnabled = true
				amountGivenField.becomeFirstResponder()
				amountGivenField.selectAllText()
			}
		} else if amountGivenField.isFirstResponder {
			amountGivenField.resignFirstResponder()
			cashTipsField?.isEnabled = true
			cashTipsField?.becomeFirstResponder()
			cashTipsField?.selectAllText()
		}
	}
    @objc func doubleZero(_ sender: UIButton) {
		if ticketAmountField.isFirstResponder {
			ticketAmountField.insertText("00")
			ticketAmountField.resignFirstResponder()
			amountGivenField.becomeFirstResponder()
			amountGivenField.selectAllText()
		} else if amountGivenField.isFirstResponder {
			amountGivenField.insertText("00")
			amountGivenField.resignFirstResponder()
		} else if (cashTipsField?.isFirstResponder)! {
			cashTipsField?.insertText("00")
			cashTipsField?.resignFirstResponder()
		}
	}
	// UITextField Navigation Bar
	func addBarButtons() {
		nextBarButton.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		previousBarButton.tintColor = UIColor(red:1.00, green:0.54, blue:0.01, alpha:1.0)
		keyboardToolbar.barTintColor = UIColor(red:0.09, green:0.11, blue:0.11, alpha:1.0)
		keyboardToolbar.sizeToFit()
		keyboardToolbar.items = [flexBarButton, previousBarButton, nextBarButton]
		ticketAmountField.inputAccessoryView = keyboardToolbar
		ticketNumberField.inputAccessoryView = keyboardToolbar
		amountGivenField.inputAccessoryView = keyboardToolbar
		cashTipsField?.inputAccessoryView = keyboardToolbar
	}
	
	// MARK: - Actions
	
	func textFieldDidBeginEditing(_: UITextField) {
		NotificationCenter.default.addObserver(self, selector: #selector(DeliveryViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}
    @objc func keyboardWillShow(_ note: Notification) -> Void {
		DispatchQueue.main.async { () -> Void in
			self.doubleZero.isHidden = false
			let keyBoardWindow = UIApplication.shared.windows.last
			self.doubleZero.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-57, width: 137, height: 57)
			keyBoardWindow?.addSubview(self.doubleZero)
			keyBoardWindow?.bringSubview(toFront: self.doubleZero)
			UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0) }, completion: { (complete) -> Void in })
		}
	}
	func calculateTips() {
		if cashTipsField?.text != nil {
			var amountGiven = amountGivenField.text ?? "$0.00"
			var ticketAmount = ticketAmountField.text ?? "$0.00"
			var cashTips = cashTipsField?.text ?? "$0.00"
			totalTips.text = (amountGiven.removeDollarSign() - ticketAmount.removeDollarSign() + cashTips.removeDollarSign()).convertToCurrency()
		} else {
			var amountGiven = amountGivenField.text ?? "$0.00"
			var ticketAmount = ticketAmountField.text ?? "$0.00"
			totalTips.text = (amountGiven.removeDollarSign() - ticketAmount.removeDollarSign()).convertToCurrency()
		}
	}
    @objc func switchValueDidChange(_ aSwitch: UISwitch) {
		if noTipSwitch.isOn {
			delivery?.noTip = noTipSwitch.isOn
			amountGivenField.text = ticketAmountField.text
			cashTipsField?.text = "$0.00"
			amountGivenField.isEnabled = false
			cashTipsField?.isEnabled = false
			calculateTips()
		} else {
			delivery?.noTip = noTipSwitch.isOn
			amountGivenField.isEnabled = true
			cashTipsField?.isEnabled = true
			calculateTips()
		}
	}
	
	// Dismissing Keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	func activityIndicator(msg: String, _ indicator: Bool ) {
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
		view.bringSubview(toFront: strLabel)
		view.addSubview(messageFrame)
		view.bringSubview(toFront: messageFrame)
	}
}
