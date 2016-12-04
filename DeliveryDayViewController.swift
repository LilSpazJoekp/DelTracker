//
//  DeliveryDayViewController.swift
//  DelTracker
//
//  Created by Joel Payne on 12/2/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DeliveryDayViewController: UIViewController {

	@IBOutlet var deliveryDatePicker: UIDatePicker!
	
	let deliveryDayViewController = DeliveryDayViewController()
	let delivery = Delivery()

	override func viewDidLoad() {
        super.viewDidLoad()
		delivery.deliveryDayViewController = deliveryDayViewController
	
	let deliveryDate = "\(deliveryDatePicker.date)".substring(to:"\(deliveryDatePicker.date)".index("\(deliveryDatePicker.date)".startIndex, offsetBy: 10))
		print(deliveryDate)


		        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
