//
//  CoinMarketCapListingsParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoinMarketCapListingsParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        /*
        if let jsonDict = JSON(parseJSON: jsonString).object as? NSDictionary {
            if let datas = jsonDict.object(forKey: "data") as? NSArray {
                for value in datas {
                    let valueDict = value as! NSDictionary
                    guard let id = valueDict.object(forKey: "id") as? Int,
                        let name = valueDict.object(forKey: "name") as? String,
                        let symbol = valueDict.object(forKey: "symbol") as? String else {
                            continue
                    }
                    
                    let remoteIconPath = ServerInfoData.s_coinMarketCapImageRootPath + String(id) + ".png"
                    let coinData = CoinData(name: name, id: id, symbol: symbol, remoteIconPath: remoteIconPath)
                    CoinData.sharedCoinDataDict[coinData.key] = coinData
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
 */
        return false
    }
}
