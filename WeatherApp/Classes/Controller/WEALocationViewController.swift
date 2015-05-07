//
//  WEALocationViewController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 18/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

let WEA_LOCATION_CELL_IDENTIFIER = "WEALocationCell"

class WEALocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WEADismissControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    let config: WEAConfig = WEAConfig.sharedInstance
    
    var refreshControl: UIRefreshControl!
    var cities: [WEACity] = []
    var prototypeCell: WEAForecastTableViewCell {
        get {
            return self.tableView.dequeueReusableCellWithIdentifier(WEA_LOCATION_CELL_IDENTIFIER) as! WEAForecastTableViewCell
        }
    }

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
        // table view
        let cellNib: UINib = UINib(nibName: "WEATableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: WEA_LOCATION_CELL_IDENTIFIER)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.allowsSelection = false
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        // refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        // done button
        self.doneButton.setTitleTextAttributes([
            NSFontAttributeName: UIFont.wea_proximaNovaSemiboldWithSize(18.0)
        ], forState: UIControlState.Normal)
    }
    
    // MARK: - Refresh & reload
    
    func reload() {
        self.cities = WEACity.getAll()
        self.tableView.reloadData()
    }
    
    func refresh() {
        self.refreshControl.beginRefreshing()
        
        let ids: [NSNumber] = WEACity.getAll().map {
            return $0.weatherCityId!
        }

        WEAWeatherAPI.fetchCurrentWeatherForCities(ids, handler: { (response: AnyObject?, error: NSError?) -> Void in
            self.refreshControl.endRefreshing()
            
            if error != nil {
                self.showMessage(error!.localizedDescription)
                return
            }
            
            self.cities = WEACity.updateCitiesTodayForecast(response as? NSDictionary)
            self.tableView.reloadData()
        })
    }
    
    // MARK: -  Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "openSearch" {
                let navController = segue.destinationViewController as! WEANavigationController
                let vc = navController.viewControllers.first as! WEASearchTableViewController
                vc.delegate = self;
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: WEAForecastTableViewCell = tableView.dequeueReusableCellWithIdentifier(
            WEA_LOCATION_CELL_IDENTIFIER, forIndexPath: indexPath
        ) as! WEAForecastTableViewCell
        
        return self.configure(cell, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let attributedTitle: NSAttributedString = NSAttributedString(
            string: "x",
            attributes: [
                NSFontAttributeName: UIFont.wea_proximaNovaSemiboldWithSize(30)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]
        )
        let image: UIImage = UIImage.wea_imageForTableViewRowAction(
            attributedTitle,
            size: CGSizeMake(100.0, self.tableView(tableView, heightForRowAtIndexPath: indexPath)),
            backgroundColor: UIColor.wea_colorWithHexString("#FF8847")
        )!
        
        let deleteTitle = "              "
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: deleteTitle , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            tableView.beginUpdates()
            
            // delete entity
            let city: WEACity = self.cities[indexPath.row] as WEACity
            city.MR_deleteEntity()
            city.managedObjectContext?.MR_saveToPersistentStoreAndWait()
            self.cities.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.endUpdates()
        })
        
        deleteAction.backgroundColor = UIColor(patternImage: image)
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // ...
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var can = true
        
        if indexPath.row < self.cities.count {
            let city = self.cities[indexPath.row] as WEACity
            can = !city.isCurrent()
        }
        
        return can
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell: WEAForecastTableViewCell = self.prototypeCell
        cell = self.configure(cell, indexPath: indexPath)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
    
    // MARK: - WEADismissControllerProtocol
    
    func controller(controller: UIViewController, didDismissWithAnimation animation: Bool) {
        controller.dismissViewControllerAnimated(animation, completion: { () -> Void in
            self.reload()
        })
    }
    
    // MARK: - Event handlers
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configure(cell: WEAForecastTableViewCell, indexPath: NSIndexPath) -> WEAForecastTableViewCell {
        // get city and set name to title
        var city: WEACity = self.cities[indexPath.row]
        cell.titleLabel.text = city.name
        cell.current = city.isCurrent()
        
        // set newest forecast data
        if let forecast: WEAForecast = city.orderedForecast().first {
            cell.imageIconView.image = forecast.imageIcon
            cell.descriptionLabel.text = forecast.info
            cell.temperatureLabel.text = NSString(format: "%iº", forecast.temperatureIn(self.config.temperatureUnit).integerValue) as String
        }
        
        return cell
    }
    
}
