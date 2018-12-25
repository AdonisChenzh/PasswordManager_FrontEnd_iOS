//
//  ViewController.swift
//  PasswordManager
//
//  Created by Zehao Chen on 11/27/18.
//  Copyright © 2018 Zehao Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    let URL = "https://sheltered-plateau-65708.herokuapp.com"
    let SIGNIN_URL = "/users/login"
    let SIGNUP_URL = "/users/signup"
    
    var TOKEN = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        //send  sign in request
        let username: String = usernameInput.text!
        let password: String = passwordInput.text!
        let url = URL + SIGNIN_URL
        
        //set parameters for the post request body
        let params: Parameters = [
            "email": username,
            "password": password
        ]

        //send request
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                print("Successfully Signed in!")
                //to get header token
                if let xAuth = response.response?.allHeaderFields["X-Auth"] as? String{
                    print("Token is: \(xAuth)")
                    self.TOKEN = xAuth
                    self.performSegue(withIdentifier: "ShowContent", sender: self)
                }
                else {
                    //print("Bad Request! Try Again!")
                    let alert = UIAlertController(title: "Alert", message: "Bad Request! Try Again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
            }
            else {
                //print("No username and password pairs matched, try again!")
                let alert = UIAlertController(title: "Alert", message: "No username and password pairs matched, try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        //send sign up request
        let username: String = usernameInput.text!
        let password: String = passwordInput.text!
        let url = URL + SIGNUP_URL
        
        //set parameters for the post request body
        let params: Parameters = [
            "email": username,
            "password": password
        ]
        
        //send request
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                print("Successfully Signed up!")
                //to get header token
                if let xAuth = response.response?.allHeaderFields["X-Auth"] as? String{
                    //print("Token is: \(xAuth)")
                    self.TOKEN = xAuth
                    self.performSegue(withIdentifier: "ShowContent", sender: self)
                }
                else {
                    let alert = UIAlertController(title: "Alert", message: "Bad Request, try again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                
            }
            else {
                //print("Connection Issues!")
                let alert = UIAlertController(title: "Alert", message: "Connection Issues!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContent" {
            let destinationVC = segue.destination as! ContentViewController
            destinationVC.TOKEN_HOLD = TOKEN
        }
    }
}

