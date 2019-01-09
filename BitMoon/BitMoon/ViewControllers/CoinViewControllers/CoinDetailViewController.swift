//
//  CoinDetailViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 27..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftProgressHUD

class CoinDetailViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    var destinationViewController: UIViewController?
    var coinData: CoinData?

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.coinData?.nameWithSymbol()
        self.changedMenuSegmentedControl(self.menuSegmentedControl)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconFavorite"), style: .done, target: self, action: #selector(touchedFavoriteButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if CoreDataManager.sharedCoreDataManager.selectFavoriteData(fullName: self.coinData!.fullName) == nil {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            self.navigationItem.rightBarButtonItem?.tag = 0
        }
        else  {
            self.navigationItem.rightBarButtonItem?.tag = 1
            self.navigationItem.rightBarButtonItem?.tintColor = DefineColors.kMainTintColor
        }
    }
    
    @objc func touchedFavoriteButton() {
        if self.navigationItem.rightBarButtonItem?.tag == 0 {
            
            if self.coinData?.isDuplicateSymbol() == true {
                ErrorManager.sharedErrorManager.showError(errorCode: "E10008", parent: self)
                return
            }
            
            // TODO : purchase
            if let selectFavoriteDatas = CoreDataManager.sharedCoreDataManager.selectFavoriteDatas() {
//                if selectFavoriteDatas.count > DefineNumbers.kPurchaseFavoriteCount && {
//                    // purchase
//                    return
//                }
//
                if selectFavoriteDatas.count > DefineNumbers.kMaxFavoriteCount {
                    // maximum
                    ErrorManager.sharedErrorManager.showError(errorCode: "E10010", parent: self)
                    return
                }
            }
            
            self.navigationItem.rightBarButtonItem?.tag = 1
            self.navigationItem.rightBarButtonItem?.tintColor = DefineColors.kMainTintColor
            
            let data = (try? NSKeyedArchiver.archivedData(withRootObject: self.coinData as Any, requiringSecureCoding: false))
            CoreDataManager.sharedCoreDataManager.addFavoriteData(fullName: (self.coinData?.fullName)!, coinData:data as Any )
            
            SwiftProgressHUD.showSuccess(NSLocalizedString("addedFavorite", comment: ""))
            return
        }
        
        CoreDataManager.sharedCoreDataManager.removeFavoriteData(fullName: (self.coinData?.fullName)!)
        self.navigationItem.rightBarButtonItem?.tag = 0
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray

        SwiftProgressHUD.showInfo(NSLocalizedString("removedFavorite", comment: ""))
    }
    

    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
     */
    @IBAction func changedMenuSegmentedControl(_ sender: Any) {
        if self.destinationViewController != nil {
            self.destinationViewController!.willMove(toParent: nil)
            self.destinationViewController!.view.removeFromSuperview()
            self.destinationViewController!.removeFromParent()
        }
        
        let index = self.menuSegmentedControl.selectedSegmentIndex
        if index == 1 {
            let identifier = "\(EventTableViewController.self)"
            self.destinationViewController = UIStoryboard.init(name: "Event", bundle: nil).instantiateViewController(withIdentifier: identifier)
            if let destination = self.destinationViewController as? EventTableViewController {
                destination.coinData = self.coinData
            }
        }
        else {
            let identifier = "\(CoinInfoViewController.self)"
            self.destinationViewController = UIStoryboard.init(name: "Coin", bundle: nil).instantiateViewController(withIdentifier: identifier)
            if let destination = self.destinationViewController as? CoinInfoViewController {
                destination.coinData = self.coinData
            }

        }

        self.addChild(self.destinationViewController!)
        self.destinationViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.destinationViewController!.view)
        
        NSLayoutConstraint.activate([
            self.destinationViewController!.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.destinationViewController!.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.destinationViewController!.view.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.destinationViewController!.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
            ])
        
        self.destinationViewController!.didMove(toParent: self)
    }
}
