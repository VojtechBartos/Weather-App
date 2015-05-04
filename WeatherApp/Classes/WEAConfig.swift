//
//  WEAConfig.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 23/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEAConfig: NSObject {
    
    static let sharedInstance = WEAConfig()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    lazy var config: NSDictionary? = {
        var plistPath = NSBundle.mainBundle().pathForResource("Credentials", ofType: "plist")
        return NSDictionary(contentsOfFile: plistPath!)!
    }()
    
    var lengthUnit: WEAForecastLengthUnit {
        set(unit) {
            self.defaults.setInteger(unit.rawValue, forKey: "WEALengthUnit")
            self.defaults.synchronize()
        }
        get {
            if let unit = WEAForecastLengthUnit(rawValue: self.defaults.integerForKey("WEALengthUnit")) {
                return unit
            }
            
            return WEAForecastLengthUnit.Meters
        }
    }
    
    var temperatureUnit: WEAForecastTemperatureUnit {
        set(unit) {
            self.defaults.setInteger(unit.rawValue, forKey: "WEATemperatureUnit")
            self.defaults.synchronize()
        }
        get {
            if let unit = WEAForecastTemperatureUnit(rawValue: self.defaults.integerForKey("WEATemperatureUnit")) {
                return unit
            }
            
            return WEAForecastTemperatureUnit.Celsius
        }
    }
    
    var googlePlaceApiKey: String {
        get {
            return self.config?.valueForKey("GooglePlaceApiKey") as! String
        }
    }
    
}
