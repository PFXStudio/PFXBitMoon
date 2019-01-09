//
//  CoinMarketCalEventParser.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoinMarketCalEventParser: ServiceParser {
    override func parseWithJson(jsonString: String) -> Any {
        var eventDatas = Array<EventData>()
        if let message = JSON(parseJSON: jsonString).object as? NSDictionary {
            print("CoinMarketCalEventParser error \(message)")
            return eventDatas
        }
        
        guard let lists = JSON(parseJSON: jsonString).object as? NSArray else {
            print("CoinMarketCalEventParser error \(jsonString)")
            return eventDatas
        }
        
        for data in lists {
            let dataDict = data as! Dictionary<String, Any>
            var title = dataDict["title"] as? String
            if title == nil {
                title = ""
            }
            
            var date_event = dataDict["date_event"] as? String
            if date_event == nil {
                date_event = ""
            }
            
            var proof = dataDict["proof"] as? String
            if proof == nil {
                proof = ""
            }
            
            var source = dataDict["source"] as? String
            if source == nil {
                source = ""
            }
            
            var created_date = dataDict["created_date"] as? String
            if created_date == nil {
                created_date = ""
            }
            
            let can_occur_before = dataDict["can_occur_before"] as? Bool
            var description = dataDict["description"] as? String
            if description == nil {
                description = ""
            }

            var coins = dataDict["coins"] as? Array<Dictionary<String, Any>>
            if coins == nil {
                coins = Array<Dictionary<String, Any>>()
            }

            let is_hot = dataDict["is_hot"] as? Bool
            let percentage = dataDict["percentage"] as? Int
            let positive_vote_count = dataDict["positive_vote_count"] as? Int
            let vote_count = dataDict["vote_count"] as? Int

            // "2018-10-04T14:19:56+01:00"
            let sourceDateFormatter = DateFormatter()
            sourceDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
            sourceDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let sourceCreated_date = sourceDateFormatter.date(from: created_date!)
            let sourceDateEvent = sourceDateFormatter.date(from: date_event!)
            
            sourceDateFormatter.dateFormat = "dd LLLL yyyy"
            let createdDate = sourceDateFormatter.string(from: sourceCreated_date!)
            var dateEvent = sourceDateFormatter.string(from: sourceDateEvent!)
            if can_occur_before == true {
                dateEvent += "(or earlier)"
            }
            
            let eventData = EventData(title: title!, date: dateEvent, proof: proof!, source: source!, createdDate: createdDate, canOccurBefore:can_occur_before!, descripted: description!, isHot: is_hot!, percentage: percentage!, positiveVoteCount: positive_vote_count!, voteCount: vote_count!, coins: coins!)
            eventDatas.append(eventData)
        }
        
        return eventDatas
    }
}
