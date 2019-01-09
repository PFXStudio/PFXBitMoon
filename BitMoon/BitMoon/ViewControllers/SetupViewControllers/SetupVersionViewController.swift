//
//  SetupVersionViewController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 8..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupVersionViewController: SetupViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var osVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.4;
        animation.repeatCount = 2;
        animation.autoreverses = true;
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 1.2)
        self.logoImageView.layer.add(animation, forKey: "scale-layer")
        let version = NSString(format: "%@ %@", NSLocalizedString("app_setup_version_current", comment: ""), self.setupDict.object(forKey: "rightTextKey") as! CVarArg)

        self.currentVersionLabel.text = version as String
        self.osVersionLabel.text = NSLocalizedString("app_setup_version_os", comment: "")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
