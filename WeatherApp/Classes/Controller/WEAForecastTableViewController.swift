//
//  WEAForecastTableViewController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 13/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

let WEA_FORECAST_CELL_IDENTIFIER = "WEAForecastCell"

class WEAForecastTableViewController: UITableViewController {

    let config: WEAConfig = WEAConfig.sharedInstance
    
    var days: [WEAForecast] = []
    
    // MARK: - Screen life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
    }
    
    // MARK: - Setup
    
    func setup() {
        let cellNib: UINib = UINib(nibName: "WEATableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: WEA_FORECAST_CELL_IDENTIFIER)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.allowsSelection = false
        self.tableView.editing = false
    }
    
    func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reload", name: "cz.vojtechbartos.WeatherApp.locationDidChange", object: nil
        )
    }

    // MARK: - Helpers
    
    func reload() {
        if let city: WEACity = WEACity.getCurrent() {
            // set navigation title
            self.navigationItem.title = city.name
            
            // load updated forecast for next days
            self.days = city.orderedForecast()
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: WEAForecastTableViewCell = tableView.dequeueReusableCellWithIdentifier(
            WEA_FORECAST_CELL_IDENTIFIER, forIndexPath: indexPath
        ) as! WEAForecastTableViewCell
    
        return self.configure(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    // MARK: - Helpers
    
    func configure(cell: WEAForecastTableViewCell, indexPath: NSIndexPath) -> WEAForecastTableViewCell {
        var forecast: WEAForecast = self.days[indexPath.row]
        
        cell.imageIconView.image = forecast.imageIcon(WEAImage.Small)
        cell.titleLabel.text = forecast.day
        cell.descriptionLabel.text = forecast.info
        cell.temperatureLabel.text = NSString(format: "%iº", forecast.temperatureIn(self.config.temperatureUnit).integerValue) as String
        cell.userInteractionEnabled = false
        
        return cell
    }
    
    // MARK: - System
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
