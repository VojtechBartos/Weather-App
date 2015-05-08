//
//  UIImage+WEACustom.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 18/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func wea_imageForTableViewRowAction(attributedText: NSAttributedString, size: CGSize, backgroundColor: UIColor) -> UIImage? {
        var rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.mainScreen().nativeScale);
        
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, rect)
        
        var label: UILabel = UILabel(frame: rect)
        label.textAlignment = NSTextAlignment.Center
        label.attributedText = attributedText
        label.drawTextInRect(rect)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
