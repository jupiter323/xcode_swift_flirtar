//
//  DatePicker.swift
//  FlirtARViper
//
//  Created by   on 03.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class DatePicker: UIDatePicker {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = UIColor.white
        datePickerMode = .date
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = -18
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        maximumDate = futureDate!
    }
}
