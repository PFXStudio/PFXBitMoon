//
//  CoinMarketCalAuthParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoinMarketCalAuthParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        let jsonDict = JSON(parseJSON: jsonString).object as! NSDictionary
        let accessToken = jsonDict.object(forKey: "access_token") as! String
        let expiresIn = jsonDict.object(forKey: "expires_in") as! Int

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy, HH:mm"
        let date = NSDate(timeIntervalSince1970: TimeInterval(expiresIn))
        let text = dateFormatter.string(from: date as Date)
        print(text)
        
        var dateComponent = DateComponents()
        dateComponent.minute = expiresIn / 86400
        let expireDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        return TokenData(accessToken: accessToken, exfireDate: Int((expireDate?.timeIntervalSince1970)!))
    }
}
