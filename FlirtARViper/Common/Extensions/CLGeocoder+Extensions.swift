//
//  CLGeocoder+Extensions.swift
//  FlirtARViper
//
//  Created by on 13.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import CoreLocation

enum GeocoderAddressComponent: String {
    case country = "Country"
    case city = "City"
    case name = "Name"
}

extension CLGeocoder {
    func getAddressForLocation(location: CLLocation,
                               completionHandler: @escaping (_ address: String?) -> ()) {
        
        self.reverseGeocodeLocation(location) { (placemarks, error) in
            
            //check location exist
            guard let placemarks = placemarks,
                let placeMark = placemarks.first,
                let addressDictionary = placeMark.addressDictionary else {
                    completionHandler(nil)
                    return
            }
            
            
            //parse address
            var addressString = ""
            
            // Country
            if let country = addressDictionary[GeocoderAddressComponent.country.rawValue] as? String {
                addressString.append(" \(country),")
            }
            
            // City
            if let city = addressDictionary[GeocoderAddressComponent.city.rawValue] as? String {
                addressString.append(" \(city),")
            }
            
            // Location name
            if let locationName = addressDictionary[GeocoderAddressComponent.name.rawValue] as? String {
                addressString.append(" \(locationName)")
                
            }
            
            //check address for empty
            if addressString.isEmpty {
                completionHandler(nil)
            } else {
                completionHandler(addressString)
            }
            
        }
    }
    
    
    func getLocationForAddress(address: String,
                               completionHandler: @escaping (_ location: CLLocation?) -> ())  {
        self.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location else {
                    completionHandler(nil)
                    return
            }
            completionHandler(location)
            
        }
    }
}
