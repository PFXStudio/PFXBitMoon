//
//  CoinMarketCalCoinsParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoinMarketCalCoinsParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        if let lists = JSON(parseJSON: jsonString).object as? NSArray {
            for data in lists {
                let infoDict = data as! Dictionary<String, String>
                guard let symbol = infoDict["symbol"],
                    let id = infoDict["id"],
                    let name = infoDict["name"] else {
                        continue
                }
                
                let marketCalCoinData = MarketCalCoinData(id: id, symbol: symbol, name: name)
                MarketCalCoinData.sharedMarketCalCoinDataDict.setValue(marketCalCoinData, forKey: name.lowercased())
            }
        }
        
        return ""
    }
}
