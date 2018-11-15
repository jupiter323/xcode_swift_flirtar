//
//  LocationService.swift
//  FlirtARViper
//
//  Created by   on 04.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import CoreLocation


protocol LocationServiceDelegate: class {
    func updateUserLocation(location: CLLocation)
    func userSelectStatus(status: CLAuthorizationStatus)
}

enum LocationServiceNotification: String {
    case whenInUseMessage = "Your geoposition updates only when you use the application. Change it to \"Always\" in your phone settings so others can see your real-time geolocation."
    case denieMessage = "You set Never for location services. You geolocation is not updating and you can't see other users on the map. Please change permissions in phone settings"
}


class LocationService: NSObject {
    
    static var shared = LocationService()

    fileprivate var locationManager: CLLocationManager! = CLLocationManager()
    fileprivate var latestLocation: CLLocation?
    
    fileprivate var updateTimer = Timer()
    
    override init() {
        super.init()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.requestAlwaysAuthorization()
        
        updateTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateUserLocation), userInfo: nil, repeats: true)
        
    }
    
    func updateUserLocation() {
        if latestLocation != nil {
            self.delegate?.updateUserLocation(location: latestLocation!)
        }
    }
    
    weak var delegate: LocationServiceDelegate?
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        latestLocation = locations.sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }.first
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else if status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
            delegate?.userSelectStatus(status: status)
        } else if status == .restricted || status == .denied {
            locationManager?.stopUpdatingLocation()
            delegate?.userSelectStatus(status: status)
        }
    }
}
