//
//  TokenData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 21..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class TokenData: NSObject, NSCoding {
    var accessToken: String = ""
    var exfireDate: Int = 0
    
    static let sharedTokenData = TokenData(accessToken: "", exfireDate: 0)

    init(accessToken: String, exfireDate: Int) {
        self.accessToken = accessToken
        self.exfireDate = exfireDate
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String
        let exfireDate = aDecoder.decodeInt64(forKey: "exfireDate")

        self.init(accessToken: accessToken, exfireDate: Int(exfireDate))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(exfireDate, forKey: "exfireDate")
    }
    
    func isExfired() -> Bool {
        let currentInterval = Date().timeIntervalSince1970
        if self.exfireDate > Int(currentInterval) {
            return false
        }
        
        return true
    }
}
