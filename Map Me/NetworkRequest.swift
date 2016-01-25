//
//  NetworkRequest.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/25/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import Foundation

class NetworkRequest {

    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    
    func downloadJSON (url: NSURL, method: String, headers: [String:String]? = nil, body: [String:AnyObject]? = nil, responseHandler: (NSData?, NSError?) -> Void) {
 
        
        // create request and set HTTP method
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        // add headers
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // add body
        if let body = body {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions())
        }
        
        // create/return task
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // was there an error?
            if let error = error {
                responseHandler(nil, error)
                print("There was an error with the request: \(error)")
                return
            }
            
            // did we get a successful 2XX response?
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode <= 199 && statusCode >= 300  {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    responseHandler(nil, error)
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    responseHandler(nil, error)
                } else {
                    print("Your request returned an invalidresponse!")
                    responseHandler(nil, error)
                }
                return
            }
            
            responseHandler(data, nil)
        }
        task.resume()
    }
}
