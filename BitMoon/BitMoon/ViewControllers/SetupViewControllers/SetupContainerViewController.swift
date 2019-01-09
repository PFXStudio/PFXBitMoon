//
//  SetupContainerViewController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 8..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupContainerViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var setupDict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let infoDict = self.setupDict.object(forKey: "infoDict") as? NSDictionary else {
            return
        }
        
        guard let identifier = infoDict.object(forKey: "identifier") else {
            return
        }
        
        self.performSegue(withIdentifier: identifier as! String, sender: nil)
        guard let titleKey = self.setupDict.object(forKey: "titleTextKey") as? String else {
            return
        }
        
        self.title = NSLocalizedString(titleKey, comment: "")
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let setupViewController = segue.destination as? SetupViewController else {
            return
        }

        setupViewController.setupDict = self.setupDict
        self.addChild(setupViewController)
        setupViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view .addSubview(setupViewController.view)
        setupViewController.didMove(toParent: self)
    }
}
