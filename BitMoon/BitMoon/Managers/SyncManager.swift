//
//  SyncManager.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 28..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftProgressHUD

class SyncManager: NSObject {
    static let sharedSyncManager = SyncManager()
    
    var coinListDict = NSMutableDictionary()
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }

    // delete coredata
    // request coinmarketcap
    // request coinmarketcal
    // insert coredata
    // savecontext
    func requestCoinMarketCapList(completion: ((Bool) -> Void)? = nil) {
        /*
        let target = ServerInfoData.s_coinMarketCapPath + "/listings"
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            if result.isFailure == true {
                completion!(false)
                return
            }
            
            let parser = CoinMarketCapListingsParser()
            parser.parseWithJson(jsonString: result.value!)
            self.request = nil
            print("end request")
            completion!(true)
        }
        
        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        }
 */
    }
    
    func requestCoinMarketCalAuth(completion: ((Bool) -> Void)? = nil) {
        if let userData = UserDefaults.standard.data(forKey: DefineStrings.kTokenData) {
            let tokenData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userData) as! TokenData
            if tokenData!.isExfired() == false {
                TokenData.sharedTokenData.accessToken = (tokenData?.accessToken)!
                TokenData.sharedTokenData.exfireDate = (tokenData?.exfireDate)!

                completion!(true)
                return
            }
        }
        
        let target = ServerInfoData.s_coinMarketCalPath + "oauth/v2/token?client_id=\(KeyData.sharedCoinMarketCalClientKey)&client_secret=\(KeyData.sharedCoinMarketCalSecretKey)&grant_type=client_credentials"
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            if result.isFailure == true {
                completion!(false)
                return
            }
            
            let parser = CoinMarketCalAuthParser()
            let tokenData = parser.parseWithJson(jsonString: result.value!) as? TokenData
            TokenData.sharedTokenData.accessToken = (tokenData?.accessToken)!
            TokenData.sharedTokenData.exfireDate = (tokenData?.exfireDate)!

            let data = (try? NSKeyedArchiver.archivedData(withRootObject: tokenData as Any, requiringSecureCoding: false))
            UserDefaults.standard.set(data, forKey: DefineStrings.kTokenData)
            UserDefaults.standard.synchronize()
            
            self.request = nil
            completion!(true)
        }
        
        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        }
    }
    
    func requestCoinMarketCalCoins(completion: ((Bool) -> Void)? = nil) {
        let target = ServerInfoData.s_coinMarketCalPath + "v1/coins?access_token=" + TokenData.sharedTokenData.accessToken
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            SwiftProgressHUD.hideAllHUD()
            self.request = nil
            
            if result.isFailure == true {
//                ErrorManager.sharedErrorManager.showError(errorCode: "E10003", parent: self)
                return
            }
            
            let parser = CoinMarketCalCoinsParser()
            parser.parseWithJson(jsonString: result.value!)
            if MarketCalCoinData.sharedMarketCalCoinDataDict.count <= 0 {
                return
            }
            
            completion!(true)
        }
        
        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        }
    }
    
    func insertCoinInfos(completion: ((Bool) -> Void)? = nil) {
        
    }
    
    func deleteCoinInfos(completion: ((Bool) -> Void)? = nil) {
        
    }
    
    func sync(completion: ((Bool) -> Void)? = nil) {
        SwiftProgressHUD.showWait()
        self.requestCoinMarketCalAuth(completion: { (result) in
            if result == false {
                completion!(false)
                SwiftProgressHUD.hideAllHUD()
                return
            }
            
            self.requestCoinMarketCalCoins(completion: { (result) in
                if result == false {
                    completion!(false)
                    SwiftProgressHUD.hideAllHUD()
                    return
                }
                
                // Sync
                
                completion!(true)
            })

        })
    }
}
