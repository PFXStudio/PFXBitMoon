//
//  AccountViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 10. 19..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCognitoIdentityProvider
import SwiftProgressHUD

class AccountViewController: UIViewController {
    
    @IBOutlet weak var stateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        // Do any additional setup after loading the view.
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            self.showLogin()
            return;
        }
        
        self.updateProfile()
    }
    
    func showLogin() {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: nil,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // Sign in successful.
                                            let identityProviderName = provider.identityProviderName
                                            print("identityProviderName: \(identityProviderName)")
                                            let defaults = UserDefaults.standard
                                            defaults.set(identityProviderName, forKey:DefineStrings.kIdentityProviderName)
                                        }
                })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func touchedStateButton(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Notice", message: "Are you sure logout?", preferredStyle: UIAlertController.Style.alert)
        let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) { (UIAlertAction) in
            SwiftProgressHUD.showWait()
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                print("Sign-out Successful");
                SwiftProgressHUD.hideAllHUD()
                self.showLogin()
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: DefineStrings.kIdentityProviderName)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            
        }
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateProfile() {
    }
}
