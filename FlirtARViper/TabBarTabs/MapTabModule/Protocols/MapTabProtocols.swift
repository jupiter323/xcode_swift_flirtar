//
//  MapTabProtocols.swift
//  FlirtARViper
//
//  Created by   on 04.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import CoreLocation

enum UserMapValidation: String {
    case photosInvalid = "Please, \nupload 3 photos with your face"
    case preferencesInvalid = "Please, \ninclude who are you looking for"
    case internalUserValidationError = "Internal user validation error"
}

protocol MapTabViewProtocol: class {
    
    var presenter: MapTabPresenterProtocol? {get set}
    
    func invisibleMode(isActivated status: Bool)
    
    func createMarkers(newMarkers markers: Set<Marker>)
    func updateMarkers(updMarkers markers: Set<Marker>)
    func removeMarkers(remMarkers markers: Set<Marker>)
    
    func showLocationServiceNotification(withMessage message: LocationServiceNotification)
    func showMapNotification(withReason reason: UserMapValidation)
    
}

protocol MapTabWireframeProtocol {
    static func configureMapTabView() -> UIViewController
    func routeToProfileSettings(fromView view: MapTabViewProtocol)
}

protocol MapTabPresenterProtocol {
    var view: MapTabViewProtocol? {get set}
    var wireframe: MapTabWireframeProtocol? {get set}
    var interactor: MapTabInteractorInputProtocol? {get set}
    
    func viewWillAppear()
    func viewWillDisappear()
    
    func updateUserLocation()
    
    func openProfileSettings()
    
}

protocol MapTabInteractorInputProtocol {
    var presenter: MapTabIntercatorOutputProtocol? {get set}
    var remoteDatamanager: MapTabRemoteDatamanagerInputProtocol? {get set}
    func startGettingPeoplesNear(byDistance distance: Double)
    func startUpdateUserLocation(location: CLLocation)
    func stopGettingPeoplesNear()
    
    func syncUserProfile()
    
    func checkUserIsVisible()
    func validateCurrentProfile()
    
}

protocol MapTabIntercatorOutputProtocol: class {
    func didRecievePeoples(create: Set<Marker>,
                           update: Set<Marker>,
                           remove: Set<Marker>)
    
    func locationStatusChanged(newStatus: CLAuthorizationStatus)
    func userVisibleStatusRecieved(status: Bool)
    func userValidationError(reason: UserMapValidation)
    
}

protocol MapTabRemoteDatamanagerOutputProtocol: class {
    func recievedPeoples(peoples: [Marker])
    func profileRecieved()
    func errorWhileRecievingProfile()
}


protocol MapTabRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:MapTabRemoteDatamanagerOutputProtocol? {get set}
    func requestPeoplesNear(byDistance distance: Double)
    func requestUpdateUserLocation(withLongitude: Double, latitude: Double)
    func requestUserProfile()
}
