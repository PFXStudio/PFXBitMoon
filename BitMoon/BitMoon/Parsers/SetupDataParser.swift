//
//  SetupDataParser.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 7..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupDataParser: NSObject {
    
    func loadListFile() -> Bool {

        guard let url = Bundle.main.url(forResource: "setup", withExtension: "plist") else {
            return false
        }
        
        guard let list = NSArray(contentsOf: url) else {
            return false
        }
        
        let groupNameKeys = NSMutableArray()
        for i in 0..<list.count {
            let infoDict = list[i] as! NSDictionary
            if let value = infoDict.object(forKey: "groupNameKey") {
                groupNameKeys.add(value)
            }
            
            if i == 0 {
                SetupData.sharedSetupData.items0 = infoDict.object(forKey: "items") as! NSArray
            }
            else if i == 1 {
                SetupData.sharedSetupData.items1 = infoDict.object(forKey: "items") as! NSArray
            }
            else if i == 2 {
                SetupData.sharedSetupData.items2 = infoDict.object(forKey: "items") as! NSArray
            }
            else if i == 3 {
                SetupData.sharedSetupData.items3 = infoDict.object(forKey: "items") as! NSArray
            }
            else {
                assert(false, "wrong setup.plist")
            }
        }
        
        SetupData.sharedSetupData.groupNameKeys = groupNameKeys
        
        return true
    }

}
