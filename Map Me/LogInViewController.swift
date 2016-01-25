//
//  LogInViewController.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/24/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    let appDel = AppDelegate()
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
        setAlphaValues(0)
        errorLabel.alpha = 0
        addTextfieldShadow(userName)
        addTextfieldShadow(password)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.5) {
            self.setAlphaValues(0.85)
        }
    }
    

    
//**************************************************
// MARK: - IBActions
//**************************************************
    
    @IBAction func logInButtonPressed(sender: AnyObject) {
        login()
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
        textField.layer.shadowColor = appDel.color.CGColor
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
    
    // Login & Transition to the next view
    private func login() {
        performSegueWithIdentifier("login", sender: self)
    }
}
