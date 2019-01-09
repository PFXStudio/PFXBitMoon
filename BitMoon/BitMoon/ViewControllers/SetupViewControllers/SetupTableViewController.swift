//
//  SetupTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2019. 1. 7..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class SetupTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let result = SetupDataParser().loadListFile()
        if result == false {
            return
        }
        
        self.title = NSLocalizedString("SetupTableViewController", comment: "")
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SetupData.sharedSetupData.groupNameKeys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return SetupData.sharedSetupData.items0.count
        }
        else if section == 1 {
            return SetupData.sharedSetupData.items1.count
        }
        else if section == 2 {
            return SetupData.sharedSetupData.items2.count
        }
        else if section == 3 {
            return SetupData.sharedSetupData.items3.count
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(SetupTableViewCell.self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SetupTableViewCell

        if let infoDict = self.setupDict(indexPath: indexPath) {
            cell.update(infoDict: infoDict)
        }

        return cell
    }
    
    func setupDict(indexPath: IndexPath) -> NSDictionary? {
        guard let targetDict = SetupData.sharedSetupData.infoDict(indexPath: indexPath) else  {
            return nil
        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
                let versionDict = NSMutableDictionary(dictionary: targetDict)
                versionDict.setValue(version, forKey: "rightTextKey")
                return versionDict
            }
        }
        
        return targetDict
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = DefineColors.kMainTintColor
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        guard let setupDict = self.setupDict(indexPath: indexPath) else {
            return
        }
        
        guard let setupContainerViewController = segue.destination as? SetupContainerViewController else {
            return
        }
        
        setupContainerViewController.setupDict = setupDict
    }
}
