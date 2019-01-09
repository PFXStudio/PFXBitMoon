//
//  FavoriteTableViewCell.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 17..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    //    @IBOutlet weak var changePercent7dLabel: UILabel!
    @IBOutlet weak var changePercent24hLabel: UILabel!
    //    @IBOutlet weak var changePercent1hLabel: UILabel!
    
    @IBOutlet weak var currentVolumeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var symbolLeadingConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var coinData: CoinData?
    var index = 0
    var request: Alamofire.Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateHeaderView() {
        self.symbolLeadingConstraint.constant = DefineNumbers.kHeaderSymbolLeadingConstraint
        self.backgroundColor = UIColor.white
        self.addShadow(offset: .zero, opacity: 0.35, radius: 10, color: .lightGray)
        self.iconImageView.image = nil
        self.symbolLabel.text = NSLocalizedString("symbol", comment: "")
        self.symbolLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        self.changePercent24hLabel.text = NSLocalizedString("change24h", comment: "")
        self.changePercent24hLabel.textColor = UIColor.darkGray
        self.currentVolumeLabel.text = NSLocalizedString("volume", comment: "")
        self.currentVolumeLabel.textAlignment = NSTextAlignment.center
        self.currentPriceLabel.text = NSLocalizedString("currentPrice", comment: "")
        self.dayLabel.isHidden = true
        self.titleLabel.isHidden = true
    }
    
    func update(coinData: CoinData) {
        self.symbolLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        self.backgroundColor = UIColor.clear
        if (self.request != nil) {
            self.request?.cancel()
            self.request = nil
        }
        
        guard let priceData = coinData.priceData else { return }
        self.coinData = coinData
        self.symbolLabel.text = coinData.internalValue
        
        self.iconImageView.image = nil
        ImageUtil.requestLoad(fileName: coinData.iconFileName, remoteIconUrl: coinData.remoteIconUrl, completion: { (image) in
            if image != nil {
                self.iconImageView.image = image
            }
        })
        
        let greenColor = DefineColors.kUpPercentageColor
        self.changePercent24hLabel.textColor = greenColor
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        // localize to your grouping and decimal separator
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        
        let currencyCode = FilterData.tsym
        let localeComponents = NSDictionary(dictionary: [NSLocale.Key.currencyCode : currencyCode as Any])
        let localeIdentifier = NSLocale.localeIdentifier(fromComponents: localeComponents as! [String : String])
        let locale = NSLocale(localeIdentifier: localeIdentifier)
        let currencySymbol = locale.object(forKey: NSLocale.Key.currencySymbol) as! String
        
        self.currentPriceLabel.text = priceData.price
        if let changePercent24h = priceData.changePercentage {
            self.changePercent24hLabel.text = changePercent24h + "%"
            if changePercent24h.hasPrefix("-") == true {
                self.changePercent24hLabel.textColor = DefineColors.kDownPercentageColor
            }
        }
        else {
            self.changePercent24hLabel.text = "0%"
            self.changePercent24hLabel.textColor = UIColor.lightGray
        }
        
        if let changeVolume = priceData.volume24Hour {
            self.currentVolumeLabel.text = changeVolume
        }
        
        self.updateEventView()
        
    }
    
    func updateEventView() {
        if (self.coinData?.eventDatas.count)! <= 0 {
            self.dayLabel.isHidden = true
            self.titleLabel.isHidden = true
            return
        }
        
        self.dayLabel.isHidden = false
        self.titleLabel.isHidden = false
        self.index = 0
        let eventData = self.coinData?.eventDatas[self.index]
        self.dayLabel.text = eventData?.dday()
        self.titleLabel.text = eventData?.title
        
        if self.timer != nil {
            self.timer?.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            // update
            self.index += 1
            if self.index >= (self.coinData?.eventDatas.count)! {
                self.index = 0
            }
            
            let eventData = self.coinData?.eventDatas[self.index]
            self.dayLabel.text = eventData?.dday()
            self.titleLabel.text = eventData?.title
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
                return
            }
        }
        
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            if result.isFailure == true {
                self.request = nil
                return
            }
            
            self.request = nil
            let parser = CoinMarketCalEventParser()
            self.coinData?.eventDatas = parser.parseWithJson(jsonString: result.value!) as! Array<EventData>
            self.updateEventView()
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
    
    func didEndDisplaying() {
        self.index = 0
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        if self.request == nil {
            return
        }
        
        self.request?.cancel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
