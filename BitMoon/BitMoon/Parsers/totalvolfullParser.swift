//
//  totalvolfullParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class totalvolfullParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        var coinDatas = Array<CoinData>()
        if let jsonDict = JSON(parseJSON: jsonString).object as? NSDictionary {
            if let message = jsonDict.object(forKey: "Message") as? String {
                if message != "Success" {
                    return coinDatas
                }
            }
            
            if let datas = jsonDict.object(forKey: "Data") as? NSArray {
                for value in datas {
                    var coinData: CoinData?
                    guard let dataDict = value as? NSDictionary,
                        let coinInfoDict = dataDict.object(forKey: "CoinInfo") as? NSDictionary,
                        let Id = coinInfoDict.object(forKey: "Id"),
                        let Name = coinInfoDict.object(forKey: "Name"),
                        let FullName = coinInfoDict.object(forKey: "FullName"),
                        let Internal = coinInfoDict.object(forKey: "Internal"),
                        let ImageUrl = coinInfoDict.object(forKey: "ImageUrl"),
                        let Url = coinInfoDict.object(forKey: "Url"),
                        let Algorithm = coinInfoDict.object(forKey: "Algorithm"),
                        let ProofType = coinInfoDict.object(forKey: "ProofType"),
                        let NetHashesPerSecond = coinInfoDict.object(forKey: "NetHashesPerSecond") as? NSNumber,
                        let BlockNumber = coinInfoDict.object(forKey: "BlockNumber") as? NSNumber,
                        let BlockTime = coinInfoDict.object(forKey: "BlockTime") as? NSNumber,
                        let BlockReward = coinInfoDict.object(forKey: "BlockReward") as? NSNumber,
                        let Type = coinInfoDict.object(forKey: "Type") as? NSNumber,
                        let DocumentType = coinInfoDict.object(forKey: "DocumentType") else {
                            continue
                    }
                    
                    var remoteIconUrl = URL(string: ServerInfoData.s_cryptoCompareResourcePath)
                    remoteIconUrl = remoteIconUrl?.appendingPathComponent(ImageUrl as! String)

                    coinData = CoinData(id: Id as! String, name: Name as! String, fullName: FullName as! String, internalValue: Internal as! String, imageUrl: ImageUrl as! String, url: Url as! String, algorithm: Algorithm as! String, proofType: ProofType as! String, netHashesPerSecond: NetHashesPerSecond.doubleValue, blockNumber: BlockNumber.intValue, blockTime: BlockTime.intValue, blockReward: BlockReward.doubleValue, type: Type.intValue, documentType: DocumentType as! String, remoteIconUrl: remoteIconUrl!)
                    
                    guard let displayDict = dataDict.object(forKey: "DISPLAY") as? Dictionary<String, Any> else { continue }
                    guard let priceDict = displayDict[FilterData.tsym] as? NSDictionary else { continue }
                    guard let PRICE = priceDict.object(forKey: "PRICE") as? String,
                        let MKTCAP = priceDict.object(forKey: "MKTCAP") as? String,
                        let VOLUME24HOURTO = priceDict.object(forKey: "VOLUME24HOURTO") as? String,
                        let OPEN24HOUR = priceDict.object(forKey: "OPEN24HOUR") as? String,
                        let CHANGEPCT24HOUR = priceDict.object(forKey: "CHANGEPCT24HOUR") as? String,
                        let LOWDAY = priceDict.object(forKey: "LOWDAY") as? String,
                        let HIGHDAY = priceDict.object(forKey: "HIGHDAY") as? String
                        else {
                            continue
                    }
                    
                    coinData?.priceData = PriceData(internalValue: (coinData?.internalValue)!, price: PRICE, marketCap: MKTCAP, volume24Hour: VOLUME24HOURTO, open24Hour: OPEN24HOUR, changePercentage: CHANGEPCT24HOUR, lowDay: LOWDAY, highDay: HIGHDAY)

                    coinDatas.append(coinData!)
                    CoinData.sharedCoinDataDict[coinData!.key] = coinData
                }
                
                return coinDatas
            }
        }

        return coinDatas
    }
}
