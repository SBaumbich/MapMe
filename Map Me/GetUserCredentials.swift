//
//  GetUserCredentials.swift
//  Map Me
//
//  Created by Scott Baumbich on 2/1/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class GetUserCredentials {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    func getFBUserInfo(compleation: (firstName: String?, lastName: String?, id: String?, error: Bool?) -> Void) {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    if let dictInfo = result as? NSDictionary{
                        if let firstName = dictInfo["first_name"] as? String, let lastName = dictInfo["last_name"] as? String, let id = dictInfo["id"] as? String {
                            compleation(firstName: firstName, lastName: lastName, id: id, error: false)
                        }
                    }
                }
            })
        }
    }
}