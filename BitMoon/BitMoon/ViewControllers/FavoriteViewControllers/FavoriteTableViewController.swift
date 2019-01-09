//
//  FavoriteTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftProgressHUD

class FavoriteTableViewController: UITableViewController {
    var emptyImageView: UIImageView?
    var index = 0
    var limit = 30
    
    var coinDict = Dictionary<String, CoinData>()
    var coinNameDict = Dictionary<String, CoinData>()
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            refreshControl?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.title = NSLocalizedString("FavoriteTableViewController", comment: "")
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("loadingTitle", comment: ""))
        self.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if CoreDataManager.sharedCoreDataManager.selectFavoriteDatas() != nil && (CoreDataManager.sharedCoreDataManager.selectFavoriteDatas()?.count)! > 0 {
            return
        }
        
        if UserDefaults.standard.bool(forKey: DefineStrings.kInitializeFavoriteCoin) == true {
            return
        }
        
        UserDefaults.standard.set(true, forKey: DefineStrings.kInitializeFavoriteCoin)
        let coinData = CoinData(id: "1182", name: "BTC", fullName: "Bitcoin", internalValue: "BTC", imageUrl: "/media/19633/btc.png", url: "/coins/btc/overview", algorithm: "SHA256", proofType: "PoW", netHashesPerSecond: 36553756867.6572, blockNumber: 554725, blockTime: 600, blockReward: 12.5, type: 1, documentType: "Webpagecoinp", remoteIconUrl: URL(string: "https://www.cryptocompare.com/media/19633/btc.png")!)
        let data = (try? NSKeyedArchiver.archivedData(withRootObject: coinData as Any, requiringSecureCoding: false))
        CoreDataManager.sharedCoreDataManager.addFavoriteData(fullName: coinData.fullName, coinData:data as Any )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refresh()
    }
    
    @objc func touchedAddButton() {
        
    }
    
    func loadCoreDatas() {
        self.coinDict.removeAll()
        self.coinNameDict.removeAll()
        if self.emptyImageView != nil {
            self.emptyImageView?.removeFromSuperview()
            self.emptyImageView = nil
        }
        
        guard let datas = CoreDataManager.sharedCoreDataManager.selectFavoriteDatas() else  {
            self.refreshControl?.endRefreshing()
            SwiftProgressHUD.hideAllHUD()

            DispatchQueue.main.async {
                SwiftProgressHUD.show(NSLocalizedString("emptyFavorite", comment: ""), type: SwiftProgressHUDType.fail, autoClear: true)
                self.emptyImageView = UIView.emptyImageView(parentView: self.tableView)
                self.tableView.separatorStyle = .none
            }
            
            return
        }

        self.tableView.separatorStyle = .singleLine

        for data in datas {
            let coinData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as! CoinData
            self.coinDict[(coinData?.internalValue)!] = coinData
            self.coinNameDict[(coinData?.fullName.lowercased())!] = coinData
        }
    }
    
    @IBAction func refresh() {
        self.request?.cancel()
        
        refreshControl?.beginRefreshing()
        self.index = 0
        self.loadCoreDatas()
        self.requestList()
    }

    func requestList() {
        if self.index >= self.coinDict.count {
            return
        }
        
        var symbols = ""
        let max = min(self.index + self.limit, self.coinDict.count - 1)
        for i in self.index...max {
            let coinData = Array(self.coinDict.values)[i]
            symbols.append(coinData.internalValue + ",")
        }
        
        SwiftProgressHUD.showWait()
        let target = ServerInfoData.s_cryptoComparePath + "pricemultifull?fsyms=\(symbols)&tsyms=\(FilterData.tsym)&api_key=\(KeyData.sharedCryptocompareClientKey)"
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            self.refreshControl?.endRefreshing()
            SwiftProgressHUD.hideAllHUD()
            self.request = nil
            print("end request")
            
            if result.isFailure == true {
                return
            }
            
            let parser = pricemultifullParser()
            let priceDatas = parser.parseWithJson(jsonString: result.value!) as! Array<PriceData>
            for priceData in priceDatas {
                guard let coinData = self.coinDict[priceData.internalValue] else {
                    print("empty priceData.internalValue : \(priceData.internalValue)")
                    continue
                    
                }
                coinData.priceData = priceData
//                self.coinDatas.append(coinData)
            }

            SyncManager.sharedSyncManager.requestCoinMarketCalAuth(completion: { (result) in
                self.requestEventList()
            })

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

    func requestEventList() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateRangeStart = dateFormatter.string(from: Date())
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let endDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        let dateRangeEnd = dateFormatter.string(from: endDate!)
        
        var target = ServerInfoData.s_coinMarketCalPath + "v1/events?access_token=" + TokenData.sharedTokenData.accessToken + "&page=1&max=16" + "&dateRangeStart=\(dateRangeStart)&dateRangeEnd=\(dateRangeEnd)"
        
        var marketCalCoinDatas = Array<MarketCalCoinData>()
        for i in 0...self.coinDict.count - 1 {
            let coinData = Array(self.coinDict.values)[i]
            let key = coinData.fullName.lowercased()
            if let marketCalCoinData = MarketCalCoinData.sharedMarketCalCoinDataDict.object(forKey: key as Any) as? MarketCalCoinData {
                marketCalCoinDatas.append(marketCalCoinData)
            }
            else {
                continue
            }
        }
        
        var coins = "&coins="
        for marketCalCoinData in marketCalCoinDatas {
            coins = coins + marketCalCoinData.id
            if marketCalCoinData != marketCalCoinDatas.last {
                coins = coins + ","
            }
        }
        
        target = target + coins
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            self.refreshControl?.endRefreshing()
            SwiftProgressHUD.hideAllHUD()
            self.request = nil
            print("end request")

            if result.isFailure == true {
                self.request = nil
                return
            }
            
            self.request = nil
            let parser = CoinMarketCalEventParser()
            let eventDatas = parser.parseWithJson(jsonString: result.value!) as! Array<EventData>
            if (eventDatas.count) <= 0 {
                return
            }

            for eventData in eventDatas {
                for coinDict in eventData.coins {
                    let symbol = coinDict["symbol"] as? String
                    let coinName = coinDict["name"] as? String
                    if let coinData = self.coinDict[symbol!] {
                        coinData.eventDatas.append(eventData)
                    }
                    else if let coinData = self.coinNameDict[(coinName?.lowercased())!] {
                        coinData.eventDatas.append(eventData)
                    }
                }
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
        return self.coinDict.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(FavoriteTableViewCell.self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FavoriteTableViewCell
        let key = Array(self.coinDict.keys)[indexPath.row]
        let coinData = self.coinDict[key]
        cell.update(coinData: coinData!)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell {
            cell.didEndDisplaying()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let key = Array(self.coinDict.keys)[indexPath.row]
        let coinData = self.coinDict[key]
        return (coinData?.eventDatas.count)! > 0 ? 80 : 48
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "\(FavoriteTableViewCell.self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! FavoriteTableViewCell
        cell.updateHeaderView()
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let key = Array(self.coinDict.keys)[indexPath.row]
            guard let coinData = self.coinDict[key] else { return }
            CoreDataManager.sharedCoreDataManager.removeFavoriteData(fullName: coinData.fullName)
            self.coinDict.removeValue(forKey: key)
            tableView.deleteRows(at: [indexPath], with: .fade)
            guard let datas = CoreDataManager.sharedCoreDataManager.selectFavoriteDatas() else  {
                self.loadCoreDatas()
                return
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = DefineColors.kMainTintColor

        let key = Array(self.coinDict.keys)[indexPath.row]
        let coinData = self.coinDict[key]
        
        let stringFromType = "\(CoinDetailViewController.self)"
        let viewController = UIStoryboard.init(name: "Coin", bundle: nil).instantiateViewController(withIdentifier: stringFromType) as? CoinDetailViewController
        viewController?.coinData = coinData
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
    }

    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
