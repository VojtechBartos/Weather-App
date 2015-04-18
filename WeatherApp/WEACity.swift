//
//  WEACity.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 13/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit
import CoreLocation

class WEACity : NSObject, NSCoding {
 
    var id : NSNumber
    var name : String
    var coordinate: CLLocationCoordinate2D
    var current : Bool = false
    
    init(id: NSNumber, name: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
    }
    
//    init(fromResponse response: AnyObject) {
//        self.id = 20
//        self.name = "Test"
//    }
    
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as! NSNumber
        self.name = decoder.decodeObjectForKey("name") as! String
        
        var latitude: CLLocationDegrees = decoder.decodeDoubleForKey("latitude") as CLLocationDegrees
        var longtitude: CLLocationDegrees = decoder.decodeDoubleForKey("longitude") as CLLocationDegrees
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeDouble(self.coordinate.latitude, forKey: "latitude")
        coder.encodeDouble(self.coordinate.longitude, forKey: "longitude")
    }

}
