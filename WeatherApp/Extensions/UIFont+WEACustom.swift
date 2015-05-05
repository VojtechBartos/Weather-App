//
//  UIFont+WEACustom.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 18/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

extension UIFont {

    class func wea_proximaNovaBoldWithSize(size: CGFloat) -> UIFont! {
        return UIFont(name: "ProximaNova-Bold", size: size)
    }
    
    class func wea_proximaNovaLightWithSize(size: CGFloat) -> UIFont! {
        return UIFont(name: "ProximaNova-Light", size: size)
    }
    
    class func wea_proximaNovaRegularWithSize(size: CGFloat) -> UIFont! {
        return UIFont(name: "ProximaNova-Regular", size: size)
    }
    
    class func wea_proximaNovaSemiboldWithSize(size: CGFloat) -> UIFont! {
        return UIFont(name: "ProximaNova-Semibold", size: size)
    }

}
