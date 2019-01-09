//
//  EventData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 28..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class EventData: NSObject {
    var key = ""
    var title = ""
    var date = ""
    var proof = ""
    var source = ""
    var createdDate = ""
    var canOccurBefore = false
    var descripted = ""
    var isHot = false
    var percentage = 0
    var positiveVoteCount = 0
    var voteCount = 0
    var coins = Array<Dictionary<String, Any>>()

    init(title: String, date: String, proof: String, source: String, createdDate: String, canOccurBefore: Bool, descripted: String, isHot: Bool, percentage: Int, positiveVoteCount: Int, voteCount: Int, coins: Array<Dictionary<String, Any>>) {
        self.title = title
        self.date = date
        self.proof = proof
        self.source = source
        self.createdDate = createdDate
        self.canOccurBefore = canOccurBefore
        self.descripted = descripted
        self.isHot = isHot
        self.percentage = percentage
        self.positiveVoteCount = positiveVoteCount
        self.voteCount = voteCount
        self.coins = coins
    }
    
    func dday() -> String {
        var beforeTag = ""
        if self.canOccurBefore == true {
            beforeTag = "?"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let eventDate = self.date.replacingOccurrences(of: "(or earlier)", with: "")

        var targetDate = dateFormatter.date(from: eventDate)
        targetDate = Calendar.current.date(byAdding: .day, value: 1, to: targetDate!)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .full
        if let day = formatter.string(from: Date(), to: targetDate!) {
            return "D-" + String(day) + beforeTag
        }
        
        return ""
    }
    
    static func generateKey(name: String, symbol: String) -> String {
        return name.lowercased() + "(" + symbol.lowercased() + ")"
    }
}
