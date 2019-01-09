//
//  WebViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 21..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var targetUrl: URL?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let url = self.targetUrl else { return }
        self.webView.load(URLRequest(url: url))
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
