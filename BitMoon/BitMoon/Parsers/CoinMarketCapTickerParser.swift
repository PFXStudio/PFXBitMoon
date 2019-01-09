//
//  CoinMarketCapListParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoinMarketCapTickerParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        var coinDatas = Array<CoinData>()
        /*
        if let jsonDict = JSON(parseJSON: jsonString).object as? NSDictionary {
            if let dataDict = jsonDict.object(forKey: "data") as? NSDictionary {
                for value in dataDict.allValues {
                    let valueDict = value as! NSDictionary
                    guard let rank = valueDict.object(forKey: "rank") as? Int,
                        let id = valueDict.object(forKey: "id") as? Int,
                        let name = valueDict.object(forKey: "name") as? String,
                        let symbol = valueDict.object(forKey: "symbol") as? String,
                        let quotes = valueDict.object(forKey: "quotes") as? NSDictionary else {
                            continue
                    }
                    
                    var coinData = CoinData(name: name, id: id, symbol: symbol, remoteIconPath: "")
                    coinData = CoinData.sharedCoinDataDict[coinData.key] as! CoinData
                    coinData.quotesDict = quotes
                    coinData.rank = rank
                    
                    coinDatas.append(coinData)
                }
                
                return coinDatas
            }
            else {
                return coinDatas
            }
        }
        else {
            return coinDatas
        }
 */
        return coinDatas
    }
}
