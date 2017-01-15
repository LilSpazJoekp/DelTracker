//
//  Delivery.swift
//  DelTracker
//
//  Created by Joel Payne on 11/27/16.
//  Copyright © 2016 Joel Payne. All rights reserved.
//

import UIKit

class Delivery {
    
    // MARK: Properties
    
    var ticketNumberValue: String
    var ticketAmountValue: String
    var quickTipSelectorValue: Int
    var noTipSwitchValue: Bool
    var amountGivenValue: String
    var totalTipsValue: String
    var paymentMethodValue: Int
    
    
    init?(ticketNumberValue: String, ticketAmountValue: String, quickTipSelectorValue: Int, noTipSwitchValue: Bool, amountGivenValue: String, totalTipsValue: String, paymentMethodValue: Int) {
        self.ticketNumberValue = ticketNumberValue
        self.ticketAmountValue = ticketAmountValue
        self.quickTipSelectorValue = quickTipSelectorValue
        self.noTipSwitchValue = noTipSwitchValue
        self.amountGivenValue = amountGivenValue
        self.totalTipsValue = totalTipsValue
        self.paymentMethodValue = paymentMethodValue
        }
    }
