//
//  ActivityIndicatorOverlay.swift
//  DelTracker
//
//  Created by Joel Payne on 12/25/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit
import CoreData

class ActivityIndicatorOverlay: UIView {
	var container: UIStackView
	var activityIndicator: UIActivityIndicatorView
	var label: UILabel
	var glass: UIView
	private var activityIndicatorLabel: String
	private var modal: Bool
	
	init(activityIndicatorLabel: String, modal: Bool) {
		self.activityIndicatorLabel = activityIndicatorLabel
		self.modal = modal
		self.container = UIStackView()
		self.activityIndicator = UIActivityIndicatorView()
		self.label = UILabel()
		self.glass = UIView()
		let fontName = self.label.font.fontName
		let fontSize = self.label.font.pointSize
		if let font = UIFont(name: fontName, size: fontSize) {
			let fontAttributes = [NSFontAttributeName: font]
			let size = (activityIndicatorLabel as NSString).size(attributes: fontAttributes)
			super.init(frame: CGRect(x: 0, y: 0, width: size.width + 50, height: 50))
		} else {
			super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		}
		NotificationCenter.default.addObserver(self, selector: #selector(onRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		self.layer.cornerRadius = 3
		self.backgroundColor = UIColor(white: 0, alpha: 0.7)
		self.label.textColor = UIColor.white
		self.label.text = self.activityIndicatorLabel
		self.container.frame = self.frame
		self.container.spacing = 5
		self.container.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		self.container.isLayoutMarginsRelativeArrangement = true
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.white)
		self.activityIndicator.color = UIColor.white
		self.activityIndicator.startAnimating()
		if let superview = UIApplication.shared.keyWindow {
			if self.modal {
				self.glass.frame = superview.frame
				self.glass.backgroundColor  = UIColor.black.withAlphaComponent(0.5)
				superview.addSubview(glass)
				superview.bringSubview(toFront: glass)
			}
		}
		container.addArrangedSubview(self.activityIndicator)
		container.addArrangedSubview(self.label)
		self.addSubview(container)
		self.bringSubview(toFront: container)
		if let superview = UIApplication.shared.keyWindow {
			self.center = superview.center
			superview.addSubview(self)
			superview.bringSubview(toFront: self)
		}
		self.hide()
	}
	required init(coder: NSCoder) {
		self.activityIndicatorLabel = "Not set!"
		self.modal = true
		self.container = UIStackView()
		self.activityIndicator = UIActivityIndicatorView()
		self.label = UILabel()
		self.glass = UIView()
		super.init(coder: coder)!
	}
	func onRotate() {
		if let superview = self.superview {
			self.glass.frame = superview.frame
			self.center = superview.center
		}
	}
	public func show() {
		self.glass.isHidden = false
		self.isHidden = false
	}
	public func hide() {
		self.glass.isHidden = true
		self.isHidden = true
	}
}
