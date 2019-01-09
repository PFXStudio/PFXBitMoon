//
//  CoinTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftProgressHUD
import PopMenu

class CoinTableViewController: UITableViewController {
    var coinDatas = Array<CoinData>()
    var page = 0
    var limit = 100
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            refreshControl?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("loadingTitle", comment: ""))
        self.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconMore"), style: UIBarButtonItem.Style.done, target: self, action: #selector(touchedFilterButton))

        self.title = NSLocalizedString("CoinTableViewController", comment: "")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        if let tsym = UserDefaults.standard.string(forKey: DefineStrings.kTsym) {
            FilterData.tsym = tsym
        }
                
        SyncManager.sharedSyncManager.sync { (result) in
            if result == false {
                return
            }
            
            self.refresh()
        }
    }
    
    @objc func touchedFilterButton() {
        let actions = [
            PopMenuDefaultAction(title: "USD", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "USD"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "USDT", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "USDT"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "BTC", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "BTC"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "ETH", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "ETH"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "EUR", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "EUR"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "GBP", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "GBP"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "JPY", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "JPY"
                self.refresh()
            }),
            PopMenuDefaultAction(title: "KRW", image: nil, color: nil, didSelect: { (action) in
                FilterData.tsym = "KRW"
                self.refresh()
            })
        ]
        
        let popMenu = PopMenuViewController(actions: actions)
        popMenu.appearance.popMenuBackgroundStyle = .blurred(.light)
        self.present(popMenu, animated: true, completion:nil)
    }
    
    func requestList() {
        SwiftProgressHUD.showWait()
        let target = ServerInfoData.s_cryptoComparePath + "top/totalvolfull?limit=\(self.limit)&tsym=\(FilterData.tsym)&page=\(self.page)&api_key=\(KeyData.sharedCryptocompareClientKey)"
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

            let parser = totalvolfullParser()
            let coinDatas = parser.parseWithJson(jsonString: result.value!) as! Array<CoinData>
            for coinData in coinDatas {
                self.coinDatas.append(coinData)
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
    
    @IBAction func refresh() {
        UserDefaults.standard.set(FilterData.tsym, forKey: DefineStrings.kTsym)
        UserDefaults.standard.synchronize()

        self.request?.cancel()
        
        refreshControl?.beginRefreshing()
        self.page = 0
        self.coinDatas.removeAll()
        self.tableView.reloadData()
        self.requestList()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.coinDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as! CoinTableViewCell

        let coinData = self.coinDatas[indexPath.row]
        // Configure the cell...
        cell.update(coinData: coinData)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row >= self.coinDatas.count - 1 && self.request == nil) {
            self.page += 1
            self.requestList()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell") as! CoinTableViewCell
        cell.updateHeaderView()
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = DefineColors.kMainTintColor
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
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
        if let destination = segue.destination as? CoinDetailViewController {
            let indexPath = self.tableView.indexPathForSelectedRow
            let coinData = self.coinDatas[(indexPath?.row)!] 
            destination.coinData = coinData
        }
    }
}
