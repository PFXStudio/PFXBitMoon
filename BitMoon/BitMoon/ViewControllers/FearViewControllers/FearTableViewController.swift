//
//  FearTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import WebKit
import AAInfographics
import SwiftProgressHUD
import Alamofire
import SwiftyJSON

class FearTableViewController: UITableViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var fearChartBgndView: UIView!
    @IBOutlet weak var turtleChartBgndView: UIView!
    var fearChartView: AAChartView!
    var turtleChartView: AAChartView!
    var chartInfoParser: ServiceParser!

    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            
            title = request?.description
            refreshControl?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("loadingTitle", comment: ""))
        self.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        self.refresh(self.tableView)
    }
    
    @objc func refresh(_ sender: Any) {
        // Call webservice here after reload tableview.
        self.webView.isHidden = true
        SwiftProgressHUD.showWait()
//        self.requestTurtle()
        self.bithumbRequest()
    }
    
    func bithumbRequest() {
        let target = "https://api.bithumb.com/public/btci"
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            let jsonDict = JSON(parseJSON: result.value!).object as! NSDictionary
            let status = jsonDict.object(forKey: "status") as! NSString
            guard status.isEqual("0000") else {
                return
            }
            
            let dataDict = jsonDict.object(forKey: "data") as! NSDictionary
            let btai = dataDict.object(forKey: "btai") as! String
            let btmi = dataDict.object(forKey: "btmi") as! String
            
            ChartData.sharedBithumbLabels.removeAllObjects()
            ChartData.sharedBithumbLabels.add("All Index(%)")
            ChartData.sharedBithumbLabels.add("Altcoin Index(%)")
            ChartData.sharedBithumbDatas.add(Int(Double(btai)! / 10))
            ChartData.sharedBithumbDatas.add(Int(Double(btmi)! / 10))
            self.updateBithumbChart()
            self.requestFear()
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
    
    func requestTurtle() {
        self.chartInfoParser = TurtleHtmlParser()
        self.webView.load(URLRequest.init(url: URL(string: "https://www.turtlebc.com/tools/buy_percentage?period=1year")!))
        self.webView.navigationDelegate = self
    }

    func requestFear() {
        self.chartInfoParser = FearHtmlParser()
        self.webView.load(URLRequest.init(url: URL(string: "https://alternative.me/crypto/fear-and-greed-index/")!))
        self.webView.navigationDelegate = self
    }

    // MARK: - Table view data source
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                        completionHandler: { (html: Any?, error: Error?) in
                                            let result = self.chartInfoParser.parseWithHtml(htmlString: html as! String)
                                            if (result == false) {

                                                return
                                            }
                                            
                                            if self.chartInfoParser is FearHtmlParser {
                                                self.updateFearChart()
                                                SwiftProgressHUD.hideAllHUD()
                                                self.refreshControl?.endRefreshing()
                                            }
                                            else if self.chartInfoParser is TurtleHtmlParser {
                                                self.updateTurtleChart()
                                                self.requestFear()
                                            }
        })
    }
    
    func updateBithumbChart() {
        if (self.turtleChartView == nil) {
            self.turtleChartView = AAChartView()
            self.turtleChartView.frame = self.turtleChartBgndView.frame
            self.turtleChartBgndView.addSubview(self.turtleChartView)
        }
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(NSLocalizedString("buyMarketTitle", comment: ""), forKey: "name")
        dictionary.setValue(ChartData.sharedBithumbDatas, forKey: "data")
        
        let chartModel = AAChartModel().chartType(AAChartType.Column).animationType(AAChartAnimationType.BouncePast).title(NSLocalizedString("buyMarketIndexTitle", comment: "")).dataLabelEnabled(true).categories(ChartData.sharedBithumbLabels as! Array<Any>).series([dictionary as! Dictionary<String, Any>]).colorsTheme(DefineColors.kChartColors).stacking(.Normal)
        
        self.turtleChartView?.aa_drawChartWithChartModel(chartModel)
    }
    
    func updateTurtleChart() {
        if (self.turtleChartView == nil) {
            self.turtleChartView = AAChartView()
            self.turtleChartView.frame = self.turtleChartBgndView.frame
            self.turtleChartBgndView.addSubview(self.turtleChartView)
        }
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(NSLocalizedString("buyMarketTitle", comment: ""), forKey: "name")
        dictionary.setValue(ChartData.sharedBuyMarketDatas, forKey: "data")
        
        let chartModel = AAChartModel().chartType(AAChartType.Line).animationType(AAChartAnimationType.BouncePast).title(NSLocalizedString("buyMarketIndexTitle", comment: "")).dataLabelEnabled(false).categories(ChartData.sharedBuyMarketLabels as! Array<Any>).series([dictionary as! Dictionary<String, Any>]).colorsTheme(DefineColors.kChartColors)
        
        self.turtleChartView?.aa_drawChartWithChartModel(chartModel)
    }
    
    func updateFearChart() {
        if (self.fearChartView == nil) {
            self.fearChartView = AAChartView()
            self.fearChartView.frame = self.fearChartBgndView.frame
            self.fearChartBgndView.addSubview(self.fearChartView)
        }
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(NSLocalizedString("cryptoGreedTitle", comment: ""), forKey: "name")
        dictionary.setValue(ChartData.sharedFearDatas, forKey: "data")
        
        let chartModel = AAChartModel().chartType(AAChartType.Line).animationType(AAChartAnimationType.BouncePast).title(NSLocalizedString("cryptoFearGreedIndexTitle", comment: "")).dataLabelEnabled(false).categories(ChartData.sharedFearLabels as! Array<Any>).series([dictionary as! Dictionary<String, Any>]).colorsTheme(DefineColors.kChartColors)
        
        self.fearChartView?.aa_drawChartWithChartModel(chartModel)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SwiftProgressHUD.hideAllHUD()
        let alertController = UIAlertController(title: NSLocalizedString("noticeTitle", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("doneButtonTitle", comment: ""), style: .default) { (UIAlertAction) in
            alertController .dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
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
