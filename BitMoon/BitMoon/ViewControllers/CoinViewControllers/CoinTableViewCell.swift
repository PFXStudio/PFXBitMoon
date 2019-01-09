//
//  CoinTableViewCell.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 16..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CoinTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
//    @IBOutlet weak var changePercent7dLabel: UILabel!
    @IBOutlet weak var changePercent24hLabel: UILabel!
//    @IBOutlet weak var changePercent1hLabel: UILabel!
    
    @IBOutlet weak var currentVolumeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!

    @IBOutlet weak var symbolLeadingConstraint: NSLayoutConstraint!
    
    var request: Alamofire.Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    }
    
    func update(coinData: CoinData) {
        self.symbolLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        self.backgroundColor = UIColor.clear
        if (self.request != nil) {
            self.request?.cancel()
            self.request = nil
        }
        
        guard let priceData = coinData.priceData else { return }
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
        
    }
    
    func didEndDisplaying() {
        if self.request == nil {
            return
        }
        
        self.request?.cancel()
    }
}
