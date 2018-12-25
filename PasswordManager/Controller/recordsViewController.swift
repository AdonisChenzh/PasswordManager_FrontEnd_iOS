//
//  recordsViewController.swift
//  PasswordManager
//
//  Created by Zehao Chen on 12/22/18.
//  Copyright © 2018 Zehao Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class recordsViewController: UIViewController {

    @IBOutlet weak var recordServiceName: UILabel!
    @IBOutlet weak var recordsServiceAccount: UILabel!
    @IBOutlet weak var recordsServicePassword: UILabel!
    
    let URL = "https://sheltered-plateau-65708.herokuapp.com"
    let PWDMNG = "/password-manager"
    
    var serviceAccount = ""
    var servicePassword = ""
    var serviceNameClicked = ""
    var TOKEN_HOLD = ""
    var user_id = ""
    var updatedUsername = ""
    var updatedPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordServiceName.text = "Service: " + serviceNameClicked
        if (updatedPassword != "") {
            recordsServiceAccount.text = "Account: " + updatedUsername
            recordsServicePassword.text = "Password: " + updatedPassword
        }
        else {
            recordsServiceAccount.text = "Account: " + serviceAccount
            recordsServicePassword.text = "Password: " + servicePassword
        }
    }
    
    @IBAction func removeRecord(_ sender: UIButton) {
        let url = URL + PWDMNG + "/" + serviceNameClicked
        let headers: HTTPHeaders = [
            "x-auth": TOKEN_HOLD
        ]
        
        Alamofire.request(url, method: .delete, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                print("remove successfully")
                self.performSegue(withIdentifier: "BackToContentView", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Cannot remove the record!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func backToContentView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "BackToContentView", sender: self)
    }
    
    @IBAction func editRecord(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowEditInterface", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToContentView" {
            let destinationVC = segue.destination as! ContentViewController
            destinationVC.TOKEN_HOLD = TOKEN_HOLD
        }
        if segue.identifier == "ShowEditInterface" {
            let destinationVC = segue.destination as! EditViewController
            destinationVC.serviceNameClicked = serviceNameClicked
            destinationVC.TOKEN_HOLD = TOKEN_HOLD
        }
    }

}
