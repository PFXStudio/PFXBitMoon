//
//  histodayParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 12..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class histodayParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        
        var historyDatas = Array<HistoryData>()
        if let jsonDict = JSON(parseJSON: jsonString).object as? NSDictionary {
            if let message = jsonDict.object(forKey: "Response") as? String {
                if message != "Success" {
                    return historyDatas
                }
            }
            
            if let datas = jsonDict.object(forKey: "Data") as? NSArray {
                for value in datas {
                    var historyData: HistoryData?
                    guard let dataDict = value as? NSDictionary,
                        let time = dataDict.object(forKey: "time"),
                        let close = dataDict.object(forKey: "close"),
                        let high = dataDict.object(forKey: "high"),
                        let low = dataDict.object(forKey: "low"),
                        let open = dataDict.object(forKey: "open"),
                        let volumefrom = dataDict.object(forKey: "volumefrom"),
                        let volumeto = dataDict.object(forKey: "volumeto")
                        else {
                            continue
                        }
                    
                    historyData = HistoryData(time: time as! Double, close: close as! Double, high: high as! Double, low: low as! Double, open: open as! Double, volumeFrom: volumefrom as! Double, volumeTo: volumeto as! Double)
                    historyDatas.append(historyData!)
                }
                
                return historyDatas
            }
        }
        
        return historyDatas
    }

}
