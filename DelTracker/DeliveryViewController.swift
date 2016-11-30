//
//  DeliveryViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class DeliveryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIToolbarDelegate, UINavigationControllerDelegate {
	
	// MARK: - Storyboard Actions
	
	@IBAction func ticketNumberEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = false
		nextBarButton.isEnabled = true
	}
	@IBAction func ticketNumberChanged(_ sender: UITextField) {
		if ticketNumberField.text?.characters.count == 3 {
			ticketNumberField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
		}
	}
	@IBAction func ticketAmountEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = true
	}
	@IBAction func ticketAmountEditingEnded(_ sender: UITextField) {
		amountGivenField.isEnabled = true
		amountGivenField.isUserInteractionEnabled = true
		
	}
	@IBAction func amountGivenEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = true
	}
	@IBAction func amountGivenEditingEnded(_ sender: UITextField) {
		removeFirstCharacterAndCalculate()
		cashTipsField?.isEnabled = true
		cashTipsField?.isUserInteractionEnabled = true
	}
	@IBAction func cashTipsEditingBegan(_ sender: UITextField) {
		previousBarButton.isEnabled = true
		nextBarButton.isEnabled = false
	}
	@IBAction func cashTipsEditingEnded(_ sender: UITextField) {
		removeFirstCharacterAndCalculate()
	}
	@IBAction func saveDelivery(_ sender: Any) {
		removeFirstCharacterAndCalculate()
		print(Delivery.self)
	}
	@IBAction func cancelEdit(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func cancelAdd(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Storyboard Outlets
	
	@IBOutlet var ticketNumberField: UITextField!
	@IBOutlet var ticketAmountField: CurrencyField!
	@IBOutlet var quickTipSelector: UISegmentedControl!
	@IBOutlet var noTipSwitch: UISwitch!
	@IBOutlet var amountGivenField: CurrencyField!
	@IBOutlet var cashTipsField: CurrencyField?
	@IBOutlet var totalTips: UILabel!
	@IBOutlet var paymentMethodPicker: UIPickerView!
	@IBOutlet var saveDelivery: AnyObject?
	@IBOutlet var cancelDelivery: UIBarButtonItem!
	var delivery: Delivery?
	
	// MARK: - View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
		configureAmountGivenField()
		configureNoTipSwitch()
		configureCashTipsField()
		configureDoubleZeroButtonKey()
		addBarButtons()
		configureQuickTipSegmentControl()
		if let delivery = delivery {
			navigationItem.title = "Edit Delivery"
			ticketNumberField.text = delivery.ticketNumberValue
			ticketAmountField.text = delivery.ticketAmountValue
			noTipSwitch.isOn = Bool(delivery.noTipSwitchValue)!
			amountGivenField.text = delivery.amountGivenValue
			cashTipsField?.text = delivery.cashTipsValue
			totalTips.text = delivery.totalTipsValue
			paymentMethodPicker.selectRow(Int(delivery.paymentMethodValue)!, inComponent: 0, animated: true)
		} else {
			ticketNumberField.becomeFirstResponder()
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if saveDelivery === sender as AnyObject? {
			
			let ticketNumberValue = ticketNumberField.text ?? ""
			let ticketAmountValue = ticketAmountField.text ?? ""
			let noTipSwitchValue = String(noTipSwitch.isOn)
			let amountGivenValue = amountGivenField.text ?? ""
			let cashTipsValue = cashTipsField?.text ?? ""
			let totalTipsValue = totalTips.text ?? ""
			let paymentMethodValue = String(paymentMethodPicker.selectedRow(inComponent: 0))
			print(delivery?.noTipSwitchValue ?? "")
			delivery = Delivery(ticketNumberValue: ticketNumberValue, ticketAmountValue: ticketAmountValue, noTipSwitchValue: noTipSwitchValue, amountGivenValue: amountGivenValue, cashTipsValue: cashTipsValue, totalTipsValue: totalTipsValue, paymentMethodValue: paymentMethodValue)
		}
	}
	
	// MARK: - Configuration
	
	func configureTicketNumberField() {
		ticketNumberField?.clearsOnInsertion = true
	}
	func configureTicketAmountField() {
		ticketNumberField.clearsOnInsertion = true
	}
	func configureAmountGivenField() {
		amountGivenField.clearsOnInsertion = true
	}
	func configureQuickTipSegmentControl() {
		quickTipSelector.addTarget(self, action: #selector(DeliveryViewController.selectedSegmentDidChange(_:)), for: .valueChanged)
	}
	func configureNoTipSwitch() {
		noTipSwitch.setOn(false, animated: true)
		noTipSwitch.addTarget(self, action: #selector(DeliveryViewController.switchValueDidChange(_:)), for: .valueChanged)
	}
	func configureCashTipsField() {
		cashTipsField?.clearsOnInsertion = true
	}
	func configureDoubleZeroButtonKey() {
		doubleZero.setTitle("00", for: UIControlState())
		doubleZero.titleLabel?.font = UIFont.systemFont(ofSize: 24)
		doubleZero.setTitleColor(UIColor.white, for: UIControlState())
		doubleZero.frame = CGRect(x: 0, y: 115, width: 137, height: 56)
		doubleZero.adjustsImageWhenHighlighted = true
		doubleZero.addTarget(self, action: #selector(DeliveryViewController.doubleZero(_:)), for: UIControlEvents.touchUpInside)
		doubleZero.setBackgroundColor(UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0), forState: UIControlState.highlighted)
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
			selectedPaymentMethod = "other"
			paymentMethodChanged()
		}
	}
	
	// Keyboard Double Zero Key
	let doubleZero = UIButton(type: UIButtonType.custom)
	func goToPreviousField(_:Any?) {
		if ticketAmountField.isFirstResponder {
			ticketAmountField.resignFirstResponder()
			ticketNumberField.becomeFirstResponder()
		} else if amountGivenField.isFirstResponder {
			amountGivenField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
		} else if (cashTipsField?.isFirstResponder)! {
			cashTipsField?.resignFirstResponder()
			amountGivenField.becomeFirstResponder()
		}
	}
	func goToNextField() {
		if ticketNumberField.isFirstResponder {
			previousBarButton.isEnabled = true
			ticketNumberField.resignFirstResponder()
			ticketAmountField.becomeFirstResponder()
		} else if ticketAmountField.isFirstResponder {
			ticketAmountField.resignFirstResponder()
			if quickTipSelector.selectedSegmentIndex == 5 {
				amountGivenField.becomeFirstResponder()
			}
		} else if amountGivenField.isFirstResponder {
			amountGivenField.resignFirstResponder()
			cashTipsField?.becomeFirstResponder()
		}
	}
	func doubleZero(_ sender : UIButton) {
		if ticketAmountField.isFirstResponder {
			ticketAmountField.insertText("00")
			ticketAmountField.resignFirstResponder()
			amountGivenField.becomeFirstResponder()
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
			UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
				self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
			}, completion: { (complete) -> Void in
			})
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
			// Checking if cashTipsField has value and calculating tips
			removeFirstCharacterAndCalculate()
		} else {
			delivery?.noTipSwitchValue = "false"
			amountGivenField.isEnabled = false
			cashTipsField?.isEnabled = false
		}
	}
	// Dismissing Keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
// MARK: Custom Classes

// CurrencyField Class
class CurrencyField: UITextField {
	override func awakeFromNib() {
		super.awakeFromNib()
		addTarget(self, action: #selector(editingChanged), for: .editingChanged)
		keyboardType = .numberPad
		textAlignment = .right
		editingChanged()
	}
	func editingChanged() {
		text = Formatter.currency.string(from: (Double(string.numbers.integer) / 100) as NSNumber)
	}
}
struct Formatter {
	static let currency = NumberFormatter(numberStyle: .currency)
}
extension UITextField {
	var string: String { return text ?? "0" }
}
extension String {
	var numbers: String { return components(separatedBy: Numbers.characterSet.inverted).joined() }
	var integer: Int { return Int(numbers) ?? 0 }
}
struct Numbers { static let characterSet = CharacterSet(charactersIn: "0123456789")
}
extension NumberFormatter {
	convenience init(numberStyle: NumberFormatter.Style) {
		self.init()
		self.numberStyle = numberStyle
	}
}

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
