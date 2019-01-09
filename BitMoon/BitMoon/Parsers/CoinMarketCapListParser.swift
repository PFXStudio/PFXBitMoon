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
    override func parseWithJson(jsonString: String) -> Bool {
        var coinDatas = Array<CoinData>()
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
                    
                    let remoteIconPath = ServerInfoData.s_coinMarketCapImageRootPath + String(id) + ".png"
                    let coinData = CoinData(rank: rank, name: name, id: id, symbol: symbol, quotesDict: quotes, remoteIconPath: remoteIconPath)
                    coinDatas.append(coinData)
                }
                
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
}
