//
//  SetupWebViewController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 8..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftProgressHUD

class SetupWebViewController: SetupViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let infoDict = self.setupDict.object(forKey: "infoDict") as? NSDictionary else { return }
        let fileName = infoDict.object(forKey: "fileName") as? String
        let remote = infoDict.object(forKey: "remote") as? String
        
        var targetURL: URL?
        if fileName != nil && (fileName?.count)! > 0 {
            if let targetPath = Bundle.main.path(forResource: fileName, ofType: "html") {
                targetURL = URL(fileURLWithPath: targetPath)
            }
        }
        else if remote != nil && remote!.count > 0 {
            targetURL = URL(string: remote!)
        }

        if targetURL != nil {
            let urlRequest = URLRequest(url: targetURL!)
            SwiftProgressHUD.showWait()
            self.webView.navigationDelegate = self
            self.webView.load(urlRequest)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftProgressHUD.hideAllHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SwiftProgressHUD.hideAllHUD()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func touchedBackButton(_ sender: Any) {
        self.webView.goBack()
        self.webView.reload()
    }
    
    @IBAction func touchedForwardButton(_ sender: Any) {
        self.webView.goForward()
        self.webView.reload()
    }
    
}
