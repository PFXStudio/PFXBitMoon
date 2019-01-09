//
//  EventTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 27..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftProgressHUD
import Alamofire
import SwiftyJSON
import SwiftyBeaver

class EventTableViewController: UITableViewController {
    var coinData: CoinData?
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            refreshControl?.endRefreshing()
        }
    }
    
    let log = SwiftyBeaver.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if (self.coinData?.eventDatas.count)! > 0 {
            self.tableView.isHidden = false

            return
        }
        
        self.tableView.isHidden = true
        SwiftProgressHUD.showWait()
        SyncManager.sharedSyncManager.requestCoinMarketCalAuth(completion: { (result) in
            self.requestEvent()
        })

    }
    
    
    func requestEvent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateRangeStart = dateFormatter.string(from: Date())
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let endDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        let dateRangeEnd = dateFormatter.string(from: endDate!)

        var target = ServerInfoData.s_coinMarketCalPath + "v1/events?access_token=" + TokenData.sharedTokenData.accessToken + "&page=1&max=16" + "&dateRangeStart=\(dateRangeStart)&dateRangeEnd=\(dateRangeEnd)"
        if self.coinData != nil {
            let key = self.coinData?.fullName.lowercased()
            if let marketCalCoinData = MarketCalCoinData.sharedMarketCalCoinDataDict.object(forKey: key as Any) as? MarketCalCoinData {
                target = target + "&coins=\(marketCalCoinData.id)"
            }
            else {
                // 해당 id 값이 없으면 패스
                SwiftProgressHUD.hideAllHUD()
                ErrorManager.sharedErrorManager.showError(errorCode: "E10004", parent: self)
                return
            }
        }
        
        self.log.debug("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            if result.isFailure == true {
                self.refreshControl?.endRefreshing()
                self.request = nil
                SwiftProgressHUD.hideAllHUD()
                ErrorManager.sharedErrorManager.showError(errorCode: "E10004", parent: self)
                return
            }
            
            let resultDict = JSON(parseJSON: result.value!).object as? NSDictionary
            if (resultDict?.object(forKey: "error")) != nil {
                ErrorManager.sharedErrorManager.showError(errorCode: "E10006", parent: self)
                
                UserDefaults.standard.removeObject(forKey: DefineStrings.kTokenData)
                UserDefaults.standard.synchronize()
                SyncManager.sharedSyncManager.requestCoinMarketCalAuth(completion: { (result) in
                    self.request = nil
                    self.refreshControl?.endRefreshing()
                    SwiftProgressHUD.hideAllHUD()
                })
                
                return
            }

            self.tableView.isHidden = false
            self.request = nil
            self.log.debug("end request")
            self.refreshControl?.endRefreshing()
            SwiftProgressHUD.hideAllHUD()

            let parser = CoinMarketCalEventParser()
            self.coinData?.eventDatas = parser.parseWithJson(jsonString: result.value!) as! Array<EventData>
            if (self.coinData?.eventDatas.count)! <= 0 {
                SwiftProgressHUD.show(NSLocalizedString("noRegistedEvents", comment: ""), type: SwiftProgressHUDType.fail, autoClear: true)
                UIView.emptyImageView(parentView: self.view)
                return
            }
            
            self.tableView.reloadData()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.coinData?.eventDatas.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.update(coinData: self.coinData as! CoinData, index: indexPath.row)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let viewController = segue.destination as? EventInfoViewController else  { return }
        let indexPath = self.tableView.indexPathForSelectedRow
        let eventData = coinData!.eventDatas[indexPath!.row]
        viewController.eventData = eventData
    }
}
