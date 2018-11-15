//
//  Marker.swift
//  FlirtARViper
//
//  Created by  on 09.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper


struct Location {
    var id: Int?
    var coodinates: CLLocationCoordinate2D?
    var modified: Date?
}

struct MarkerUser {
    var id: Int?
    var firstname: String?
    var age: String?
    var photo: Photo?
    var gender: Gender?
    var showOnMap: Bool?
}

struct Marker {
    let user: MarkerUser?
    let location: Location?
}

extension Marker: Hashable {
    var hashValue: Int {
        guard let markerUser = user?.id else {
            return -1
        }
        
        return markerUser
    }
    
    var locationValue: Double {
        guard let markerLatitude = location?.coodinates?.latitude,
            let markerLongitude = location?.coodinates?.longitude else {
            return -1.0
        }
        return markerLatitude + markerLongitude
    }
}

extension Marker: Equatable {
    public static func ==(lhs: Marker, rhs: Marker) -> Bool {
        if lhs.user?.id == rhs.user?.id {
            return true
        }
        return false
    }
}

extension Location: Equatable {
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        if lhs.coodinates?.latitude == rhs.coodinates?.latitude
            && lhs.coodinates?.longitude == rhs.coodinates?.longitude {
            return true
        }
        return false
    }
}

extension Location: Mappable {
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map[ServerLocationJSONKeys.id.rawValue]
        
        var latitude: String = ""
        latitude <- map[ServerLocationJSONKeys.latitude.rawValue]
        
        var longitude: String = ""
        longitude <- map[ServerLocationJSONKeys.longitude.rawValue]
        
        let latitudeNumeric = Double(latitude)
        let longitudeNumeric = Double(longitude)
        
        if let latitudeNumeric = latitudeNumeric, let longitudeNumeric = longitudeNumeric {
            coodinates = CLLocationCoordinate2D(latitude: latitudeNumeric, longitude: longitudeNumeric)
        } else {
            coodinates = CLLocationCoordinate2D()
        }
        
        var modifiedString: String?
        modifiedString <- map[ServerLocationJSONKeys.modified.rawValue]
        
        if let modifiedString = modifiedString {
            modified = DateFormatter.markerModelDateFormatter.date(from: modifiedString)
        }
    }
}

extension MarkerUser: Mappable {
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map[ServerUserJSONKeys.id.rawValue]
        firstname <- map[ServerUserJSONKeys.firstName.rawValue]
        age <- map[ServerUserJSONKeys.age.rawValue]
        
        var genderString: String?
        genderString <- map[ServerUserJSONKeys.gender.rawValue]
        if let genderString = genderString {
            gender = Gender.gender(by: genderString)
        }
        
        showOnMap <- map[ServerUserJSONKeys.showOnMap.rawValue]
    }
}




