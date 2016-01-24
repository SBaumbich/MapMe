//
//  LogInViewController.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/24/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    let color = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var logInButton: UIButton!
    
    
    
// App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        backgroundImage.alpha = 0
        titleLabel.alpha = 0
        userName.alpha = 0
        password.alpha = 0
        logInButton.alpha = 0
        
        addTextfieldShadow(userName)
        addTextfieldShadow(password)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.5) {
            self.backgroundImage.alpha = 0.85
            self.titleLabel.alpha = 0.85
            self.userName.alpha = 0.85
            self.password.alpha = 0.85
            self.logInButton.alpha = 0.85
        }
    }
    
    
    
// Helper Functions
    func addTextfieldShadow(textField: UITextField) {
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = color.CGColor
        textField.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        textField.layer.shadowOpacity = 0.70
        textField.layer.shadowRadius = 1.85
    }
}
