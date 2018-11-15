//
//  DateFormatter+Extensions.swift
//  FlirtARViper
//
//  Created by   on 03.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var inputViewDateFormatter: DateFormatter! {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter
    }
    
    static var apiModelDateFormatter: DateFormatter! { //1994-03-17
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static var markerModelDateFormatter: DateFormatter! {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
    
    static var HMDateFormatter: DateFormatter! {
        let formatter  = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    
    static var DMYFormatter: DateFormatter! {
        let formatter  = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        return formatter
    }
    
}
