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
    var annotations = [MKPointAnnotation]()
    @IBOutlet var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        self.view.alpha = 0
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.4) {
            self.view.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseTest.storeParseData { (data, error) -> Void in
            if let data = (self.defaults.objectForKey("parseData")) as? [[String:AnyObject]] {
                
                print(data)
                var pointContainer = [MKPointAnnotation]()
                for dict in data {
                    let item = ClientLocation(ClientLocationDict: dict)
                    pointContainer.append(item.annotation!)
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.annotations = pointContainer
                    self.mapView.addAnnotations(self.annotations)
                }
            } else if error == true {
                let alert = UIAlertController(title: "Download Faild", message:"Unable to download student pin locations", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .Default) { _ in })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}

