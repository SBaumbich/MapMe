//
//  TabBarVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/28/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class TabBarVC: UITabBarController {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let defaults = NSUserDefaults.standardUserDefaults()
    let appDel = AppDelegate()
    
    
    
    //**************************************************
    // MARK: - IBActions
    //**************************************************
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        setActivityIndicator()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if defaults.objectForKey("login") as? String  == "Facebook" {
            facebookLogout()
        } else {
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            request.HTTPMethod = "DELETE"
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                
                guard (error == nil) else {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    let alert = UIAlertController(title: "Logout Faild", message:"Unable to connect to the network.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("Network Error")
                    return
                }
                
                // GUARD: Did we get a successful 2XX response?
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    
                    if let response = response as? NSHTTPURLResponse {
                        print("Login Failed: \(response.statusCode)")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                    } else {
                        print("Your request returned an invalid response!")
                    }
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    return
                }
                
                do {
                    /* subset response data! */
                    let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                    
                    if let _ = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary{
                        
                        print("logged Out Udacity")
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                } catch {
                    print("Problem Logging Out")
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }
            }
            task.resume()
        }
    }
    
    @IBAction func addPinButton(sender: AnyObject) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PostLocation") as? PostLocationVC
        presentViewController(controller!, animated: true, completion: nil)
    }
    
    
    
    //**************************************************
    // MARK: - Helper Functions
    //**************************************************
    
    func setActivityIndicator () {
        let topVC = UIApplication.topViewController()
        activityIndicator.color = appDel.redColor
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        topVC!.view.addSubview(activityIndicator)
    }
    
    func facebookLogout() {
        let facebookRequest: FBSDKGraphRequest! = FBSDKGraphRequest(graphPath: "/me/permissions", parameters: nil, HTTPMethod: "DELETE")
        
        facebookRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if(error == nil && result != nil){
                print("Permission successfully revoked. This app will no longer post to Facebook on your behalf.")
                print("result = \(result)")
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if result["success"] as? Int == 1 {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else if let error: NSError = error {
                if let errorString = error.userInfo["error"] as? String {
                    print("errorString variable equals: \(errorString)")
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                } else {
                    print("Network Error: No value for key")
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }
            }
        }
    }
}


//**************************************************
// MARK: - Extention: (Find Top Most View Controller)
//**************************************************

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
