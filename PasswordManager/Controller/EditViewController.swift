//
//  EditViewController.swift
//  PasswordManager
//
//  Created by Zehao Chen on 12/24/18.
//  Copyright © 2018 Zehao Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditViewController: UIViewController {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var newAccount: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    let URL = "https://sheltered-plateau-65708.herokuapp.com/password-manager"
    
    
    var TOKEN_HOLD = ""
    var serviceNameClicked = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceName.text = serviceNameClicked
    }
    
    @IBAction func backToRecordsView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToRecordsView", sender: self)
    }
    
    @IBAction func saveUpdatedInfo(_ sender: UIButton) {
        let username: String = newAccount.text!
        let password: String = newPassword.text!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-auth": TOKEN_HOLD
        ]
        let url = URL + "/" + serviceNameClicked
        //set parameters for the post request body
        let params: Parameters = [
            //"service": serviceNameClicked,
            "account": username,
            "password": password
        ]
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let alert = UIAlertController(title: "Success", message: "Modify and Save successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Cannot Modify, Go back please!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToRecordsView" {
            let destinationVC = segue.destination as! recordsViewController
            destinationVC.TOKEN_HOLD = TOKEN_HOLD
            destinationVC.serviceNameClicked = serviceNameClicked
            let username: String = newAccount.text!
            let password: String = newPassword.text!
            destinationVC.updatedUsername = username
            destinationVC.updatedPassword = password
        }
    }
}
