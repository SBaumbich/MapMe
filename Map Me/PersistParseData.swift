//
//  PersistParseData.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/26/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import Foundation

class PersistParseData {
    
    
    var parseData: [[String:AnyObject]]?
    let defaults = NSUserDefaults.standardUserDefaults()
    let networkRequest = NetworkRequest()
    let url = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!
    let header = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]

    func storeParseData(compleation: ([[String:AnyObject]]?, error: Bool?) -> Void) {

        networkRequest.downloadJSON(url, method: "GET", headers: header, body: nil) { (data, error) -> Void in
            
            guard (error == nil) else {
                print("Error downloading Parse User Data: \(error)")
                compleation(nil, error: true)
                return
            }

            do {
                guard let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary else {
                    print("Error Parsing JSON")
                    compleation(nil, error: true)
                    return
                }
                
                var studentLocationData = [[String:AnyObject]]()
                
                if let resultsArray = jsonDictionary["results"] as? NSArray {
                    for dict in resultsArray {
                        if let resultsDict = dict as? [String:AnyObject]{
                            studentLocationData.append(resultsDict)
                        }
                    }
                    self.parseData = studentLocationData
                    self.defaults.setObject(studentLocationData, forKey: "parseData")
                    compleation(studentLocationData, error: nil)
                }
            } catch {
                print(error)
                compleation(nil, error: true)
            }
            
        }
    }
   
}