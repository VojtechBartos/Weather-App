//
//  WEASettingsTableViewController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 15/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

let WEA_SETTINGS_ITEM_CELL_IDENTIFIER = "WEASettingsItemCell"
let WEA_SETTINGS_PICKER_CELL_IDENTIFIER = "WEASettingsPickerCell"

class WEASettingsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    let config: WEAConfig = WEAConfig.sharedInstance
    let settings: [AnyObject] = [
        [
            "label": "Unit of length",
            "choices": ["Meters", "Yards"]
        ],
        [
            "label": "Units of temperature",
            "choices": ["Celsius", "Fahrenheit"]
        ]
    ]

    var pickerAtPosition: NSIndexPath?
    
    // MARK: - Screen life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.view.backgroundColor = UIColor.whiteColor()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 2
        if self.pickerAtPosition?.section == section {
            count++
        }
        return count
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.pickerAtPosition != nil && self.pickerAtPosition?.row == indexPath.row {
            let index: Int = indexPath.row - 1
            let setting: NSDictionary = self.settings[index] as! NSDictionary
            let cell = tableView.dequeueReusableCellWithIdentifier(
                WEA_SETTINGS_PICKER_CELL_IDENTIFIER, forIndexPath: indexPath
            ) as! WEAPickerTableViewCell
    
            cell.choices = setting.valueForKey("choices") as! [String]
            cell.picker.reloadAllComponents()

            let current = (index == 0) ? self.config.lengthUnit.hashValue : self.config.temperatureUnit.hashValue
            cell.picker.selectRow(current, inComponent: 0, animated: false)
            
            cell.didSelectBlock = { (row: Int) -> Void in
                switch index {
                    case 0:
                        self.config.lengthUnit = WEAForecastLengthUnit(rawValue: row)!
                        break;
                        
                    case 1:
                        self.config.temperatureUnit = WEAForecastTemperatureUnit(rawValue: row)!
                        break;
                        
                    default:
                        break;
                }
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            }
            
            return cell
        }
        
        
        let setting: NSDictionary = self.settings[indexPath.row] as! NSDictionary
        let choices: [String] = setting.valueForKey("choices") as! [String]
        let cell = tableView.dequeueReusableCellWithIdentifier(
            WEA_SETTINGS_ITEM_CELL_IDENTIFIER, forIndexPath: indexPath
        ) as! UITableViewCell
        
        cell.textLabel?.text = setting.valueForKey("label") as? String
        cell.textLabel?.font = UIFont.wea_proximaNovaRegularWithSize(17.0)
        cell.textLabel?.textColor = UIColor.wea_colorWithHexString("#333333")
        
        cell.detailTextLabel?.text = "Celsius"
        cell.detailTextLabel?.font = UIFont.wea_proximaNovaRegularWithSize(17.0)
        cell.detailTextLabel?.textColor = UIColor.wea_colorWithHexString("#2f91ff")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = choices[config.lengthUnit.hashValue]
                break;
            
            case 1:
                cell.detailTextLabel?.text = choices[config.temperatureUnit.hashValue]
                break;
            
            default:
                break;
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "General"
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.font = UIFont.wea_proximaNovaSemiboldWithSize(14.0)
        header.textLabel.textColor = UIColor.wea_colorWithHexString("#2f91ff")
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        // NOTICE(vojta) because of losing bottom border on selection
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if let pickerPosition = self.pickerAtPosition {
            tableView.deleteRowsAtIndexPaths([pickerPosition], withRowAnimation: UITableViewRowAnimation.Middle)
            
            self.pickerAtPosition = nil
        }
        else {
            var indexPath =  NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
            
            self.pickerAtPosition = indexPath
        }
        
        tableView.endUpdates()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.pickerAtPosition == indexPath) ? 165 : 50
    }

}
