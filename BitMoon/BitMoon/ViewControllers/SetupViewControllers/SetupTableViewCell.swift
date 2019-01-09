//
//  SetupTableViewCell.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 7..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var infoDict: NSDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(infoDict: NSDictionary) {
        self.titleLabel.text = ""
        self.infoLabel.text = ""
        
        self.infoDict = infoDict
        if let titleTextKey = infoDict.object(forKey: "titleTextKey") {
            self.titleLabel.text = NSLocalizedString(titleTextKey as! String, comment: "")
        }
        
        if let infoTextKey = infoDict.object(forKey: "rightTextKey") {
            self.infoLabel.text = NSLocalizedString(infoTextKey as! String, comment: "")
        }
    }
}
