//
//  WEAGoogleAPI.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 19/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit
import Alamofire

let WEA_GOOGLE_API_BASE_URL = "https://maps.googleapis.com/maps/api/place"

class WEAGoogleAPI: NSObject {
   
    class func findCity(name: String, handler: (NSArray?, NSError?) -> Void) {
        let parameters = [
            "input": name,
            "types": "(cities)",
            "key": WEAConfig.sharedInstance.googlePlaceApiKey
        ]
        
        Alamofire
            .request(.GET, "".join([WEA_GOOGLE_API_BASE_URL, "/autocomplete/json"]), parameters: parameters)
            .responseJSON { (request, response, JSON, error) in
                handler(JSON?.valueForKeyPath("predictions") as? NSArray, error)
        }
    }
    
    class func getCityDetail(placeId: String, handler: (NSDictionary?, NSError?) -> Void) {
        let parameters = [
            "placeid": placeId,
            "key": WEAConfig.sharedInstance.googlePlaceApiKey
        ]
        
        Alamofire
            .request(.GET,"".join([WEA_GOOGLE_API_BASE_URL, "/details/json"]), parameters: parameters)
            .responseJSON { (request, response, JSON, error) in
                handler(JSON?.valueForKeyPath("result.geometry.location") as? NSDictionary, error)
        }
    }
    
}
