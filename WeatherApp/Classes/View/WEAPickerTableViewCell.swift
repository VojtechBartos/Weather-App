//
//  WEAPickerTableViewCell.swift
//  WeatherApp
//
//  Created by Vojta Bartos on 25/04/15.
//  Copyright (c) 2015 Vojta Bartos. All rights reserved.
//

import UIKit

class WEAPickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var picker: UIPickerView!
    
    var didSelectBlock: ((row: Int) -> Void)?
    var choices: [String] = []
    
    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.choices.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.choices[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.didSelectBlock != nil {
            self.didSelectBlock!(row: row)
        }
    }
    
}
