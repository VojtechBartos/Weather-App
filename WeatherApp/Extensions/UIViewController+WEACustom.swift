//
//  UIViewController+WEACustom.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 05/05/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

extension UIViewController {
 
    func showMessage(message: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            "cz.vojtechbartos.WeatherApp.notification",
            object: ["message": message]
        )
    }
    
}
