//
//  WEATabBarController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 13/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit
import CoreLocation

class WEATabBarController: UITabBarController, CLLocationManagerDelegate {

    lazy var cities : [WEACity] = {
        return self.cityManager.cities
    }()
    
    lazy var cityManager : WEACityManager = {
        return WEACityManager.sharedInstance
    }()
    
    lazy var locationManager : CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.startUpdatingLocation()
        
        self.cityManager.fetchForecast()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        WEAApi.getForecastForCoordination(location.coordinate)
    }
    
    // MARK: Rotation
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }

}
