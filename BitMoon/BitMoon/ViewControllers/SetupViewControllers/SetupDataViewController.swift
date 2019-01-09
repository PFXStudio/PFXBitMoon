//
//  SetupDataViewController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 8..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupDataViewController: SetupViewController {

    @IBOutlet weak var spaceTitleLabel: UILabel!
    @IBOutlet weak var spaceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteContentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.spaceTitleLabel.text = NSLocalizedString("app_setup_data_space_title", comment: "")
        self.deleteContentsLabel.text = NSLocalizedString("app_setup_data_delete_contents", comment: "")
        self.deleteButton.setTitle(NSLocalizedString("app_setup_data_delete_button", comment: ""), for: .normal)
        
        self.initialize()
    }
    
    func initialize() {
        let folderPaths = NSMutableArray()
        folderPaths.add(ImageUtil.imageFolderPath())
        
        let folderSize = self.sizeOfFolders(folderPaths: folderPaths)
        self.spaceLabel.text = String(format: NSLocalizedString("app_setup_data_space_use", comment: ""), folderSize)
    }
    
    func sizeOfFolders(folderPaths: NSArray) -> String {
        var folderSize = 0
        for folderPath in folderPaths {
            (try? FileManager.default.contentsOfDirectory(at: folderPath as! URL, includingPropertiesForKeys: nil))?.lazy.forEach {
                folderSize += (try? $0.resourceValues(forKeys: [.totalFileAllocatedSizeKey]))?.totalFileAllocatedSize ?? 0
            }
        }
        
        let  byteCountFormatter =  ByteCountFormatter()
        byteCountFormatter.allowedUnits = .useMB
        byteCountFormatter.countStyle = .file
        let folderSizeToDisplay = byteCountFormatter.string(for: folderSize) ?? ""
        print(folderSizeToDisplay)
        return folderSizeToDisplay
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func touchedDeleteButton(_ sender: Any) {

        let alertController = UIAlertController(title: "", message: NSLocalizedString("app_setup_data_delete_confirm_message", comment: ""), preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancelButtonTitle", comment: ""), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("deleteButtonTitle", comment: ""), style: .default) { (action) in
            ImageUtil.deleteAll()
            self.initialize()
        }
        
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
