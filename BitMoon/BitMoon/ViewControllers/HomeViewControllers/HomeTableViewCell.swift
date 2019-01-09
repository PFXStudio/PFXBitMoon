//
//  HomeTableViewCell.swift
//  BitMoon
//
//  Created by succorer on 2018. 10. 17..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import FoldingCell
import UIKit

class HomeTableViewCell: FoldingCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var exProfileImageView: UIImageView!
    
    @IBOutlet weak var exNameLabel: UILabel!
    
    @IBOutlet weak var exTeamLabel: UILabel!
    
    @IBOutlet weak var exAddressLabel: UILabel!
    
    @IBOutlet weak var exPhoneButton: UIButton!
    
    @IBOutlet weak var exEmailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func updateWithProfiles(profiles: Profiles) {
        self.nameLabel.text = profiles._name
        if (profiles._name == "Mina") {
            self.profileImageView.image = UIImage(named: "profileMina")
            self.exProfileImageView.image = UIImage(named: "profileMina")
        }
        else if (profiles._name == "Semi") {
            self.profileImageView.image = UIImage(named: "profileSemi")
            self.exProfileImageView.image = UIImage(named: "profileSemi")
        }
        else {
            self.profileImageView.image = UIImage(named: "profileJohn")
            self.exProfileImageView.image = UIImage(named: "profileJohn")
        }
        
        self.teamLabel.text = profiles._team
        self.addressLabel.text = profiles._address
        self.exNameLabel.text = profiles._name
        self.exTeamLabel.text = profiles._team
        self.exAddressLabel.text = profiles._address
        self.exPhoneButton.setTitle(profiles._phone, for: UIControl.State.normal)
        self.exEmailButton.setTitle(profiles._email, for: UIControl.State.normal)
    }
}
