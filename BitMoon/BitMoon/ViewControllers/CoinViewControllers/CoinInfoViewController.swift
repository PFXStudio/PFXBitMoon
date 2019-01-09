//
//  CoinInfoViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 27..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftProgressHUD
import AAInfographics

class CoinInfoViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changePercentageLabel: UILabel!
    
    @IBOutlet weak var historyChartBgndView: UIView!
    var historyChartView: AAChartView!
    var historyDatas = Array<HistoryData>()
    var historyDateLabels = Array<String>()
    var historyValues = Array<Double>()
    
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var lowHighLabel: UILabel!
    
    @IBOutlet weak var dayTypeSegmentedControl: UISegmentedControl!
    
    var coinData: CoinData?
    var priceData: PriceData?
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dayTypeSegmentedControl.setTitle("1H", forSegmentAt: 0)
        self.dayTypeSegmentedControl.setTitle("1D", forSegmentAt: 1)
        self.dayTypeSegmentedControl.setTitle("2W", forSegmentAt: 2)    // 14 day
        self.dayTypeSegmentedControl.setTitle("1M", forSegmentAt: 3)   // 30 day
        self.dayTypeSegmentedControl.setTitle("3M", forSegmentAt: 4)   // 90 day
        self.dayTypeSegmentedControl.setTitle("6M", forSegmentAt: 5)   // 180 day
        self.dayTypeSegmentedControl.setTitle("1Y", forSegmentAt: 6)    // 365 day
        self.dayTypeSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: DefineStrings.kSelectedHistoryType)
        
        self.marketCapLabel.text = ""
        self.volumeLabel.text = ""
        self.openLabel.text = ""
        self.lowHighLabel.text = ""
        
        self.requestPrice(completion: { (result) in
            if result == false {
                return
            }
            
            self.updatePriceView()
            self.requestHistory()
        })
    }
    
    func requestPrice(completion: @escaping ((Bool) -> Void)) {
        SwiftProgressHUD.showWait()
        let internalValue = self.coinData!.internalValue
        let target = ServerInfoData.s_cryptoComparePath + "pricemultifull?fsyms=\(internalValue)&tsyms=\(FilterData.tsym)&api_key=\(KeyData.sharedCryptocompareClientKey)"
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            SwiftProgressHUD.hideAllHUD()
            self.request = nil
            print("end request")

            if result.isFailure == true {
                return
            }
            
            let parser = pricemultifullParser()
            guard let priceDatas = parser.parseWithJson(jsonString: result.value!) as? Array<PriceData> else {
                return
            }
            
            self.priceData = priceDatas[0]
            if self.priceData == nil {
                return
            }
            
            completion(true)
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
    
    func updatePriceView() {
        if self.priceData == nil {
            return
        }
        
        guard let lowDay = self.priceData?.lowDay,
            let highDay = self.priceData?.highDay else {
                return
        }
        
        self.priceLabel.text = self.priceData?.price
        ImageUtil.requestLoad(fileName: self.coinData?.iconFileName, remoteIconUrl: self.coinData?.remoteIconUrl, completion: { (image) in
            if image == nil {
                return
            }
            
            self.iconImageView.image = image
        })
        
        self.marketCapLabel.text = self.priceData?.marketCap
        self.volumeLabel.text = self.priceData?.volume24Hour
        self.openLabel.text = self.priceData?.open24Hour
        self.changePercentageLabel.text = (self.priceData?.changePercentage)! + "%"
        if self.priceData?.changePercentage!.hasPrefix("-") == true {
            self.changePercentageLabel.textColor = DefineColors.kDownPercentageColor
        }
        else  {
            self.changePercentageLabel.textColor = DefineColors.kUpPercentageColor
        }

        self.lowHighLabel.text = "\(lowDay) - \(highDay)"
    }
    
    func requestHistory() {
        SwiftProgressHUD.showWait()
        
        self.historyDateLabels.removeAll()
        self.historyValues.removeAll()

        let internalValue = self.coinData!.internalValue
        var target = ""
        var limit = ""
        var serviceName = ""
        var aggregate = "1"
        let dateFormatter = DateFormatter()
        if self.dayTypeSegmentedControl.selectedSegmentIndex == 0 {
            serviceName = "histominute?"
            limit = "60"
            dateFormatter.dateFormat = "MMM dd, HH:mm"
        }
        else if self.dayTypeSegmentedControl.selectedSegmentIndex == 1 {
            serviceName = "histominute?"
            limit = "288"
            aggregate = "5"
            dateFormatter.dateFormat = "MMM dd, HH:mm"
        }
        else if self.dayTypeSegmentedControl.selectedSegmentIndex == 2 {
            serviceName = "histohour?"
            limit = "336"
            dateFormatter.dateFormat = "MMM dd, HH:00"
        }
        else if self.dayTypeSegmentedControl.selectedSegmentIndex == 3 {
            serviceName = "histohour?"
            limit = "720"
            dateFormatter.dateFormat = "MMM dd, HH:00"
        }
        else if self.dayTypeSegmentedControl.selectedSegmentIndex == 4 {
            serviceName = "histoday?"
            limit = "90"
            dateFormatter.dateFormat = "MMM dd, yyyy"
        }
        else if self.dayTypeSegmentedControl.selectedSegmentIndex == 5 {
            serviceName = "histoday?"
            limit = "180"
            dateFormatter.dateFormat = "MMM dd, yyyy"
        }
        else if self.dayTypeSegmentedControl.selectedSegmentIndex == 6 {
            serviceName = "histoday?"
            limit = "365"
            dateFormatter.dateFormat = "MMM dd, yyyy"
        }
        
        UserDefaults.standard.set(self.dayTypeSegmentedControl.selectedSegmentIndex, forKey: DefineStrings.kSelectedHistoryType)
        UserDefaults.standard.synchronize()
        
        target = ServerInfoData.s_cryptoComparePath + "\(serviceName)fsym=\(internalValue)&tsym=\(FilterData.tsym)&limit=\(limit)&aggregate=\(aggregate)&api_key=\(KeyData.sharedCryptocompareClientKey)"
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            SwiftProgressHUD.hideAllHUD()
            self.request = nil
            print("end request")

            if result.isFailure == true {
                return
            }
            
            let parser = histodayParser()
            self.historyDatas = parser.parseWithJson(jsonString: result.value!) as! [HistoryData]
            for historyData in self.historyDatas {
                let date = NSDate(timeIntervalSince1970: historyData.time)
                self.historyDateLabels.append(dateFormatter.string(from: date as Date))
                self.historyValues.append(historyData.open)
            }

            self.updateHistoryChartView()
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
    
    func updateHistoryChartView() {
        if (self.historyChartView == nil) {
            self.historyChartView = AAChartView()
            self.historyChartView.frame = self.historyChartBgndView.frame
            self.historyChartView.frame.origin = CGPoint(x: 0, y: 0)
            self.historyChartBgndView.addSubview(self.historyChartView)
        }
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(FilterData.tsym, forKey: "name")
        dictionary.setValue(self.historyValues, forKey: "data")

        let chartModel = AAChartModel().chartType(AAChartType.Line).animationType(AAChartAnimationType.BouncePast).title(NSLocalizedString("historyTitle", comment: "")).dataLabelEnabled(false).categories(self.historyDateLabels as Array<Any>).series([dictionary as! Dictionary<String, Any>]).colorsTheme(DefineColors.kChartColors).stacking(.Normal)

        self.historyChartView?.aa_drawChartWithChartModel(chartModel)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    @IBAction func changedDayTypeSegmented(_ sender: Any) {
        self.requestHistory()
    }
}
