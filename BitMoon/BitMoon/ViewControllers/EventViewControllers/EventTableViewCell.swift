//
//  EventTableViewCell.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 28..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire

class EventTableViewCell: UITableViewCell {
    var request: Alamofire.Request?

    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptedLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var voteProgressView: UIProgressView!
    
    @IBOutlet weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(coinData: CoinData, index: Int) {
        let eventData = coinData.eventDatas[index]
        if eventData.isHot == true {
            self.hotImageView.isHidden = false
        }
        else  {
            self.hotImageView.isHidden = true
        }

        self.nameLabel.text = coinData.nameWithSymbol()
        self.titleLabel?.text = eventData.title
        self.dateLabel.text = eventData.date
        self.descriptedLabel.text = eventData.descripted
        self.voteLabel.text = String(format: NSLocalizedString("positiveVoteFormat", comment: ""), eventData.percentage, eventData.positiveVoteCount, eventData.voteCount)
        let percentage = Float(eventData.percentage) / 100.0
        self.voteProgressView.setProgress(percentage, animated: true)
        self.dayLabel.text = eventData.dday()
        
        self.iconImageView.image = nil
        ImageUtil.requestLoad(fileName: coinData.iconFileName, remoteIconUrl: coinData.remoteIconUrl, completion: { (image) in
            if image != nil {
                self.iconImageView.image = image
            }
        })
    }
}
