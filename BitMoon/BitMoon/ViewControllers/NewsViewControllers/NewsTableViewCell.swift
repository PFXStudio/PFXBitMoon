//
//  NewsTableViewCell.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(newsData: NewsData) {
        let second = Int(NSDate().timeIntervalSince1970) - Int(newsData.published_on)
        var dateText = ""
        if second < 60 {
            // Second
            dateText = String(format: NSLocalizedString("secondAgo", comment: ""), second)
        }
        else if second < 3600 {
            // minute
            dateText = String(format: NSLocalizedString("minuteAgo", comment: ""), second / 60)
        }
        else if second < 86400 {
            // hour
            dateText = String(format: NSLocalizedString("hourAgo", comment: ""), second / 3600)
        }
        else {
            // day
            dateText = String(format: NSLocalizedString("dayAgo", comment: ""), second / 86400)
        }

        self.sourceLabel.text = newsData.source
        self.titleLabel.text = newsData.title
        self.bodyLabel.text = newsData.body
        self.dateLabel.text = dateText
        
        let fileName = (newsData.imageurl as NSString).lastPathComponent
        ImageUtil.requestLoad(fileName: fileName, remoteIconUrl: URL(string: newsData.imageurl)) { (image) in
            if image == nil {
                return
            }
            
            self.iconImageView.image = image
        }
    }
}
