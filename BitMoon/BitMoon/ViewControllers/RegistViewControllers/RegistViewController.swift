//
//  RegistViewController.swift
//  BitMoon
//
//  Created by PFXStudio on 2018. 10. 23..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AWSAuthCore
import AWSCore
import AWSAPIGateway
import AWSMobileClient
import SwiftProgressHUD

class RegistViewController: UIViewController {

    @IBOutlet weak var profileSegControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var teamTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Regist"
        self.changedSegControl(self.profileSegControl)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func changedSegControl(_ sender: Any) {
        self.nameTextField.text = ""
        self.phoneTextField.text = ""
        self.emailTextField.text = ""
        self.teamTextField.text = ""
        self.addressTextField.text = ""
        if (self.profileSegControl.selectedSegmentIndex == 1) {
            self.nameTextField.text = "Semi"
            self.phoneTextField.text = "+8210-6442-7845"
            self.emailTextField.text = "SemiOne@hanwha.com"
            self.teamTextField.text = "Architect Team"
            self.addressTextField.text = "100, Eulji-ro Jung-gu Seoul, Republic of Korea"
            return
        }
        else if (self.profileSegControl.selectedSegmentIndex == 2) {
            self.nameTextField.text = "Mina"
            self.phoneTextField.text = "+8210-7654-2236"
            self.emailTextField.text = "MinaRo@hanwha.com"
            self.teamTextField.text = "Architect Team"
            self.addressTextField.text = "100, Eulji-ro Jung-gu Seoul, Republic of Korea"

            return
        }
    }
    
    @IBAction func touchedRegistButton(_ sender: Any) {
        if ((self.nameTextField.text?.count)! <= 0) {
            self.nameTextField.errorMessage = "! Input your name"
            return
        }
        
        if ((self.teamTextField.text?.count)! <= 0) {
            self.teamTextField.errorMessage = "! Input your team"
            return
        }
        
        if ((self.addressTextField.text?.count)! <= 0) {
            self.addressTextField.errorMessage = "! Input your address"
            return
        }
        
        if ((self.phoneTextField.text?.count)! <= 0) {
            self.phoneTextField.errorMessage = "! Input your phone number"
            return
        }

        if ((self.emailTextField.text?.count)! <= 0) {
            self.emailTextField.errorMessage = "! Input your email"
            return
        }

        // regist
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/profile"
        let queryStringParameters = ["key1":"{value1}"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let defaults = UserDefaults.standard
        let userId: String? = defaults.string(forKey: DefineStrings.kIdentityProviderName)

        let bodyDict = ["userId": userId, "name": self.nameTextField.text, "team": self.teamTextField.text, "address": self.addressTextField.text, "phone": self.phoneTextField.text, "email": self.emailTextField.text]
        var httpBody:String = ""

        do {
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: bodyDict,
                options: []) {
                let theJSONText:String = String(data: theJSONData,
                                                encoding: .ascii)!
                print("JSON string = \(theJSONText)")
                
                httpBody = theJSONText
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast2,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_HWVW65QROJ_ProfileMobileHubClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_HWVW65QROJ_ProfileMobileHubClient(forKey: "CloudLogicAPIKey")
        
        SwiftProgressHUD.showWait()
        invocationClient.invoke(apiRequest).continueWith { (
            task: AWSTask) -> Any? in
            SwiftProgressHUD.hideAllHUD()
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            
            print("responseString : \(String(describing: responseString))")
            print("statusCode : \(result.statusCode)")
            
            return nil
        }
        
    }
    
    @IBAction func changedNameTextField(_ sender: Any) {
        self.nameTextField.errorMessage = ""
    }
    
    @IBAction func changedTeamTextField(_ sender: Any) {
        self.teamTextField.errorMessage = ""
    }
    
    @IBAction func changedAddressTextField(_ sender: Any) {
        self.addressTextField.errorMessage = ""
    }
    
    @IBAction func changedPhoneTextField(_ sender: Any) {
        self.phoneTextField.errorMessage = ""
    }
    
    @IBAction func changedEmailTextField(_ sender: Any) {
        self.emailTextField.errorMessage = ""
    }
    
    @IBAction func tabedView(_ sender: Any) {
        self.view.endEditing(true)
    }
}
