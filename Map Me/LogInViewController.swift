//
//  LogInViewController.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/24/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LogInViewController: UIViewController {
    
    let appDel = AppDelegate()
    let networkRequest = NetworkRequest()
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    
//***************************************************
// MARK: - App Life Cycle
//***************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        _ = FBSDKLoginButton()
        setAlphaValues(0)
        errorLabel.alpha = 0
        addTextfieldShadow(userName)
        addTextfieldShadow(password)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.5) {
            self.setAlphaValues(0.85)
        }
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            print("User logged into Facebook")
            login()
        } else {
            print("User not logged Into FaceBook")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.5) {
            self.setAlphaValues(0.0)
        }
    }
    

    
//**************************************************
// MARK: - IBActions
//**************************************************
    
    @IBAction func logInButtonPressed(sender: AnyObject) {

        if textfieldsNotEmpty(userName.text!, password: password.text!) {
            
        let url = NSURL(string: "https://www.udacity.com/api/session")!
        let header = ["Accept": "application/json", "Content-Type": "application/json"]
        var body = [String:AnyObject]()
        body["udacity"] = ["username": userName.text!, "password": password.text!]

        networkRequest.downloadJSON(url, method: "POST", headers: header, body: body) { (data, error) -> Void in
            
            guard (error == nil) else {
                self.errorLabel.text = "Network Request \(error)"
                UIView.animateWithDuration(0.5) {
                    self.errorLabel.alpha = 0.85
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            do {
                if let udacityDict = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {

                    if let loginStatus = udacityDict["status"] as? Int {
                        dispatch_async(dispatch_get_main_queue()){
                            self.errorLabel.text = udacityDict["error"]! as? String
                            self.activityIndicator.stopAnimating()
                            UIView.animateWithDuration(0.5) {
                                self.errorLabel.alpha = 0.85
                            }
                            print("loginStatus: \(loginStatus)")
                            return
                        }
                    } else {
                        guard let userID = (udacityDict["account"]!["key"]) as? String else {
                            print("Udacity User Key Not Found...")
                            return
                        }
                        
                        print("Udacity ID: \(userID)")
                        UIView.animateWithDuration(0.5) {
                            self.activityIndicator.alpha = 0
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.defaults.setObject(userID, forKey: "udacityUserID")
                            self.defaults.setObject("Udacity", forKey: "login")
                            self.login()
                        }
                    }
                }
            } catch {
                print("Cound not parse data.")
            }
        }}// If Check
    }

    @IBAction func Register(sender: AnyObject) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/request-password-reset"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
//***************************************************
// MARK: - Helper Functions
//***************************************************
    
    // Hides the status bar for logingVC
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Adds red shadown around textfields
    func addTextfieldShadow(textField: UITextField) {
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = appDel.redColor.CGColor
        textField.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        textField.layer.shadowOpacity = 0.70
        textField.layer.shadowRadius = 1.85
    }
    
    // Set alpha values
    func setAlphaValues(value: CGFloat) {
        backgroundImage.alpha = value
        titleLabel.alpha = value
        userName.alpha = value
        password.alpha = value
        logInButton.alpha = value
        registerButton.alpha = value
        forgotPasswordButton.alpha = value
        facebookView.alpha = value
    }
    
    // Login & transition to the next view
    private func login() {
        performSegueWithIdentifier("login", sender: self)
    }
    
    // Check that User & Password textfields != ""
    func textfieldsNotEmpty (username: String, password: String) -> Bool {
    
        var status: Bool = false
        
        if username == "" {
            UIView.animateWithDuration(0.5) {
                self.errorLabel.alpha = 0
            }
            errorLabel.text = "Username Empty"
            UIView.animateWithDuration(0.5) {
                self.errorLabel.alpha = 0.85
            }
        } else if password == "" {
            UIView.animateWithDuration(0.5) {
                self.errorLabel.alpha = 0
            }
            errorLabel.text = "Password Empty"
            UIView.animateWithDuration(0.5) {
                self.errorLabel.alpha = 0.85
            }
        } else {
            
            UIView.animateWithDuration(0.5) {
                self.errorLabel.alpha = 0
                self.activityIndicator.startAnimating()
                self.activityIndicator.alpha = 1.0
            }
            status = true
        }
        return status
    }
}
