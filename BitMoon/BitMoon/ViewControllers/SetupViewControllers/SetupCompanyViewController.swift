//
//  SetupCompanyViewController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 8..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import MessageUI
import SwiftProgressHUD

class SetupCompanyViewController: SetupViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var facebookTitleLabel: UILabel!
    @IBOutlet weak var twitterTitleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameTitleLabel.text = NSLocalizedString("app_setup_company_name_title", comment: "")
        self.emailTitleLabel.text = NSLocalizedString("app_setup_company_email_title", comment: "")
        self.facebookTitleLabel.text = NSLocalizedString("app_setup_company_facebook_title", comment: "")
        self.twitterTitleLabel.text = NSLocalizedString("app_setup_company_twitter_title", comment: "")
        
        self.nameLabel.text = NSLocalizedString("app_setup_company_name", comment: "")
        self.emailButton.setTitle(NSLocalizedString("app_setup_email_button", comment: ""), for: .normal)
        self.facebookButton.setTitle(NSLocalizedString("app_setup_facebook_button", comment: ""), for: .normal)
        self.twitterButton.setTitle(NSLocalizedString("app_setup_twitter_button", comment: ""), for: .normal)
    }
    
    
    @IBAction func touchedMailButton(_ sender: Any) {
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            ErrorManager.sharedErrorManager.showError(errorCode: "E10009", parent: self)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([NSLocalizedString("app_setup_email_button", comment: "")])
        mailComposerVC.setSubject(NSLocalizedString("mailSubject", comment: ""))
        mailComposerVC.setMessageBody(NSLocalizedString("mailBody", comment: ""), isHTML: false)
        
        return mailComposerVC
    }
    
    @IBAction func touchedFacebookButton(_ sender: Any) {
        guard let url = URL(string: NSLocalizedString("app_setup_facebook_button", comment: "")) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func touchedTwitterButton(_ sender: Any) {
        guard let url = URL(string: NSLocalizedString("app_setup_twitter_button", comment: "")) else { return }
        UIApplication.shared.open(url)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
