//
//  ErrorManager.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 28..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {
    static let sharedErrorManager = ErrorManager()

    var errorDict: NSDictionary?
    private override init() {
        if let filePath = Bundle.main.path(forResource: "error", ofType: "plist"),
            let errorDict = NSDictionary.init(contentsOfFile: filePath) {
            self.errorDict = errorDict
        }
    }

    func showError(errorCode: String, parent: UIViewController, completion: (() -> Void)? = nil) {
        let infoDict = self.errorDict?.object(forKey: errorCode) as! NSDictionary
        let alertController = UIAlertController(title: NSLocalizedString("noticeTitle", comment: ""), message: NSLocalizedString(infoDict.object(forKey: "messageKey") as! String, comment: ""), preferredStyle: .alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("doneButtonTitle", comment: ""), style: .default) { (UIAlertAction) in
            alertController .dismiss(animated: true, completion: nil)
            completion?()
        }
        
        alertController.addAction(doneAction)
        parent.present(alertController, animated: true, completion: nil)
    }
    
}
