//
//  WEANavigationController.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 13/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEANavigationController: UINavigationController {

    // MARK: - Screen life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup();
    }
    
    // MARK: Setup
    
    func setup() {
        // nice navigation bottom border line
        // TODO(vojta) reposition/resize on rotation if landscape is supported
        var image = UIImage(named: "Line")
        var layer = self.navigationBar.layer
        var borderLayer = CALayer()
        borderLayer.borderColor = UIColor(patternImage:image!).CGColor
        borderLayer.borderWidth = 2
        borderLayer.frame = CGRectMake(0, layer.bounds.size.height, layer.bounds.size.width, 2);
        layer.addSublayer(borderLayer)
    }
   
}
