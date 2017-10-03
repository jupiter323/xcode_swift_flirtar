//
//  MapTabPresenter.swift
//  FlirtARViper
//
//  Created by   on 04.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import CoreLocation

class MapTabPresenter: MapTabPresenterProtocol {
    
    //MARK: - MapTabPresenterProtocol
    weak var view: MapTabViewProtocol?
    var wireframe: MapTabWireframeProtocol?
    var interactor: MapTabInteractorInputProtocol?
    
    
    func viewWillAppear() {
        interactor?.checkUserIsVisible()
        interactor?.validateCurrentProfile()
    }
    
    func viewWillDisappear() {
        interactor?.stopGettingPeoplesNear()
    }
    
    func updateUserLocation() {
        guard let userLocation = ProfileService.userLocation else {
            return
        }
        interactor?.startUpdateUserLocation(location: userLocation)
    }
    
    func openProfileSettings() {
        wireframe?.routeToProfileSettings(fromView: view!)
    }
    
}

//MARK: - MapTabIntercatorOutputProtocol
extension MapTabPresenter: MapTabIntercatorOutputProtocol {
    
    func didRecievePeoples(create: Set<Marker>,
                           update: Set<Marker>,
                           remove: Set<Marker>) {
        view?.createMarkers(newMarkers: create)
        view?.updateMarkers(updMarkers: update)
        view?.removeMarkers(remMarkers: remove)
    }
    
    
    func locationStatusChanged(newStatus: CLAuthorizationStatus) {
        switch newStatus {
        case .denied:
            view?.showLocationServiceNotification(withMessage: .denieMessage)
        case .authorizedWhenInUse:
            let isShow = UserDefaults.standard.bool(forKey: "location")
            if isShow == false {
                view?.showLocationServiceNotification(withMessage: .whenInUserMessage)
                UserDefaults.standard.set(true, forKey: "location")
            }
        default:
            break
        }
    }
    
    func userVisibleStatusRecieved(status: Bool) {
        view?.invisibleMode(isActivated: status)
    }
    
    
    func userValidationError(reason: UserMapValidation) {
        view?.showMapNotification(withReason: reason)
    }
    
}
