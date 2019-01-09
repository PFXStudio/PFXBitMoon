//
//  MarketCalCoinData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class MarketCalCoinData: NSObject {
    static let sharedMarketCalCoinDataDict = NSMutableDictionary()
    
    var id = ""
    var symbol = ""
    var name = ""
    
    init(id: String, symbol: String, name: String) {
        self.id = id
        self.symbol = symbol
        self.name = name
    }
}
