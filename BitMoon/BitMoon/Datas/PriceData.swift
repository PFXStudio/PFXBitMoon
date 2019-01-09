//
//  PriceData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class PriceData: NSObject {
    var internalValue = ""
    var price = ""
    var marketCap = ""
    var volume24Hour: String?
    var open24Hour = ""
    var changePercentage: String?
    var lowDay = ""
    var highDay = ""

    init(internalValue: String, price: String, marketCap: String, volume24Hour: String, open24Hour: String, changePercentage: String, lowDay: String, highDay: String) {
        self.internalValue = internalValue
        self.price = price
        self.marketCap = marketCap
        self.volume24Hour = volume24Hour
        self.open24Hour = open24Hour
        self.changePercentage = changePercentage
        self.lowDay = lowDay
        self.highDay = highDay
    }
}
