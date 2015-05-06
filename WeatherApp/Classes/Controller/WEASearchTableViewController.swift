//
//  WEASearchTableViewController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 18/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit
import CoreLocation

let WEA_SEARCH_CELL_IDENTIFIER = "WEASearchCell"

class WEASearchTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    var delegate: WEADismissControllerProtocol?
    var cities: NSArray = []
    var searchBar: UISearchBar?
    
    // MARK: - Screen life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: Setup
    
    func setup() {
        // Search Bar
        
        var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 20))
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.setImage(UIImage(named: "Search"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchBar.setImage(UIImage(named: "Close"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        
        var textField: UITextField = searchBar.valueForKey("_searchField") as! UITextField
        textField.textColor = UIColor.wea_colorWithHexString("#2f91ff")
        textField.font = UIFont.wea_proximaNovaRegularWithSize(16.0)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.wea_colorWithHexString("#2f91ff").CGColor
        textField.layer.cornerRadius = 5.0
        textField.becomeFirstResponder()
        
        var button = searchBar.valueForKey("cancelButton") as! UIButton
        button.setTitle("Close", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.wea_proximaNovaSemiboldWithSize(17.0)
        
        self.navigationItem.titleView = searchBar
        self.searchBar = searchBar
        
        // TableView
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 37, 0, 0)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        WEAGoogleAPI.findCity(searchText, handler: { (places: NSArray?, error: NSError?) -> Void in
            if error != nil {
                self.showMessage(error!.localizedDescription)
                return
            }
            
            self.cities = places!
            self.tableView.reloadData()
        })
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar?.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDataSource and UITableViewDelegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: WEASearchTableViewCell = tableView.dequeueReusableCellWithIdentifier(
            WEA_SEARCH_CELL_IDENTIFIER, forIndexPath: indexPath
        ) as! WEASearchTableViewCell
        
        let city: NSDictionary = self.cities[indexPath.row] as! NSDictionary
        let description: String = city.valueForKey("description") as! String
        var text: NSMutableAttributedString = NSMutableAttributedString(string: description)
        for match: NSDictionary in city["matched_substrings"] as! [NSDictionary] {
            let offset: NSNumber = match["offset"] as! NSNumber
            let length: NSNumber = match["length"] as! NSNumber
            let range: NSRange = NSRange(location: offset.integerValue, length: length.integerValue)
            text.addAttribute(NSFontAttributeName, value: UIFont.wea_proximaNovaSemiboldWithSize(16.0)!, range: range)
        }
        
        cell.cityLabel.attributedText = text
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data: NSDictionary = self.cities[indexPath.row] as! NSDictionary
        let googlePlaceId: String = data["place_id"] as! String
        
        WEAGoogleAPI.getCityDetail(googlePlaceId, handler: { (location: NSDictionary?, error: NSError?) -> Void in
            if error != nil || location == nil {
                self.showMessage(error!.localizedDescription)
                return
            }
            
            let latitude: NSNumber = location?.valueForKey("lat") as! NSNumber
            let longtitude: NSNumber = location?.valueForKey("lng") as! NSNumber
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                latitude: latitude.doubleValue,
                longitude: longtitude.doubleValue
            )
            
            WEAWeatherAPI.fetchForecast(coordinate, days: 1, handler: { (response: AnyObject?, error: NSError?) -> Void in
                if error != nil {
                    self.showMessage(error!.localizedDescription)
                    return
                }
                
                if let cityId: NSNumber = response?.valueForKeyPath("city.id") as? NSNumber {
                    var city: WEACity = WEACity.getOrCreate(cityId)
                    city.setEntityData(response)
                    city.googlePlaceId = googlePlaceId
                    city.managedObjectContext?.MR_saveToPersistentStoreAndWait()
                    
                    self.dismiss()
                }
            })

        })
    }
    
    // MARK: - Helpers
    
    func dismiss() {
        if self.delegate != nil {
            self.delegate?.controller(self, didDismissWithAnimation: false)
        }
    }

}
