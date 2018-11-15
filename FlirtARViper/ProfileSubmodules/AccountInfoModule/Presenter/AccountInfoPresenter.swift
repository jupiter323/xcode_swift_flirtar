//
//  AccountInfoPresenter.swift
//  FlirtARViper
//
//  Created on 07.08.17.
//

import Foundation
import CoreLocation

class AccountInfoPresenter: AccountInfoPresenterProtocol {
    weak var view: AccountInfoViewProtocol?
    var wireframe: AccountInfoWireframeProtocol?
    var interactor: AccountInfoInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.getCurrentUser()
    }
    
    func saveShowOnMap(isEnabled status: Bool) {
        interactor?.saveShowOnMapStatus(status: status)
    }
    
    func allowUserLocationCanged(isEnabled status: Bool) {
        if status {
            wireframe?.routeToSelectLocation(fromView: view!,
                                             andPresenter: self)

        } else {
            ProfileService.userLocation = nil
        }
    }
    
    func facebookConnectionDisable() {
        view?.showActivityIndicator()
        interactor?.startFBDisconnection()
    }
    
    func instagramConnection(withToken token: String) {
        view?.showActivityIndicator()
        interactor?.startInstagramConnection(withToken: token)
    }
    
    func instagramDisconnection() {
        view?.showActivityIndicator()
        interactor?.startInstagramDisconnection()
    }
    
    func logout() {
        view?.showActivityIndicator()
        interactor?.startLogout()
    }
    
    func showSplash() {
        wireframe?.routeToSplash(fromView: view!)
    }
    
    func showBlockedUsers() {
        wireframe?.routeToBlockedUsers(fromView: view!)
    }
    
    func showInstagramAuth() {
        wireframe?.routeToInstagramAuth(fromView: view!)
    }
}

extension AccountInfoPresenter: AccountInfoInteractorOutputProtocol {
    
    func userRetrieved(user: User) {
        view?.fillDataWithUser(user: user)
    }

    func fbDisconnectionSuccess() {
        view?.hideActivityIndicator()
        view?.showFBDisconnectSuccess(messageType: .accountDisconnected)
    }
    
    func instagramConnectionSuccess() {
        view?.hideActivityIndicator()
        view?.showInstagramConnectSuccess(messageType: .accountConnected)
    }
    
    func instagramDisconnectionSuccess() {
        view?.hideActivityIndicator()
        view?.showInstagramDisconnectSuccess(messageType: .accountDisconnected)
    }
    
    func logoutSuccess() {
        view?.hideActivityIndicator()
        view?.showLogoutSuccess()
    }
    
    func updateLocationSuccess(address: String) {
        view?.hideActivityIndicator()
        view?.showSuccessMessage(messageType: .saved)
        view?.showNewLocation(address: address)
    }
    
    
    func requestError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        //check cell -> change switch
        switch method {
        case .fbDisconnect:
            view?.showFBDisconnectError(method: method.rawValue, errorMessage: error.localizedDescription)
        case .updateLocation:
            view?.locationChangeError(method: method.rawValue, errorMessage: error.localizedDescription)
        case .postInstagram:
            view?.showInstagramConnectError(method: method.rawValue, errorMessage: error.localizedDescription)
        case .instagramDisconnect:
            view?.showInstagramDisconnectError(method: method.rawValue, errorMessage: error.localizedDescription)
        default:
            view?.showRequestError(method: method.rawValue, errorMessage: error.localizedDescription)
        }
    }
    
}

//MARK: - SelectLocationViewControllerDelegate
extension AccountInfoPresenter: SelectLocationViewControllerDelegate {
    func locationConfirmed(newLocation: CLLocation) {
        view?.showActivityIndicator()
        interactor?.startUpdateUserLocation(location: newLocation)
    }
    
    func selectLocationCancelled() {
        view?.locationSelectCancelled()
    }
}
