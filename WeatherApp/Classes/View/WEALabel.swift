//
//  WEALabel.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 03/05/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEALabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds)
    }

}
