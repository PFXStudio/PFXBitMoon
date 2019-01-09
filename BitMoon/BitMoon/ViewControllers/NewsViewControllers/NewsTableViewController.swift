//
//  NewsTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 12. 13..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftProgressHUD

class NewsTableViewController: UITableViewController {

    var newsDatas = Array<NewsData>()
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("loadingTitle", comment: ""))
        self.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = NSLocalizedString("NewsTableViewController", comment: "")
        self.refresh()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        refreshControl?.addTarget(self, action: #selector(NewsTableViewController.refresh), for: .valueChanged)
    }

    @IBAction func refresh() {
        self.request?.cancel()
        
        refreshControl?.beginRefreshing()
        self.requestList()
    }
    
    func requestList() {
        SwiftProgressHUD.showWait()
        let target = ServerInfoData.s_cryptoComparePath + "v2/news/?lang=EN"
        print("request : \(target)")
        self.request = Alamofire.request(target)
        let requestComplete: (HTTPURLResponse?, Result<String>) -> Void = { response, result in
            self.refreshControl?.endRefreshing()
            SwiftProgressHUD.hideAllHUD()
            self.request = nil
            print("end request")
            
            if result.isFailure == true {
                return
            }
            
            let parser = newsListParser()
            let newsDatas = parser.parseWithJson(jsonString: result.value!) as! Array<NewsData>
            let indexPaths = NSMutableArray()
            for newsData in newsDatas {
                self.newsDatas.append(newsData)
                indexPaths.add(IndexPath(row: self.newsDatas.count - 1, section: 0))
            }
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths as! [IndexPath], with: .automatic)
            self.tableView.endUpdates()
        }
        
        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.newsDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(NewsTableViewCell.self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewsTableViewCell

        let newsData = self.newsDatas[indexPath.row]
        cell.update(newsData: newsData)
        // Configure the cell...

        return cell
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
        if let newsViewController = segue.destination as? NewsViewController {
            let indexPath = self.tableView.indexPathForSelectedRow
            newsViewController.newsData = self.newsDatas[(indexPath?.row)!]
        }
    }
}
