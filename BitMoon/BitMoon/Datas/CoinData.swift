//
//  KeyData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class CoinData: NSObject, NSCoding {
    static let sharedCoinDataDict = NSMutableDictionary()
    var key = ""
    var iconFileName = ""
    var id = ""
    var name = ""
    var fullName = ""
    var internalValue = ""
    var imageUrl = ""
    var url = ""
    var algorithm = ""
    var proofType = ""
    var netHashesPerSecond = 0.0
    var blockNumber = 0
    var blockTime = 0
    var blockReward = 0.1
    var type = 0
    var documentType = ""
    var remoteIconUrl: URL
    var priceData: PriceData?
    var eventDatas = Array<EventData>()

    init(id: String, name: String, fullName: String, internalValue: String, imageUrl: String, url: String, algorithm: String, proofType: String, netHashesPerSecond: Double, blockNumber: Int, blockTime: Int, blockReward: Double, type: Int, documentType: String, remoteIconUrl: URL) {
        self.key = CoinData.generateKey(name: fullName, symbol: internalValue)
        self.iconFileName = self.key + ".png"
        self.id = id
        self.name = name
        self.fullName = fullName
        self.internalValue = internalValue
        self.imageUrl = imageUrl
        self.url = url
        self.algorithm = algorithm
        self.proofType = proofType
        self.netHashesPerSecond = netHashesPerSecond
        self.blockNumber = blockNumber
        self.blockTime = blockTime
        self.blockReward = blockReward
        self.type = type
        self.documentType = documentType
        self.remoteIconUrl = remoteIconUrl
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        let internalValue = aDecoder.decodeObject(forKey: "internalValue") as! String
        let imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String
        let url = aDecoder.decodeObject(forKey: "url") as! String
        let algorithm = aDecoder.decodeObject(forKey: "algorithm") as! String
        let proofType = aDecoder.decodeObject(forKey: "proofType") as! String
        let netHashesPerSecond = aDecoder.decodeDouble(forKey: "netHashesPerSecond")
        let blockNumber = aDecoder.decodeInteger(forKey: "blockNumber")
        let blockTime = aDecoder.decodeInteger(forKey: "blockTime")
        let blockReward = aDecoder.decodeDouble(forKey: "blockReward")
        let type = aDecoder.decodeInteger(forKey: "type")
        let documentType = aDecoder.decodeObject(forKey: "documentType") as! String
        let remoteIconUrl = aDecoder.decodeObject(forKey: "remoteIconUrl") as! URL

        self.init(id: id, name: name, fullName: fullName, internalValue: internalValue, imageUrl: imageUrl, url: url, algorithm: algorithm, proofType: proofType, netHashesPerSecond: netHashesPerSecond, blockNumber: blockNumber, blockTime: blockTime, blockReward: blockReward, type: type, documentType: documentType, remoteIconUrl: remoteIconUrl)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(internalValue, forKey: "internalValue")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(algorithm, forKey: "algorithm")
        aCoder.encode(proofType, forKey: "proofType")
        aCoder.encode(netHashesPerSecond, forKey: "netHashesPerSecond")
        aCoder.encode(blockNumber, forKey: "blockNumber")
        aCoder.encode(blockTime, forKey: "blockTime")
        aCoder.encode(blockReward, forKey: "blockReward")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(documentType, forKey: "documentType")
        aCoder.encode(remoteIconUrl, forKey: "remoteIconUrl")
    }
    
    func nameWithSymbol() -> String {
        return "\(self.fullName) (\(self.internalValue))"
    }
    
    static func generateKey(name: String, symbol: String) -> String {
        return name.lowercased() + "(" + symbol.lowercased() + ")"
    }
    
    func isDuplicateSymbol() -> Bool {
        return self.internalValue.range(of: "*") != nil ? true : false
    }
}
