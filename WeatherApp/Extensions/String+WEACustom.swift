//
//  String+WEACustom.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 08/05/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import Foundation

extension String {
    
    func wea_matchesForRegex(regex: String!) -> [String] {
        
        let regex = NSRegularExpression(pattern: regex,
            options: nil, error: nil)!
        let nsString = self as NSString
        let results = regex.matchesInString(
            self,
            options: nil,
            range: NSMakeRange(0, nsString.length)
        ) as! [NSTextCheckingResult]
        
        return map(results) { nsString.substringWithRange($0.range)}
    }
    
}
