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
		removeFirstCharacterAndCalculate()
		cashTipsField?.isEnabled = true
		cashTipsField?.isUserInteractionEnabled = true
	}
	@IBAction func cashTipsEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = false
		cashTipsField?.selectAllText()
	}
	@IBAction func cashTipsEditingEnded(_ sender: UITextField) {
		removeFirstCharacterAndCalculate()
	}
	@IBAction func saveDelivery(_ sender: UIBarButtonItem) {
		removeFirstCharacterAndCalculate()
		OperationQueue.main.addOperation() {
			self.activityIndicator(msg: "   Saving...", true)
		}
		perfomUnwindSegue()
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
	var selectedTime: String = ""
	var light: Bool = false
	static var ticketPhoto: UIImage? = nil
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	var activityIndicatorRunning: Bool = false
	var selectedPaymentMethod: String = ""
	var paymentMethodDataSource = ["None", "Cash", "Check", "Credit", "Charge", "Other"]
	let keyboardToolbar = UIToolbar()
	let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToPreviousField))
	let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToNextField))
	let doubleZero = UIButton(type: UIButtonType.custom)
	
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
		self.tabBarController?.tabBar.isHidden = true
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
		if segue.identifier == "unwindToDeliveryListSegue" {
			if self.timeOverrideSwitch.isOn {
				self.setDeliveryTime()
			} else if self.navigationItem.title == "Add Delivery" {
				self.deliveryTime.setDate(NSDate() as Date, animated: true)
				self.setDeliveryTime()
			}
			self.setDeliveryTime()/*
			let ticketNumberValue = self.ticketNumberField.text ?? ""
			let ticketAmountValue = self.ticketAmountField.text ?? ""
			let noTipSwitchValue = String(self.noTipSwitch.isOn)
			let amountGivenValue = self.amountGivenField.text ?? ""
			let cashTipsValue = self.cashTipsField?.text ?? ""
			let totalTipsValue = self.totalTips.text ?? ""
			let deliveryTimeValue = self.selectedTime
			let paymentMethodValue = String(self.paymentMethodPicker.selectedRow(inComponent: 0))
			self.delivery = Delivery(ticketNumberValue: ticketNumberValue, ticketAmountValue: ticketAmountValue, noTipSwitchValue: noTipSwitchValue, amountGivenValue: amountGivenValue, cashTipsValue: cashTipsValue, totalTipsValue: totalTipsValue, paymentMethodValue: paymentMethodValue, deliveryTimeValue: deliveryTimeValue, ticketPhotoValue: DeliveryViewController.ticketPhoto)*/
			self.messageFrame.removeFromSuperview()
		} else if segue.identifier == "scan" {
			let barcodeViewController: BarcodeViewController = segue.destination as! BarcodeViewController
			barcodeViewController.delegate = self
		} else if segue.identifier == "viewPhoto" {
			let ticketPhotoViewController = segue.destination as! TicketPhotoViewController
			if let ticketPhoto = DeliveryViewController.ticketPhoto {
				ticketPhotoViewController.ticketPhoto = ticketPhoto
			}
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
		if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
			do {
				try device.lockForConfiguration()
				let torchOn = !device.isTorchActive
				try device.setTorchModeOn(level: 1.0)
				device.torchMode = torchOn ? .on : .off
				device.unlockForConfiguration()
			} catch {
				print("error")
			}
		}
	}
	func perfomUnwindSegue() {
		OperationQueue.main.addOperation {
			self.performSegue(withIdentifier: "unwindToDeliveryListSegue", sender: self)
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
			removeFirstCharacterAndCalculate()
		}
	}
	func segmentControlSelected() {
		cashTipsField?.isEnabled = false
		amountGivenField.isEnabled = false
		amountGivenField.text = ticketAmountField.text
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
		noTipSwitch?.isEnabled = false
		removeFirstCharacterAndCalculate()
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
		let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont(name: "System", size: 15.0) as Any, NSAttributedStringKey.foregroundColor: UIColor.white])
		return myTitle
	}
	func paymentMethodChanged() {
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
		removeFirstCharacterAndCalculate()
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if row == 0 {
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			selectedPaymentMethod = "None"
		} else if row == 1 {
			noTipSwitch?.isEnabled = true
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			selectedPaymentMethod = "Cash"
			paymentMethodChanged()
		} else if row == 2 {
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			selectedPaymentMethod = "Check"
			paymentMethodChanged()
		} else if row == 3 {
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			selectedPaymentMethod = "Credit"
			paymentMethodChanged()
		} else if row == 4 {
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			selectedPaymentMethod = "Charge"
			paymentMethodChanged()
		} else if row == 5 {
			quickTipSelector.isEnabled = true
			cashTipsField?.isEnabled = true
			selectedPaymentMethod = "Other"
			paymentMethodChanged()
		}
	}
	
	// TimePicker
	func setDeliveryTime() {
		deliveryTime.reloadInputViews()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "hh:mm:ss a"
		dateFormatter.amSymbol = "AM"
		dateFormatter.pmSymbol = "PM"
		selectedTime = dateFormatter.string(from: deliveryTime.date)
		deliveryTime.setValue(UIColor.white, forKey: "textColor")
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
	func removeFirstCharacterAndCalculate() {
		var ticketAmountDropped = ticketAmountField.text
        let localTicketAmountDropped = ticketAmountDropped
		ticketAmountDropped?.remove(at: (localTicketAmountDropped?.startIndex)!)
        var amountGivenDropped = ticketAmountField.text
        let localAmountGivenDropped = ticketAmountDropped
        amountGivenDropped?.remove(at: (localAmountGivenDropped?.startIndex)!)
        var cashTipsDropped = ticketAmountField.text
        let localCashTipsDropped = cashTipsDropped
        cashTipsDropped?.remove(at: (localCashTipsDropped?.startIndex)!)
		if (cashTipsField?.text) != nil {
			let totalTipsCalc: Double = Double(amountGivenDropped!)! - Double(ticketAmountDropped!)! + Double(cashTipsDropped!)!
			totalTips.text = "$" + String(format: "%.2f", totalTipsCalc)
		} else {
			let totalTipsCalc: Double = Double(amountGivenDropped!)! - Double(ticketAmountDropped!)!
			totalTips.text = "$" + String(format: "%.2f", totalTipsCalc)
		}
	}
    @objc func switchValueDidChange(_ aSwitch: UISwitch) {
		if noTipSwitch.isOn {
			delivery?.noTip = noTipSwitch.isOn
			amountGivenField.text = ticketAmountField.text
			cashTipsField?.text = "$0.00"
			amountGivenField.isEnabled = false
			cashTipsField?.isEnabled = false
			removeFirstCharacterAndCalculate()
		} else {
			delivery?.noTip = noTipSwitch.isOn
			amountGivenField.isEnabled = true
			cashTipsField?.isEnabled = true
			removeFirstCharacterAndCalculate()
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
