//
//  SetupData.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 7..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupData: NSObject {
    var groupNameKeys = NSArray()
    var items0 = NSArray()
    var items1 = NSArray()
    var items2 = NSArray()
    var items3 = NSArray()
    
    static let sharedSetupData = SetupData()
    
    func infoDict(indexPath: IndexPath) -> NSDictionary? {
        if indexPath.section == 0 {
            return (self.items0.object(at: indexPath.row) as! NSDictionary)
        }
        else if indexPath.section == 1 {
            return (self.items1.object(at: indexPath.row) as! NSDictionary)
        }
        else if indexPath.section == 2 {
            return (self.items2.object(at: indexPath.row) as! NSDictionary)
        }
        else if indexPath.section == 3 {
            return (self.items3.object(at: indexPath.row) as! NSDictionary)
        }
        
        return nil
    }
}
