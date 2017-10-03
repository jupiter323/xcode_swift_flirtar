//
//  AccountInfoInteractor.swift
//  FlirtARViper
//
//  Created on 07.08.17.
//

import Foundation
import CoreLocation

class AccountInfoInteractor: AccountInfoInteractorInputProtocol {
    weak var presenter: AccountInfoInteractorOutputProtocol?
    var remoteDatamanager: AccountInfoRemoteDatamanagerInputProtocol?
    var localDatamanager: AccountInfoLocalDatamanagerInputProtocol?
    
    func startFBDisconnection() {
        remoteDatamanager?.requestFBDisconnect()
    }
    func startLogout() {
        remoteDatamanager?.requestLogout()
    }
    
    func saveShowOnMapStatus(status: Bool) {
        ProfileService.currentUser?.showOnMap = status
    }
    
    func startUpdateUserLocation(location: CLLocation) {
        
        let longitude = location.coordinate.longitude.roundTo(symbols: 6)
        let latitude = location.coordinate.latitude.roundTo(symbols: 6)
        
        remoteDatamanager?.requestUpdateUserLocation(withLongitude: longitude, latitude: latitude)
        
    }
    
    func getCurrentUser() {
        if let user = ProfileService.savedUser {
            presenter?.userRetrieved(user: user)
        }
    }
    
}

extension AccountInfoInteractor: AccountInfoRemoteDatamanagerOutputProtocol {
    
    func fbDisconnected() {
        presenter?.fbDisconnectionSuccess()
    }
    
    
    func requestError(method: APIMethod, error: Error) {
        presenter?.requestError(method: method, error: error)
    }
    
    func locationUpdated(location: CLLocation) {
        ProfileService.userLocation = location
        
        CLGeocoder().getAddressForLocation(location: location) { (address) in
            guard let addressString = address else {
                return
            }
            
            DispatchQueue.main.async {
                self.presenter?.updateLocationSuccess(address: addressString)
            }
            
        }
        
    }
    
    
    func logouted() {
        LocationService.shared.delegate = nil
        ProfileService.clearProfileService()
        
        do {
            try localDatamanager?.clearUser()
        } catch {
            print("Error local while logout")
        }
        
        presenter?.logoutSuccess()
    }
    
    
    
}
