//
//  MarketData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 21..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class MarketData: NSObject, NSCoding {
    var exchange: String = ""
    var quoteDict: Dictionary<String, String> = Dictionary()
    var quoteKey: String = ""
    var iconName: String = ""
    
    static let sharedMarketDataDict = NSMutableDictionary()
    
    init(exchange: String, quoteDict: Dictionary<String, String>, quoteKey: String, iconName: String) {
        self.exchange = exchange
        self.quoteDict = quoteDict
        self.quoteKey = quoteKey
        self.iconName = iconName
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let exchange = aDecoder.decodeObject(forKey: "exchange") as! String
        let quoteDict = aDecoder.decodeObject(forKey: "quoteDict") as! Dictionary<String, String>
        let quoteKey = aDecoder.decodeObject(forKey: "quoteKey") as! String
        let iconName = aDecoder.decodeObject(forKey: "iconName") as! String

        self.init(exchange: exchange, quoteDict:quoteDict, quoteKey: quoteKey, iconName: iconName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(exchange, forKey: "exchange")
        aCoder.encode(quoteDict, forKey: "quoteDict")
        aCoder.encode(quoteKey, forKey: "quoteKey")
        aCoder.encode(iconName, forKey: "iconName")
    }
}
