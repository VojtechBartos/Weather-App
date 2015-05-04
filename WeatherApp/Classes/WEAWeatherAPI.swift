//
//  WEAWeatherAPI.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 19/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

let API_BASE_URL = "http://api.openweathermap.org/data/2.5"
let KEY_CITIES = "cities"

class WEAWeatherAPI: NSObject {
   
    class func fetchForecast(coordinate: CLLocationCoordinate2D, days: NSInteger, handler: (AnyObject?, NSError?) -> Void) {
        let parameters = ["lat": coordinate.latitude, "lon": coordinate.longitude, "cnt": days, "mode": "json"]
        
        Alamofire
            .request(.GET, "".join([API_BASE_URL, "/forecast/daily"]), parameters: parameters as? [String : AnyObject])
            .responseJSON { (request, response, JSON, error) in
                handler(JSON, error)
        }
    }
    
    class func fetchCurrentWeatherForCities(cities: [NSNumber], handler: (AnyObject?, NSError?) -> Void) {
        let stringCities: [String] = cities.map { $0.stringValue }
        let parameters = ["id": ",".join(stringCities)]
        
        Alamofire
            .request(.GET, "".join([API_BASE_URL, "/group"]), parameters: parameters)
            .responseJSON { (request, response, JSON, error) in
                handler(JSON, error)
        }
    }
    
}
