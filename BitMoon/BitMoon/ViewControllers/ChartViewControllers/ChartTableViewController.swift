//
//  ChartTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 21..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PopMenu

class ChartTableViewController: UITableViewController {

    var selectedMarketData: MarketData? = nil
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

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.title = "aaa"
        
        var target = "https://api.nomics.com/v1/markets?key=\(KeyData.sharedNomicsKey)"
        if let selectedMarketData = UserDefaults.standard.data(forKey: DefineStrings.kSelectedMarketData) {
            self.selectedMarketData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(selectedMarketData) as! MarketData
        }
        else {
            self.selectedMarketData = MarketData(exchange: "binance", quoteDict: Dictionary(), quoteKey: "USDT", iconName: "iconBinance")
            let data = (try? NSKeyedArchiver.archivedData(withRootObject: self.selectedMarketData!, requiringSecureCoding: false))
            UserDefaults.standard.set(data, forKey: DefineStrings.kSelectedMarketData)
            UserDefaults.standard.synchronize()
        }

        target = "https://api.nomics.com/v1/markets?key=\(KeyData.sharedNomicsKey)&exchange=\(self.selectedMarketData!.exchange)&quote=\(self.selectedMarketData!.quoteKey)"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(touchedFilterButton(sender:)))
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            let marketParser = NomicsMarketParser()
            marketParser.parse(string: result.value!)
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
    
    @objc func touchedFilterButton(sender: UIBarButtonItem?) {
        var actions = Array<PopMenuDefaultAction>()
        let allValues = MarketData.sharedMarketDataDict.allValues
        for value in allValues {
            let marketData = value as! MarketData
            for quote in marketData.quoteDict.values {
                let action = PopMenuDefaultAction(title: "\(marketData.exchange.uppercased()) : \(quote)", image: UIImage(named: marketData.iconName), color: nil) { (PopMenuAction) in
                    print("selected \(marketData.exchange) : \(quote)")
                }
                
                actions.append(action)
            }
        }

        let menuViewController = PopMenuViewController(actions: actions)
        self.present(menuViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
