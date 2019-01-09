//
//  HomeTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 10. 17..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import FoldingCell
import UIKit
import AWSCore
import AWSAuthCore
import AWSDynamoDB
import SwiftProgressHUD

class HomeTableViewController: UITableViewController {

    enum Const {
        static let closeCellHeight: CGFloat = 140
        static let openCellHeight: CGFloat = 360
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    var items = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }

    @objc func refreshHandler() {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20

        self.items = NSMutableArray()
        self.tableView.reloadData()

        SwiftProgressHUD.showWait()
        dynamoDBObjectMapper.scan(Profiles.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            SwiftProgressHUD.hideAllHUD()
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                let responseItems = NSMutableArray()

                print("load count is \(paginatedOutput.items.count)")
                for news in paginatedOutput.items {
                    let newsItem = news as? Profiles
                    responseItems.add(newsItem as Any)
                    print("load item name : \(String(describing: newsItem?._name))")
                }
                
                DispatchQueue.main.async(execute: {
                    if #available(iOS 10.0, *) {
                        self.tableView.refreshControl?.endRefreshing()
                    }
                    
                    self.items = NSMutableArray(array: responseItems)
                    self.tableView.reloadData()
                })
            }

            return nil
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count;
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as HomeTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        let profiles: Profiles = self.items[indexPath.row] as! Profiles
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
            cell.updateWithProfiles(profiles: profiles)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell

        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}
