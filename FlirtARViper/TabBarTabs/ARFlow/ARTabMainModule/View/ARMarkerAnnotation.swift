//
//  ARMarkerAnnotation.swift
//  FlirtARViper
//
//  Created on 14.08.17.
//

import UIKit
import CoreLocation

class ARMarkerAnnotation: ARAnnotation {
    var markers: [Marker]?
    
    init?(withMarker markers: [Marker]) {
        self.markers = markers
        
        if markers.count > 1 {
            
            
            guard let coordinates = markers.first?.location?.coodinates else {
                return nil
            }
            
            var marketTitle = ""
            for eachMarker in markers {
                if let username = eachMarker.user?.firstname {
                    marketTitle += username + ", "
                }
            }
            
            marketTitle.characters.removeLast(2)
            
            let location = CLLocation(latitude: coordinates.latitude,
                                      longitude: coordinates.longitude)
            
            super.init(identifier: "", title: marketTitle, location: location)!
            
            
        } else if markers.count == 1 {
            guard let identifier = markers.first?.hashValue,
                let title = markers.first?.user?.firstname,
                let coordincates = markers.first?.location?.coodinates else {
                    return nil
            }
            
            let location = CLLocation(latitude: coordincates.latitude,
                                      longitude: coordincates.longitude)
            
            super.init(identifier: "\(identifier)", title: title, location: location)!
        } else {
            super.init(identifier: "", title: "", location: CLLocation())!
        }
        
        
        
        
    }
}
