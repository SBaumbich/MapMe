//
//  PostLocationVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/29/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit
import MapKit

class PostLocationVC: UIViewController {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        
        let geocoder = CLGeocoder()
        do {
            geocoder.geocodeAddressString(self.inputTextField.text!) { (results, error) in
                if let _ = error {
                    self.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Invalid Location", message:"Please enter a valid location. \n e.g Chicago, IL", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Retry ", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true, completion: nil)
                }  else if (results!.isEmpty){
                    print("Not A valid location")
                } else {
                    print(results)
                }
            }
        }
    }
}






