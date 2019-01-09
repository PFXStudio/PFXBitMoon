//
//  SetupNavigationController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 7..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let stringFromType = "\(SetupTableViewController.self)"
        let viewController = UIStoryboard.init(name: "Setup", bundle: nil).instantiateViewController(withIdentifier: stringFromType)
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
