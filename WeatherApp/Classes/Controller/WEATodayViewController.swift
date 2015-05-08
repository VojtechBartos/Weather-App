//
//  WEATodayViewController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 15/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEATodayViewController: UIViewController {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var compassLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var crLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var dividerTopView: UIView!
    @IBOutlet weak var dividerBottomView: UIView!
    
    let config: WEAConfig = WEAConfig.sharedInstance
    
    var city: WEACity?
    
    // MARK: - Screen life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    
    // MARK: - Setup
    
    func setup() {
        let font = UIFont.wea_proximaNovaSemiboldWithSize(18.0)
        let color = UIColor.wea_colorWithHexString("#333333")
        
        self.wrapperView.backgroundColor = UIColor.clearColor()
        
        self.cityLabel.font = font
        self.cityLabel.textColor = color
        
        self.infoLabel.font = UIFont.wea_proximaNovaRegularWithSize(25.0)
        self.infoLabel.textColor = UIColor.wea_colorWithHexString("#2f91ff")
        
        let buttonColor = UIColor.wea_colorWithHexString("#ff8847")
        self.shareButton.setTitleColor(buttonColor, forState: UIControlState.Normal)
        self.shareButton.setTitleColor(buttonColor, forState: UIControlState.Highlighted)
        self.shareButton.titleLabel?.font = font

        self.compassLabel.font = font
        self.compassLabel.textColor = color
        self.windLabel.font = font
        self.windLabel.textColor = color
        self.pressureLabel.font = font
        self.pressureLabel.textColor = color
        self.crLabel.font = font
        self.crLabel.textColor = color
        self.rainLabel.font = font
        self.rainLabel.textColor = color
        
        self.dividerTopView.backgroundColor = UIColor.wea_colorWithHexString("#dedede")
        self.dividerBottomView.backgroundColor = UIColor.wea_colorWithHexString("#dedede")
    }
    
    func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "update", name: "cz.vojtechbartos.WeatherApp.locationDidChange", object: nil
        )
    }
    
    func update() {
        self.city = WEACity.getCurrent()
        if self.city == nil {
            return
        }
        
        self.cityLabel.text = String(format: "%@, %@", self.city!.name!, self.city!.country!)
        
        if let forecast: WEAForecast = self.city?.orderedForecast().first {
            var temperatureUnit = (self.config.temperatureUnit == WEAForecastTemperatureUnit.Fahrenheit) ? "°F" : "°C"
            var lengthUnit = (self.config.lengthUnit == WEAForecastLengthUnit.Yards) ? "y/s" : "m/s"
            
            self.imageView.image = forecast.imageIcon
            self.infoLabel.text = String(
                format: "%i %@ | %@",
                forecast.temperatureIn(self.config.temperatureUnit).integerValue,
                temperatureUnit,
                forecast.info!
            )
            self.pressureLabel.text = String(format: "%i hPa", forecast.pressure!.integerValue)
            self.windLabel.text = String(
                format: "%i %@",
                forecast.windSpeedIn(self.config.lengthUnit).integerValue,
                lengthUnit
            )
            self.crLabel.text = String(format: "%i%%", forecast.humidity!.integerValue)
            self.rainLabel.text = String(format: "%.01f mm", forecast.rain!.doubleValue)
            self.compassLabel.text = forecast.compass
        }
    }
    
    // MARK: - Event handlers
    
    @IBAction func sharedButtonPressed(sender: AnyObject) {
        let text: String = String(format: "%@, %@", self.cityLabel.text!, self.infoLabel.text!)
        let items: [String] = [text]
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - System
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
