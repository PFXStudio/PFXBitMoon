//
//  NomicsMarketParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 21..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class NomicsMarketParser: NSObject {
    func parse(string: String) {
        let datas = JSON(parseJSON: string).object as! NSArray
        for data in datas {
            let dataDict = data as! NSDictionary
            let exchange = dataDict.object(forKey: "exchange") as! NSString
            let quote = dataDict.object(forKey: "quote") as! String
            
            var marketData = MarketData.sharedMarketDataDict[exchange] as? MarketData
            if marketData == nil {
                var iconName = ""
                if (exchange == "binance") {
                    iconName = "iconBinance"
                }
                else if exchange == "idex" {
                    iconName = "iconIdex"
                }
                else if exchange == "hitbtc" {
                    iconName = "iconHitbtc"
                }
                else if exchange == "bitfinex" {
                    iconName = "iconBitfinex"
                }
                else if exchange == "poloniex" {
                    iconName = "iconPoloniex"
                }
                else if exchange == "bittrex" {
                    iconName = "iconBittrex"
                }
                else if exchange == "gateio" {
                    iconName = "iconGateio"
                }
                else if exchange == "gdax" {
                    iconName = "iconGdax"
                }
                else if exchange == "bitflyer" {
                    iconName = "iconBitflyer"
                }
                else if exchange == "bithumb" {
                    iconName = "iconBithumb"
                }
                else if exchange == "kraken" {
                    iconName = "iconKraken"
                }
                else if exchange == "gemini" {
                    iconName = "iconGemini"
                }

                marketData = MarketData(exchange: exchange as String, quoteDict: Dictionary(), quoteKey: "", iconName: iconName)
                MarketData.sharedMarketDataDict.setObject(marketData!, forKey: exchange)
            }
            
            let checkQuote = marketData!.quoteDict[quote]
            if checkQuote == nil {
                marketData!.quoteDict[quote] = quote
            }
        }
    }
}
