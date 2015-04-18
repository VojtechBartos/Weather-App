//
//  WEAForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 17/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEAForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    // MARK: Setups
    
    func setup() {
        // title label
        self.titleLabel.font = UIFont.wea_proximaNovaSemiboldWithSize(18.0)
        self.titleLabel.textColor = UIColor.wea_colorWithHexString("#333333")
        
        // description label
        self.descriptionLabel.font = UIFont.wea_proximaNovaRegularWithSize(15.0)
        self.descriptionLabel.textColor = UIColor.wea_colorWithHexString("#333333")
    
        // temperature label
        self.temperatureLabel.font = UIFont.wea_proximaNovaLightWithSize(55.0)
        self.temperatureLabel.textColor = UIColor.wea_colorWithHexString("#2f91ff")
    }
}
