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
    @IBOutlet var InputTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
    }
}
