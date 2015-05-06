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
        self.setupObserver()
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
    
    func setupObserver() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("showNotification:"),
            name: "cz.vojtechbartos.WeatherApp.notification",
            object: nil
        )
    }
    
    // MARK: - Notification
    
    func showNotification(notification: NSNotification) {
        let notificationView = UIView()
        notificationView.backgroundColor = UIColor.wea_colorWithHexString("#ff8847")
        
        let label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, 0))
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.wea_proximaNovaRegularWithSize(15.0)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.text = notification.object?.valueForKey("message") as? String
        
        let size = label.sizeThatFits(CGSizeMake(self.view.bounds.size.width, CGFloat.max))
        label.frame = CGRectMake(0, 0, self.view.bounds.size.width, size.height + 30)
        notificationView.frame = CGRectMake(0, 0, self.view.bounds.size.width, label.frame.size.height)
        notificationView.addSubview(label)
        self.view.insertSubview(notificationView, belowSubview: self.navigationBar)
        
        UIView.animateWithDuration(0.5,
            animations: { () -> Void in
                notificationView.frame = CGRectMake(
                    0,
                    self.navigationBar.frame.height + self.navigationBar.frame.origin.y,
                    notificationView.frame.size.width,
                    notificationView.frame.size.height
                )
            }, completion: { (finished: Bool) -> Void in
                self.removeNotification(notificationView)
            }
        )
        
    }
    
    func removeNotification(view: UIView) {
        UIView.animateWithDuration(NSTimeInterval(0.5), delay: 3.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.frame = CGRectMake(
                0,
                0,
                view.frame.size.width,
                view.frame.size.height
            )
            }, completion: { (finished: Bool) -> Void in
                view.removeFromSuperview()
            }
        )
    }
    
    // MARK: - System
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
   
}
