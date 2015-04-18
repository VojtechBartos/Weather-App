//
//  WEAForecastTableViewController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 13/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEAForecastTableViewController: UITableViewController {

    let days: [String] = ["Ahoj", "Franto", "Jak", "se", "mas"]
    
    var editable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 93, 0, 0)
        self.tableView.allowsSelection = false
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    
    // MARK: UITableViewDelegate
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: WEAForecastTableViewCell =
        tableView.dequeueReusableCellWithIdentifier("WEAForecastCell", forIndexPath: indexPath) as! WEAForecastTableViewCell
        
        cell.imageIconView?.image = UIImage(named: "CL")
        cell.titleLabel?.text = self.days[indexPath.row]
        cell.temperatureLabel.text = "22°"

        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let attributedTitle: NSAttributedString = NSAttributedString(
            string: "x",
            attributes: [
                NSFontAttributeName: UIFont.wea_proximaNovaSemiboldWithSize(30)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]
        )
        let image: UIImage = UIImage.wea_imageForTableViewRowAction(
            attributedTitle,
            size: CGSizeMake(100.0, 100.0),
            backgroundColor: UIColor.wea_colorWithHexString("#FF8847")
        )!
        
        let deleteTitle = "              "
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: deleteTitle , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            
            println("actionnnn")
        })
        
        deleteAction.backgroundColor = UIColor(patternImage: image)
        return [deleteAction]
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.editable
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 99.0
    }

}
