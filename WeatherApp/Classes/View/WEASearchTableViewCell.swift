//
//  WEASearchTableViewCell.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 21/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEASearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.cityLabel.font = UIFont.wea_proximaNovaLightWithSize(16.0)
        self.cityLabel.textColor = UIColor.wea_colorWithHexString("#333333")
    }
    
}
