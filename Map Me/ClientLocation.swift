//
//  ClientLocation.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/25/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import Foundation
import MapKit

struct ClientLocation {
    
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let coordinate: CLLocationCoordinate2D?
    let annotation: MKPointAnnotation?
    
    init(ClientLocationDict: [String:AnyObject]) {
        
        firstName = ClientLocationDict["firstName"] as? String
        lastName = ClientLocationDict["lastName"] as? String
        mapString = ClientLocationDict["mapString"] as? String
        mediaURL = ClientLocationDict["mediaURL"] as? String
        objectId = ClientLocationDict["objectId"] as? String
        uniqueKey = ClientLocationDict["uniqueKey"] as? String
        
        var lat: CLLocationDegrees = 0.0
        var long: CLLocationDegrees = 0.0
        
        
        if let latDouble = ClientLocationDict["latitude"] as? Double {
            latitude = CLLocationDegrees(latDouble)
            lat = CLLocationDegrees(latDouble)
        } else {latitude = nil}
        
        if let longDouble = ClientLocationDict["longitude"] as? Double {
            longitude = CLLocationDegrees(longDouble)
            long = CLLocationDegrees(longDouble)
        } else {longitude = nil}
        
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let pointAnnotation = MKPointAnnotation()
        
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        pointAnnotation.title = "\(firstName!) \(lastName!)"
        pointAnnotation.subtitle = mediaURL
        annotation = pointAnnotation
        
    }
}








