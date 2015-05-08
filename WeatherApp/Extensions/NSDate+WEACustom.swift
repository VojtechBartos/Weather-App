//
//  NSDate+WEACustom.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 19/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import Foundation

extension NSDate {
    
    func wea_dayOfWeek() -> String {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(self)
    }
    
}
