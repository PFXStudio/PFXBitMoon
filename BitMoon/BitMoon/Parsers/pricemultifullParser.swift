//
//  histodayParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 12..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class pricemultifullParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        var priceDatas = Array<PriceData>()
        if let jsonDict = JSON(parseJSON: jsonString).object as? NSDictionary {
            if let responseDict = jsonDict.object(forKey: "Response") as? NSDictionary {
                print(responseDict)
                return priceDatas
            }
            
            let displayDict = jsonDict.object(forKey: "DISPLAY") as? NSDictionary
            if (displayDict?.allKeys.count)! <= 0 {
                return priceDatas
            }
            
            guard let allDisplayKeys = displayDict?.allKeys else  {
                return priceDatas
            }
            
            for key in allDisplayKeys {
                guard let coinDict = displayDict?.object(forKey: key) as? NSDictionary else { continue }
                guard let priceDict = coinDict.object(forKey: FilterData.tsym) as? NSDictionary else { continue }
                guard let PRICE = priceDict.object(forKey: "PRICE") as? String,
                    let MKTCAP = priceDict.object(forKey: "MKTCAP") as? String,
                    let VOLUME24HOURTO = priceDict.object(forKey: "VOLUME24HOURTO") as? String,
                    let OPEN24HOUR = priceDict.object(forKey: "OPEN24HOUR") as? String,
                    let CHANGEPCT24HOUR = priceDict.object(forKey: "CHANGEPCT24HOUR") as? String,
                    let LOWDAY = priceDict.object(forKey: "LOWDAY") as? String,
                    let HIGHDAY = priceDict.object(forKey: "HIGHDAY") as? String
                    else {
                        return priceDatas
                }
                
                let priceData = PriceData(internalValue: key as! String, price: PRICE, marketCap: MKTCAP, volume24Hour: VOLUME24HOURTO, open24Hour: OPEN24HOUR, changePercentage: CHANGEPCT24HOUR, lowDay: LOWDAY, highDay: HIGHDAY)
                priceDatas.append(priceData)
            }
        }
        
        return priceDatas
    }
}
