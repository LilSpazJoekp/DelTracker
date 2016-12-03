//
//  DropTableViewCell.swift
//  DelTracker
//
//  Created by Joel Payne on 12/1/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class DropTableViewCell: UITableViewCell {

   
	@IBOutlet var dropNumber: UILabel!
	@IBOutlet var dropAmount: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
