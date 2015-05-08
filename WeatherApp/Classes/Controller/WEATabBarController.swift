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

    lazy var locationManager : CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    var updatedAt: NSDate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Screen life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupObserver()
        
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Setup
    
    func setup() {
        // setup tab bar images
        for item: UITabBarItem in self.tabBar.items as! [UITabBarItem] {
            // setting up images
            item.image = WEATabBarController.imageFor(item.tag, selected: false)
                            .imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            item.selectedImage = WEATabBarController.imageFor(item.tag, selected: true)
                                    .imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
    }
    
    func setupObserver() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationDidBecomeActive"),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationDidEnterBackground"),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil
        )
    }
    
    // MARK: - Observer
    
    func applicationDidBecomeActive() {
        self.updatedAt = nil
        self.locationManager.startUpdatingLocation()
    }
    
    func applicationDidEnterBackground() {
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // we want to update location information only each 5 minutes
        let now: NSDate = NSDate()
        if self.updatedAt != nil {
            var diff: NSTimeInterval = now.timeIntervalSinceDate(self.updatedAt!)
            let minutes: Double = diff / 60
            if minutes < 5.0 {
                return
            }
        }
        
        
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        WEAWeatherAPI.fetchForecast(location.coordinate, days: 7, handler: { (response: AnyObject?, error: NSError?) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error != nil {
                self.showMessage(error!.localizedDescription)
                return
            }
            
            if let cityId: NSNumber = response?.valueForKeyPath("city.id") as? NSNumber {
                // get existing place or create new one
                var city: WEACity = WEACity.getOrCreateCurrent(cityId)
                city.setEntityData(response)
                city.current = 1
                city.managedObjectContext?.MR_saveToPersistentStoreAndWait()
                
                // TODO(vojta) have constant for notification name
                NSNotificationCenter.defaultCenter().postNotificationName("cz.vojtechbartos.WeatherApp.locationDidChange", object: nil)
            }
            
            self.updatedAt = now
        })
    }
    
    // MARK: - Helpers
    
    class func imageFor(tag: Int, selected: Bool) -> UIImage! {
        var name: String?
        switch tag {
            case 0:
                name = "Today"
                break;

            case 1:
                name = "Forecast"
                break;
                
            case 2:
                name = "Settings"
                break;
                
            default:
                break;
        }
        
        if selected {
            name = String(format: "%@-Selected", name!)
        }
        
        return UIImage(named: name!)
    }
    
    // MARK: - System
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
