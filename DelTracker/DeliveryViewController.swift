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

class DeliveryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate, BarcodeDelegate {
	
	// MARK: - Storyboard Actions
	
	@IBAction func ticketNumberEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = false
		nextBarButton.isEnabled = true
		ticketNumberField.selectedTextRange = ticketNumberField.textRange(from: ticketNumberField.beginningOfDocument, to: ticketNumberField.endOfDocument)
	}
	@IBAction func ticketNumberChanged(_ sender: UITextField) {
		if ticketNumberField.text?.characters.count == 3 {
			ticketNumberField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
			ticketAmountField.selectedTextRange = ticketAmountField.textRange(from: ticketAmountField.beginningOfDocument, to: ticketAmountField.endOfDocument)
		}
	}
	@IBAction func ticketAmountEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = true
		ticketAmountField.selectedTextRange = ticketAmountField.textRange(from: ticketAmountField.beginningOfDocument, to: ticketAmountField.endOfDocument)
	}
	@IBAction func ticketAmountEditingEnded(_ sender: UITextField) {
		amountGivenField.isEnabled = true
		amountGivenField.isUserInteractionEnabled = true
	}
	@IBAction func amountGivenEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = true
		amountGivenField.selectedTextRange = amountGivenField.textRange(from: amountGivenField.beginningOfDocument, to: amountGivenField.endOfDocument)
	}
	@IBAction func amountGivenEditingEnded(_ sender: UITextField) {
		removeFirstCharacterAndCalculate()
		cashTipsField?.isEnabled = true
		cashTipsField?.isUserInteractionEnabled = true
	}
	@IBAction func cashTipsEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = false
		cashTipsField?.selectedTextRange = cashTipsField?.textRange(from: (cashTipsField?.beginningOfDocument)!, to: (cashTipsField?.endOfDocument)!)
	}
	@IBAction func cashTipsEditingEnded(_ sender: UITextField) {
		removeFirstCharacterAndCalculate()
	}
	@IBAction func saveDelivery(_ sender: UIBarButtonItem) {
		DispatchQueue.main.async {
			self.activityIndicator(msg: "    Saving...", true)
			self.removeFirstCharacterAndCalculate()
		}
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
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				if let date = dateFormatter.date(from: delivery.deliveryTimeValue) {
					deliveryTime.setDate(date, animated: true)
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
	@IBOutlet var saveDelivery: AnyObject?
	@IBOutlet var setTimeToNowButton: UIBarButtonItem?
	@IBOutlet var timeOverrideSwitch: UISwitch!
	@IBOutlet var deliveryTime: UIDatePicker!
	
	var delivery: Delivery?
	var selectedTime: String = ""
	var light: Bool = false
	static var ticketPhoto: UIImage? = nil
	var messageFrame = UIView()
	var activityIndicator = UIActivityIndicatorView()
	var strLabel = UILabel()
	var activityIndicatorRunning: Bool = false
	
	// MARK: - View Life Cycle
	
	func showIndicator(_ sender: UIBarButtonItem) {
		self.activityIndicator(msg: "    Saving...", true)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		keyboardToolbar.backgroundColor = UIColor(red:0.09, green:0.11, blue:0.11, alpha:1.0)
		ticketNumberField.delegate = self
		ticketAmountField.delegate = self
		amountGivenField.delegate = self
		cashTipsField?.delegate = self
		var ticketAmountDropped = ticketAmountField.text
		ticketAmountDropped?.remove(at: (ticketAmountDropped?.startIndex)!)
		var amountGivenDropped = amountGivenField.text
		amountGivenDropped?.remove(at: (amountGivenDropped?.startIndex)!)
		var cashTipsDropped = cashTipsField?.text
		cashTipsDropped?.remove(at: (cashTipsDropped?.startIndex)!)
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
			navigationItem.title = "Edit Delivery"
			ticketNumberField.text = delivery.ticketNumberValue
			ticketAmountField.text = delivery.ticketAmountValue
			noTipSwitch.isOn = Bool(delivery.noTipSwitchValue)!
			amountGivenField.text = delivery.amountGivenValue
			cashTipsField?.text = delivery.cashTipsValue
			totalTips.text = delivery.totalTipsValue
			if let ticketPhoto = delivery.ticketPhotoValue {
				DeliveryViewController.ticketPhoto = ticketPhoto
			}
			paymentMethodPicker.selectRow(Int(delivery.paymentMethodValue)!, inComponent: 0, animated: true)
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "hh:mm:ss a"
			if let date = dateFormatter.date(from: delivery.deliveryTimeValue) {
				deliveryTime.setDate(date, animated: true)
				deliveryTime.isEnabled = false
				setTimeToNowButton?.isEnabled = false
			}
		}
		if light {
			toggleFlash()
		}
		if (ticketNumberField.text?.characters.count)! > 3 {
			var ticketNumberRemove = ticketNumberField.text
			let ticketNumberCount = ticketNumberRemove?.characters.count
			print("ticketNumberCount: \(ticketNumberCount!)")
			for _ in 1...3 {
				ticketNumberRemove?.remove(at: (ticketNumberRemove?.startIndex)!)
				print("ticketNumberRemove: \(ticketNumberRemove!)")
			}
			ticketNumberField.text = ticketNumberRemove
			print("ticketNumberField.text: \(ticketNumberField.text)")
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		ticketNumberField.resignFirstResponder()
		ticketAmountField.resignFirstResponder()
		amountGivenField.resignFirstResponder()
		cashTipsField?.resignFirstResponder()
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if !activityIndicatorRunning {
			activityIndicator(msg: "    Saving...", true)
			return true
		} else {
			return true
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		DispatchQueue.main.async {
			if self.saveDelivery === sender as AnyObject? {
				self.activityIndicator(msg: "    Saving...", true)
				if self.timeOverrideSwitch.isOn {
					self.setDeliveryTime()
				} else if self.navigationItem.title == "Add Delivery" {
					self.deliveryTime.setDate(NSDate() as Date, animated: true)
					self.setDeliveryTime()
				}
				self.setDeliveryTime()
				let ticketNumberValue = self.ticketNumberField.text ?? ""
				let ticketAmountValue = self.ticketAmountField.text ?? ""
				let noTipSwitchValue = String(self.noTipSwitch.isOn)
				let amountGivenValue = self.amountGivenField.text ?? ""
				let cashTipsValue = self.cashTipsField?.text ?? ""
				let totalTipsValue = self.totalTips.text ?? ""
				let deliveryTimeValue = self.selectedTime
				let paymentMethodValue = String(self.paymentMethodPicker.selectedRow(inComponent: 0))
				self.delivery = Delivery(ticketNumberValue: ticketNumberValue, ticketAmountValue: ticketAmountValue, noTipSwitchValue: noTipSwitchValue, amountGivenValue: amountGivenValue, cashTipsValue: cashTipsValue, totalTipsValue: totalTipsValue, paymentMethodValue: paymentMethodValue, deliveryTimeValue: deliveryTimeValue, ticketPhotoValue: DeliveryViewController.ticketPhoto)
			}
			if segue.identifier == "viewPhoto" {
				let ticketPhotoViewController = segue.destination as! TicketPhotoViewController
				if let ticketPhoto = DeliveryViewController.ticketPhoto {
					ticketPhotoViewController.ticketPhoto = ticketPhoto
				}
			} else if segue.identifier == "scan" {
				let barcodeViewController: BarcodeViewController = segue.destination as! BarcodeViewController
				barcodeViewController.delegate = self
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
		print(barcode)
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
	
	// MARK: - Configuration
	
	func configureTicketNumberField() {
		ticketNumberField?.clearsOnInsertion = true
	}
	func configureTicketAmountField() {
		ticketNumberField.clearsOnInsertion = true
	}
	func configureQuickTipSegmentControl() {
		quickTipSelector.addTarget(self, action: #selector(DeliveryViewController.selectedSegmentDidChange(_:)), for: .valueChanged)
	}
	func configureNoTipSwitch() {
		noTipSwitch.setOn(false, animated: true)
		noTipSwitch.addTarget(self, action: #selector(DeliveryViewController.switchValueDidChange(_:)), for: .valueChanged)
	}
	func configureDoubleZeroButtonKey() {
		doubleZero.setTitle("00", for: UIControlState())
		doubleZero.titleLabel?.font = UIFont.systemFont(ofSize: 24)
		doubleZero.setTitleColor(UIColor.white, for: UIControlState())
		doubleZero.frame = CGRect(x: 0, y: 115, width: 137, height: 56)
		doubleZero.adjustsImageWhenHighlighted = true
		doubleZero.addTarget(self, action: #selector(DeliveryViewController.doubleZero(_:)), for: UIControlEvents.touchUpInside)
		doubleZero.setBackgroundColor(UIColor(red:0.47, green:0.47, blue:0.47, alpha:1.0), forState: UIControlState.highlighted)
	}
	func configureSaveButton() {
		saveDelivery?.addTarget(self, action: #selector(DeliveryViewController.showIndicator(_:)), for: UIControlEvents.touchUpInside)
	}
	
	// Quick Tip Segment Control
	func selectedSegmentDidChange(_ segmentedControl: UISegmentedControl) {
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
	var selectedPaymentMethod: String = ""
	var paymentMethodDataSource = ["None", "Cash", "Check", "Credit", "Charge", "Other"]
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
		let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "System", size: 15.0) as Any,NSForegroundColorAttributeName:UIColor.white])
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
	
	// Keyboard Double Zero Key
	let doubleZero = UIButton(type: UIButtonType.custom)
	
	// Toolbar Previous and Next Buttons
	func goToPreviousField(_:Any?) {
		if ticketAmountField.isFirstResponder {
			ticketAmountField.resignFirstResponder()
			ticketNumberField.becomeFirstResponder()
			ticketNumberField.selectedTextRange = ticketNumberField.textRange(from: ticketNumberField.beginningOfDocument, to: ticketNumberField.endOfDocument)
		} else if amountGivenField.isFirstResponder {
			amountGivenField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
			ticketAmountField.selectedTextRange = ticketAmountField.textRange(from: ticketAmountField.beginningOfDocument, to: ticketAmountField.endOfDocument)
		} else if (cashTipsField?.isFirstResponder)! {
			cashTipsField?.resignFirstResponder()
			amountGivenField.becomeFirstResponder()
			amountGivenField.selectedTextRange = amountGivenField.textRange(from: amountGivenField.beginningOfDocument, to: amountGivenField.endOfDocument)
		}
	}
	func goToNextField() {
		if ticketNumberField.isFirstResponder {
			previousBarButton.isEnabled = true
			ticketNumberField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
			ticketAmountField.selectedTextRange = ticketAmountField.textRange(from: ticketAmountField.beginningOfDocument, to: ticketAmountField.endOfDocument)
		} else if ticketAmountField.isFirstResponder {
			ticketAmountField.resignFirstResponder()
			if quickTipSelector.selectedSegmentIndex == 5 {
				amountGivenField.isEnabled = true
				amountGivenField.becomeFirstResponder()
				amountGivenField.selectedTextRange = amountGivenField.textRange(from: amountGivenField.beginningOfDocument, to: amountGivenField.endOfDocument)
			}
		} else if amountGivenField.isFirstResponder {
			amountGivenField.resignFirstResponder()
			cashTipsField?.isEnabled = true
			cashTipsField?.becomeFirstResponder()
			cashTipsField?.selectedTextRange = cashTipsField?.textRange(from: (cashTipsField?.beginningOfDocument)!, to: (cashTipsField?.endOfDocument)!)
		}
	}
	func doubleZero(_ sender : UIButton) {
		if ticketAmountField.isFirstResponder {
			ticketAmountField.insertText("00")
			ticketAmountField.resignFirstResponder()
			amountGivenField.becomeFirstResponder()
			amountGivenField.selectedTextRange = amountGivenField.textRange(from: amountGivenField.beginningOfDocument, to: amountGivenField.endOfDocument)
		} else if amountGivenField.isFirstResponder {
			amountGivenField.insertText("00")
			amountGivenField.resignFirstResponder()
		} else if (cashTipsField?.isFirstResponder)! {
			cashTipsField?.insertText("00")
			cashTipsField?.resignFirstResponder()
		}
	}
	
	// UITextField Navigation Bar
	let keyboardToolbar = UIToolbar()
	let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
	                                    target: nil, action: nil)
	let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToPreviousField))
	let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeliveryViewController.goToNextField))
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
	func keyboardWillShow(_ note : Notification) -> Void{
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
		ticketAmountDropped?.remove(at: (ticketAmountDropped?.startIndex)!)
		var amountGivenDropped = amountGivenField.text
		amountGivenDropped?.remove(at: (amountGivenDropped?.startIndex)!)
		var cashTipsDropped = cashTipsField?.text
		cashTipsDropped?.remove(at: (cashTipsDropped?.startIndex)!)
		if (cashTipsField?.text) != nil {
			let totalTipsCalc :Double = Double(amountGivenDropped!)! - Double(ticketAmountDropped!)! + Double(cashTipsDropped!)!
			totalTips.text = "$" + String(format: "%.2f", totalTipsCalc)
		} else {
			let totalTipsCalc :Double = Double(amountGivenDropped!)! - Double(ticketAmountDropped!)!
			totalTips.text = "$" + String(format: "%.2f", totalTipsCalc)
		}
	}
	func switchValueDidChange(_ aSwitch: UISwitch) {
		var ticketAmountDropped = ticketAmountField.text
		ticketAmountDropped?.remove(at: (ticketAmountDropped?.startIndex)!)
		var amountGivenDropped = amountGivenField.text
		amountGivenDropped?.remove(at: (amountGivenDropped?.startIndex)!)
		var cashTipsDropped = cashTipsField?.text
		cashTipsDropped?.remove(at: (cashTipsDropped?.startIndex)!)
		if (noTipSwitch?.isOn)! {
			delivery?.noTipSwitchValue = "true"
			amountGivenDropped = ticketAmountDropped
			amountGivenField.text = ticketAmountField.text
			cashTipsField?.text = "$0.00"
			amountGivenField.isEnabled = false
			cashTipsField?.isEnabled = false
			removeFirstCharacterAndCalculate()
		} else {
			delivery?.noTipSwitchValue = "false"
			amountGivenField.isEnabled = true
			cashTipsField?.isEnabled = true
		}
	}
	@IBAction func activityIndictorStart(_ sender: UIBarButtonItem) {
		activityIndicator(msg: "    Saving...", true)
	}
	// Dismissing Keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
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
		view.bringSubview(toFront: strLabel)
		view.addSubview(messageFrame)
		view.bringSubview(toFront: messageFrame)
	}
}

// MARK: Extensions

extension UIButton {
	func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.setBackgroundImage(colorImage, for: forState)
	}
}
