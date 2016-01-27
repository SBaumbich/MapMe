//
//  MapVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/24/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    var parseTest = PersistParseData()
    @IBOutlet var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        self.view.alpha = 0
        
        
        parseTest.storeParseData { (data, error) -> Void in
            if let data = (self.defaults.objectForKey("parseData")) as? [[String:AnyObject]] {

                print(data)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.4) {
            self.view.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

