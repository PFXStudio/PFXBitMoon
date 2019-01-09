//
//  TurtleHtmlParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class TurtleHtmlParser: ServiceParser {
    override func parseWithHtml(htmlString: String) -> Bool {
        ChartData.sharedBuyMarketLabels.removeAllObjects()
        ChartData.sharedBuyMarketDatas.removeAllObjects()
        
        let turtleParser = TurtleParser()
        let datas = turtleParser.parse(withHTMLString: htmlString)
        var index = 0
        for case let data as NSDictionary in datas! {
            if (index < 78) {
                index += 1
                continue
            }
            
            let value: NSNumber = data.object(forKey: "y") as! NSNumber
            let x: NSNumber = data.object(forKey: "x") as! NSNumber
            let date = NSDate(timeIntervalSince1970: x.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            ChartData.sharedBuyMarketLabels.add(dateFormatter.string(from: date as Date))
            ChartData.sharedBuyMarketDatas.add(value.doubleValue)
        }
        
        /*
         NSNumber *persent = [dataDict objectForKey:@"y"];
         CGFloat bmi = [persent floatValue];
         NSArray *markets = [dataDict objectForKey:@"markets"];
         NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"x"] doubleValue]];
         NSLog(@"%@", date);
         */
        
        return true
    }
}
