//
//  ContentViewController.swift
//  PasswordManager
//
//  Created by Zehao Chen on 12/4/18.
//  Copyright © 2018 Zehao Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let URL = "https://sheltered-plateau-65708.herokuapp.com"
    let SIGNOUT_URL = "/users/logout"
    let SIGN_ME = "/users/me"
    let PWDMNG = "/password-manager"
    
    var TOKEN_HOLD = ""
    var user_id = ""
    var recordsArray = [String]()
    var serviceNameClicked = ""
    var serviceAccount = ""
    var servicePassword = ""
    
    @IBOutlet weak var recordsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Set yourself as the delegate and datasource here
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        
        //register messageCell.xib
        recordsTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
    }
    
    //declare cellForLowAtIndexPath:
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.serviceName.text = recordsArray[indexPath.row]
        return cell
    }
    
    //declare numberOfRowsInSection
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.recordsArray.count
    }
    
    //declare configureTableView
    func configureTableView() {
        //print("ConfigureTableView")
        recordsTableView.rowHeight = UITableView.automaticDimension
        recordsTableView.estimatedRowHeight = 240.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        serviceNameClicked = recordsArray[indexPath.row]
        getServiceInfo()
    }
    
    //get the service info from ther server with service name
    private func getServiceInfo () {
        let url = URL + PWDMNG + "/" + serviceNameClicked
        let headers: HTTPHeaders = [
            "x-auth": TOKEN_HOLD
        ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let res = JSON(response.value)
                self.serviceAccount = res["account"].stringValue
                self.servicePassword = res["password"].stringValue
//                print("Service information here")
//                print(self.serviceAccount)
//                print(self.servicePassword)
                self.performSegue(withIdentifier: "ShowRecords", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Connection error, logout please!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    //check whether the current token is valid, and return the user_id for debugging
    private func get_id() {
        let url = URL + SIGN_ME
        let headers: HTTPHeaders = [
            "x-auth": TOKEN_HOLD
        ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                //self.user_id = response.result.value as! String
                self.user_id = JSON(response.value)["_id"].stringValue
                //print("UserID: \(self.user_id)")

            }
            else {
                let alert = UIAlertController(title: "Warning", message: "Connection Issues, Login again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "BackToMainPage", sender: self)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    //get all the records for current user to the recordsArray
    private func get_records() {
        let url = URL + PWDMNG
        let headers: HTTPHeaders = [
            "x-auth": TOKEN_HOLD
        ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                //print("This is the result: ")
                let res = JSON(response.value) //get the result in an array
                if (res.count == 0) {
                    print("There is no result to show")
                    let alert = UIAlertController(title: "Alert", message: "There are no records in database, insert one please!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    for i in 0 ..< res.count {
                        self.recordsArray.append(res[i]["service"].stringValue)
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Connection error, login agagin please!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    //signout
    @IBAction func btnSignOut(_ sender: UIBarButtonItem) {
        let url = URL + SIGNOUT_URL
        let headers: HTTPHeaders = [
            "x-auth": TOKEN_HOLD
        ]
        
        Alamofire.request(url, method: .delete, headers: headers).validate(statusCode: 200..<300).responseData{
            response in
            switch response.result {
            case .success: do {
                print("Logged Out Successfully!")
                let alert = UIAlertController(title: "Notice", message: "You have been Logged Out!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "BackToMainPage", sender: self)
                }))
                self.present(alert, animated: true)
            }
                
            case .failure (let error): do {
                print("Error Logout: \(error)")
                let alert = UIAlertController(title: "Alert", message: "Connection Issues, Try Again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
                
            }
            
        }
    }
    
    @IBAction func btnAddService(_ sender: UIBarButtonItem) {
        print("Go to addview")
        self.performSegue(withIdentifier: "ShowAddView", sender: self)
    }
    
    //refresh or show the records
    @IBAction func toShowRecords(_ sender: UIButton) {
        get_records()
        self.recordsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecords" {
            let destinationVC = segue.destination as! recordsViewController
            destinationVC.servicePassword = servicePassword
            destinationVC.serviceAccount = serviceAccount
            destinationVC.serviceNameClicked = serviceNameClicked
            destinationVC.user_id = user_id
            destinationVC.TOKEN_HOLD = TOKEN_HOLD
        }
        else if segue.identifier == "ShowAddView" {
            let destinationVC = segue.destination as! AddViewController
            destinationVC.TOKEN_HOLD = TOKEN_HOLD
        }
    }

}
