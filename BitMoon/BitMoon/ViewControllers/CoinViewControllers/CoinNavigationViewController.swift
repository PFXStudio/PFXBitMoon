//
//  CoinNavigationViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class CoinNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let stringFromType = "\(CoinTableViewController.self)"
        let viewController = UIStoryboard.init(name: "Coin", bundle: nil).instantiateViewController(withIdentifier: stringFromType)
        self.setViewControllers([viewController], animated: true)
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
