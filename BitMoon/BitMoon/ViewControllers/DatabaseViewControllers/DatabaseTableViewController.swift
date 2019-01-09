//
//  DatabaseTableViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 10. 19..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import CoreLocation
import AWSAuthCore
import AWSCore
import AWSDynamoDB

class DatabaseTableViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func touchedAddButton(_ sender: Any) {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            // need login.
            let alertController = UIAlertController(title: "Alert", message: "not logined", preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return;
        }

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if (self.locationCoordinate.latitude == locValue.latitude && self.locationCoordinate.longitude == locValue.longitude) {
            return;
        }
        
        self.locationCoordinate = locValue;
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        /*
        let newsItem: Locations = Locations()
        newsItem._userId = AWSIdentityManager.default().identityId
        newsItem._itemId = AWSIdentityManager.default().identityId
        newsItem._category = "current"
        newsItem._latitude = NSNumber(value: locValue.latitude)
        newsItem._longitude =  NSNumber(value: locValue.longitude)
        newsItem._name = AWSIdentityManager.default().identityId

        //Save a new item
        dynamoDbObjectMapper.save(newsItem, completionHandler: {
            (error: Error?) -> Void in
            manager.stopUpdatingLocation()
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
            self.reloadTable()
        })
 */
    }
    
    func reloadTable() {
        
    }
}
