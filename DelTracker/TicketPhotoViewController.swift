//
//  ticketPhotoViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/18/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class TicketPhotoViewController: UIViewController {
	
	@IBAction func rotate(_ sender: Any) {
		
	}
	@IBOutlet var ticketPhotoImageView: UIImageView!
	@IBAction func doneButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	var ticketPhoto: UIImage?
	override func viewDidLoad() {
		super.viewDidLoad()
		ticketPhotoImageView.image = ticketPhoto
	}
}
