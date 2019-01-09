//
//  FavoriteNavigationController.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class FavoriteNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let stringFromType = "\(FavoriteTableViewController.self)"
        let viewController = UIStoryboard.init(name: "Favorite", bundle: nil).instantiateViewController(withIdentifier: stringFromType)
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
