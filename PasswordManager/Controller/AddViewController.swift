//
//  AddViewController.swift
//  PasswordManager
//
//  Created by Zehao Chen on 12/24/18.
//  Copyright © 2018 Zehao Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddViewController: UIViewController {
    @IBOutlet weak var newServiceName: UITextField!
    @IBOutlet weak var newAccount: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    let URL = "https://sheltered-plateau-65708.herokuapp.com/password-manager"
    
    
    var TOKEN_HOLD = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveRecord(_ sender: UIButton) {
        let service: String = newServiceName.text!
        let username: String = newAccount.text!
        let password: String = newPassword.text!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-auth": TOKEN_HOLD
        ]
        
        let url = URL
        let params: Parameters = [
            "service": service,
            "account": username,
            "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let alert = UIAlertController(title: "Success", message: "Add and Save successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Cannot Add, Go back please!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func backToContentView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToContentView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToContentView" {
            let destinationVC = segue.destination as! ContentViewController
            destinationVC.TOKEN_HOLD = TOKEN_HOLD
        }
    }
}
