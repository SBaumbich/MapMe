//
//  TabBarVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/28/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    let topVC = UIApplication.topViewController()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let appDel = AppDelegate()
    

//**************************************************
// MARK: - IBActions
//**************************************************
    
    @IBAction func logOutButton(sender: AnyObject) {
    
        setActivityIndicator()
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
                return
            }
            
            do {
                /* subset response data! */
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                
                if let parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary{

                    print("logged Out Udacity")
                    print(parsedData)
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            } catch {
                print("Problem Logging Out")
            }
        }
        task.resume()
    }
    
    @IBAction func addPinButton(sender: AnyObject) {
    
    }
    
    
    
//**************************************************
// MARK: - Helper Functions
//**************************************************
    
    func setActivityIndicator () {
        activityIndicator.color = appDel.redColor
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        topVC!.view.addSubview(activityIndicator)
    }
    
}



//**************************************************
// MARK: - Extention (Find Top Most View Controller)
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
