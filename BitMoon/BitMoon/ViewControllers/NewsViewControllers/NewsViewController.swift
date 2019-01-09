//
//  NewsViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftProgressHUD

class NewsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var newsData: NewsData?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView.navigationDelegate = self
        self.title = self.newsData?.title

        let request = URLRequest(url: URL(string: (self.newsData?.url)!)!)
        SwiftProgressHUD.showWait()
        self.webView.load(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftProgressHUD.hideAllHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SwiftProgressHUD.hideAllHUD()
        ErrorManager.sharedErrorManager.showError(errorCode: "E10007", parent: self)
    }
}
