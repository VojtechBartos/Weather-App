//
//  WEACityManager.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 13/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

let API_BASE_URL = "http://api.openweathermap.org/data/2.5"
let KEY_CITIES = "cities"

class WEACityManager: NSObject {
   
    var cities : [WEACity] = []
    
    class var sharedInstance: WEACityManager {
        struct Static {
            static var instance: WEACityManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = WEACityManager()
        }
        
        return Static.instance!
    }
    
    override init() {
        super.init()
        self.load()
    }
    
    // MARK: helpers
    
    func cityById(id: NSNumber) -> WEACity? {
        return self.cities.filter{ $0.id == id }.first
    }
    
    // MARK: fetching
    
    func fetchForecast(coordinate: CLLocationCoordinate2D) {
        let parameters = ["lat": coordinate.latitude, "lon": coordinate.longitude]
        
        Alamofire
            .request(.GET, "".join([API_BASE_URL, "/forecast"]), parameters: parameters)
            .responseJSON { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    func fetchForecast() {
        let parameters = ["lat": 35.1, "lon": 138.1]
        
        Alamofire
            .request(.GET, "".join([API_BASE_URL, "/forecast"]), parameters: parameters)
            .responseJSON { (request, response, JSON, error) in
                if (error != nil) {
                    return
                }
                
                var id: NSNumber = JSON?.valueForKeyPath("city.id") as! NSNumber
                var name: String = JSON?.valueForKeyPath("city.name")as! String
                var longitude: CLLocationDegrees = JSON?.valueForKeyPath("city.coord.lon") as! CLLocationDegrees
                var latitude: CLLocationDegrees = JSON?.valueForKeyPath("city.coord.lat") as! CLLocationDegrees
                
                var city: WEACity! = self.cityById(id)
                if city == nil {
                    city = WEACity(
                        id: id,
                        name:name,
                        coordinate: CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
                    )
                }
                
                self.cities.append(city)        }
    }
    
    
    // MARK: persistence
    
    func load() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var archivedData = defaults.dataForKey(KEY_CITIES)
        if archivedData != nil {
            self.cities = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData!) as![WEACity]
        }
    }
    
    func persist() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var archivedData = NSKeyedArchiver.archivedDataWithRootObject(self.cities)
        
        defaults.setObject(archivedData, forKey: KEY_CITIES)
        defaults.synchronize()
    }
    
}
