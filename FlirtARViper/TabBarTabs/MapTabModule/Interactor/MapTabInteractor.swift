//
//  MapTabInteractor.swift
//  FlirtARViper
//
//  Created by   on 04.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import CoreLocation

class MapTabInteractor: MapTabInteractorInputProtocol {
    
    //MARK: - Init
    init() {
        LocationService.shared.delegate = self
        queue.maxConcurrentOperationCount = maxQueueItems
    }
    
    //MARK: - Variables
    //user validation
    fileprivate var isUserValid = false
    
    //markers logic
    fileprivate var existingMarkers = Set<Marker>()
    fileprivate var distance = 0.0
    fileprivate var updateTimer = Timer()
    fileprivate var queue = OperationQueue()
    fileprivate var maxQueueItems = 10
    fileprivate var locationUpdated = false
    
    //MARK: - MapTabInteractorInputProtocol
    weak var presenter: MapTabIntercatorOutputProtocol?
    var remoteDatamanager: MapTabRemoteDatamanagerInputProtocol?
    
    
    func startGettingPeoplesNear(byDistance distance: Double) {
        self.distance = distance
        //updates
        updateTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(requestPeoples), userInfo: nil, repeats: true)
    }
    
    @objc func requestPeoples() {
        print("================Request sended")
        print("================Request distance: \(self.distance)")
        
        if !locationUpdated {
            LocationService.shared.updateUserLocation()
        }
        
        let operation = BlockOperation {
            self.remoteDatamanager?.requestPeoplesNear(byDistance: self.distance)
        }
        
        
        let lastOperation = self.queue.operations.last
        if lastOperation != nil {
            operation.addDependency(lastOperation!)
        }
        
        
        if queue.operationCount > maxQueueItems {
            queue.cancelAllOperations()
        }
        queue.addOperation(operation)
        
        
        
        
    }
    
    func stopGettingPeoplesNear() {
        updateTimer.invalidate()
        queue.cancelAllOperations()
    }
    
    
    func startUpdateUserLocation(location: CLLocation) {
        let longitude = location.coordinate.longitude.roundTo(symbols: 6)
        let latitude = location.coordinate.latitude.roundTo(symbols: 6)
        
        remoteDatamanager?.requestUpdateUserLocation(withLongitude: longitude, latitude: latitude)
        
    }
    
    func checkUserIsVisible() {
        let showOnMapStatus = ProfileService.savedUser?.showOnMap
        if showOnMapStatus != nil {
            presenter?.userVisibleStatusRecieved(status: showOnMapStatus!)
        }
    }
    
    func syncUserProfile() {
        remoteDatamanager?.requestUserProfile()
    }
    
    func validateCurrentProfile() {
        let user = ProfileService.savedUser
        guard let currentUser = user else {
            isUserValid = false
            presenter?.userValidationError(reason: .internalUserValidationError)
            return
        }
        print("DEBUG Map Interactor: Start user validation")
        let validationError = currentUser.validateForMapsUpdate()
        
        if validationError == nil {
            print("DEBUG Map Interactor: User valid")
            isUserValid = true
            startGettingPeoplesNear(byDistance: 80.0)
        } else {
            print("DEBUG Map Interactor: Validation error - \(validationError!.rawValue)")
            isUserValid = false
            presenter?.userValidationError(reason: validationError!)
        }
    }
    
}

extension MapTabInteractor: MapTabRemoteDatamanagerOutputProtocol {
    func recievedPeoples(peoples: [Marker]) {
        
        var markersForCreate = Set<Marker>()
        var markersForUpdate = Set<Marker>()
        var markersForRemove = Set<Marker>()
        
        let inputMarkers = Set<Marker>().union(peoples)
        
        //if it's init markers -> create it on map
        if existingMarkers.count == 0 {
            markersForCreate = inputMarkers
        } else {
            //for remove from maps
            markersForRemove = existingMarkers.subtracting(inputMarkers)
            //for create
            markersForCreate = inputMarkers.subtracting(existingMarkers)
            //for update
            markersForUpdate = inputMarkers.intersection(existingMarkers)
        }
        
        //update current markers
        existingMarkers = inputMarkers
        
        //send it to presenter
        presenter?.didRecievePeoples(create: markersForCreate,
                                     update: markersForUpdate,
                                     remove: markersForRemove)
        
        
    }
    
    func profileRecieved() {
        validateCurrentProfile()
    }
    
    func errorWhileRecievingProfile() {
        presenter?.userValidationError(reason: .internalUserValidationError)
    }
    
    
}

//MARK: - LocationServiceDelegate
extension MapTabInteractor: LocationServiceDelegate {
    func updateUserLocation(location: CLLocation) {
        if isUserValid && ProfileService.savedUser!.userID != nil {
            
            //save manual location
            if let manualLocation = ProfileService.userLocation {
                startUpdateUserLocation(location: manualLocation)
                print("++++++ MANUAL LOCATION FOR SERVER \(manualLocation)")
            } else {
                //update actual location
                startUpdateUserLocation(location: location)
                print("++++++ GPS LOCATION FOR SERVER \(location)")
            }
            
            locationUpdated = true
        }
    }
    
    func userSelectStatus(status: CLAuthorizationStatus) {
        presenter?.locationStatusChanged(newStatus: status)
    }
}
