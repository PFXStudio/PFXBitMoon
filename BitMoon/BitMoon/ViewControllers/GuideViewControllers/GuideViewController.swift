//
//  GuideViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 10. 23..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import paper_onboarding
import AWSAuthCore
import AWSAuthUI
import AWSCognitoIdentityProvider

class GuideViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {

    @IBOutlet weak var paperView: PaperOnboarding!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.paperView.delegate = self
        
        if UserDefaults.standard.bool(forKey: DefineStrings.kCompletedGuide) == true {
            self.showMain()
            return
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if (index != 2) {
            return
        }
        
        /*
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
                                            self.showMain()
                                        }
                })
            
            return
        }
        */
        self.showMain()
    }
    
    func showMain() {
        UserDefaults.standard.set(true, forKey: DefineStrings.kCompletedGuide)
        let viewController = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "RAMAnimatedTabBarController")
        self .present(viewController, animated: false, completion: nil)
    }
    
    func onboardingItemsCount() -> Int {
        return 3;
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bottomImage: UIImage = UIImage(named: "iconMore")!
        let blackImage: UIImage = UIImage(named: "iconBitcoin-256")!
        let mediaImage: UIImage = UIImage(named: "iconBitMoon-256")!

        return [
            OnboardingItemInfo(informationImage: blackImage,
                               title: NSLocalizedString("guideTitle0", comment: ""),
                               description: NSLocalizedString("guideContents0", comment: ""),
                               pageIcon: bottomImage,
                               color: DefineColors.kMainTintColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                               descriptionFont: UIFont.systemFont(ofSize: 14)),
            
            OnboardingItemInfo(informationImage: mediaImage,
                               title: NSLocalizedString("guideTitle1", comment: ""),
                               description: NSLocalizedString("guideContents1", comment: ""),
                               pageIcon: bottomImage,
                               color: DefineColors.kUpPercentageColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                            descriptionFont: UIFont.systemFont(ofSize: 14)),

            OnboardingItemInfo(informationImage: mediaImage,
                               title: "",
                               description: "",
                               pageIcon: bottomImage,
                               color: DefineColors.kUpPercentageColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                               descriptionFont: UIFont.systemFont(ofSize: 10)),
            ][index]
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
