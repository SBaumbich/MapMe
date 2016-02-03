//
//  PostLocationVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/29/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit
import MapKit

class PostLocationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var button: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    let defaults = NSUserDefaults.standardUserDefaults()
    let parseTest = PersistParseData()
    var lat: Float = 0.0
    var long: Float = 0.0
    var mapString = ""
    
    

//***************************************************
// MARK: - App Life Cyce
//***************************************************
    
    override func viewDidLoad() {
        inputTextField.delegate = self
    }
    
    
    
//***************************************************
// MARK: - IBActions
//***************************************************
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        
        // If button type is Submit
        if button.currentTitle == "Submit" {
            
            do { // Geocode Text input
                geocoder.geocodeAddressString(self.inputTextField.text!) { (results, error) in
                    if let _ = error {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Invalid Location", message:"Please enter a valid location. \n e.g Chicago, IL", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Retry ", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true, completion: nil)
                    }  else if (results!.isEmpty){
                        print("Not A valid location")
                    } else {
                        
                        // Set stored properties & change button, labels, and input text
                        self.activityIndicator.stopAnimating()
                        self.mapString = self.inputTextField.text!
                        self.button.setTitle("Post", forState: .Normal)
                        self.titleLabel.text = "Enter a valid URL"
                        self.inputTextField.placeholder = "https://www.google.com"
                        self.inputTextField.text = ""
                        let placemark = results![0]
                        guard let postedLocation = placemark.location else {
                            return
                        }
                        self.lat = Float(postedLocation.coordinate.latitude)
                        self.long = Float(postedLocation.coordinate.longitude)
                        self.mapView.showAnnotations([MKPlacemark(placemark: placemark)], animated: true)
                        print(results)
                    }
                }
                // If button type is Post & not empty
            }}else if button.currentTitle == "Post" && self.inputTextField.text != "" {
            let loginMethod = (defaults.objectForKey("login") as? String)!
            let userInfo = GetUserCredentials()
            let networkRQ = NetworkRequest()
            let url = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!
            let header = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", "Content-Type": "application/json"]
            var body = [String:AnyObject]()
            
            // If logged in with Facebook
            if loginMethod == "Facebook" {
                print("Facebook POST")
                // GET Facebook user info
                userInfo.getFBUserInfo({ (firstName, lastName, id, error) -> Void in
                    if let firstName = firstName, let lastName = lastName, let id = id {
                        
                        body = ["uniqueKey": id, "firstName": firstName, "lastName": lastName, "mapString": self.mapString, "mediaURL": self.inputTextField.text!, "latitude": self.lat, "longitude": self.long]
                        
                        // POST user location to PARSE
                        networkRQ.downloadJSON(url, method: "POST", headers: header, body: body, responseHandler: { (data, error) -> Void in
                            
                            if let newData = data {
                                do {
                                    if let jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary{
                                        // If successful POST
                                        if jsonData["createdAt"] != nil {
                                            // Refresh Parse Data
                                            self.parseTest.storeParseData { (data, error) -> Void in
                                                print("Parse Data Refreshed")
                                                self.activityIndicator.stopAnimating()
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                            }
                                        }
                                    }
                                } catch { print("Cast to JSONDict Fail"); return}
                            }
                        })
                    }
                })
                // If logged in with Udacity
            } else if loginMethod == "Udacity" {
                print("Udacity POST")
                guard let udacityID = defaults.objectForKey("udacityUserID") as? String else {
                    print("Could not find Udacity User")
                    return
                }
                // GET Udacity user info
                let url = NSURL(string: "https://www.udacity.com/api/users/\(udacityID)")!
                networkRQ.downloadJSON(url, method: "GET", responseHandler: { (data, error) -> Void in
                    
                    guard (error == nil) else {
                        print("There was an error with your request: \(error)")
                        return
                    }
                    
                    let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                    
                    do {
                        if let jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                            // If sucessfull Udacity info returned, store values
                            if let lastName = jsonData["user"]!["last_name"] as? String, let firstName = jsonData["user"]!["first_name"] as? String {
                                
                                let url = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!
                                body = ["uniqueKey": udacityID, "firstName": firstName, "lastName": lastName, "mapString": self.mapString, "mediaURL": self.inputTextField.text!, "latitude": self.lat, "longitude": self.long]
                                
                                // POST user location to PARSE
                                networkRQ.downloadJSON(url, method: "POST", headers: header, body: body, responseHandler: { (data, error) -> Void in
                                    
                                    if let newData = data {
                                        do {
                                            if let jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                                                // If successful POST
                                                if jsonData["createdAt"] != nil {
                                                    // Refresh Parse Data
                                                    self.parseTest.storeParseData { (data, error) -> Void in
                                                        print("Parse Data Refreshed")
                                                        self.activityIndicator.stopAnimating()
                                                        self.dismissViewControllerAnimated(true, completion: nil)
                                                    }
                                                }
                                            }
                                        } catch { print("Cast to JSONDict Fail"); return}
                                    }
                                })
                            }
                        }
                    } catch {}
                })
            }
        } else { activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "URL Empty", message:"Please enter a valid URL. \n e.g https://www.google.com", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Retry ", style: .Default) { _ in })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
//***************************************************
// MARK: - Delegate Methods
//***************************************************
    
    // Text Field Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}






