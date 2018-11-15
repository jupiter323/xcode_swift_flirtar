//
//  AccountInfoProtocols.swift
//  FlirtARViper
//
//  Created on 07.08.17.
//

import UIKit
import CoreLocation

protocol AccountInfoViewProtocol: class {
    var presenter: AccountInfoPresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    
    
    func showLogoutSuccess()
    func fillDataWithUser(user: User)
    func showSuccessMessage(messageType: SuccessMessage)
    func showFBDisconnectSuccess(messageType: SuccessMessage)
    func showInstagramConnectSuccess(messageType: SuccessMessage)
    func showInstagramDisconnectSuccess(messageType: SuccessMessage)
    
    func showInstagramDisconnectError(method: String, errorMessage: String)
    func showInstagramConnectError(method: String, errorMessage: String)
    func showFBDisconnectError(method: String, errorMessage: String)
    func locationChangeError(method: String, errorMessage: String)
    func showRequestError(method: String, errorMessage: String)
    func locationSelectCancelled()
    func showNewLocation(address: String)
    
}

protocol AccountInfoWireframeProtocol {
    static func configureAccountInfoView() -> UIViewController
    
    func routeToSelectLocation(fromView view: AccountInfoViewProtocol,
                               andPresenter presenter: AccountInfoPresenterProtocol)
    func routeToSplash(fromView view: AccountInfoViewProtocol)
    func routeToBlockedUsers(fromView view: AccountInfoViewProtocol)
    func routeToInstagramAuth(fromView view: AccountInfoViewProtocol)
}

protocol AccountInfoPresenterProtocol {
    var view: AccountInfoViewProtocol? {get set}
    var wireframe: AccountInfoWireframeProtocol? {get set}
    var interactor: AccountInfoInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    
    func saveShowOnMap(isEnabled status: Bool)
    func allowUserLocationCanged(isEnabled status: Bool)
    func facebookConnectionDisable()
    func instagramConnection(withToken token: String)
    func instagramDisconnection()
    func logout()
    
    func showSplash()
    func showBlockedUsers()
    
    func showInstagramAuth()
    
}

protocol AccountInfoInteractorInputProtocol {
    var presenter: AccountInfoInteractorOutputProtocol? {get set}
    var remoteDatamanager: AccountInfoRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: AccountInfoLocalDatamanagerInputProtocol? {get set}
    
    func startFBDisconnection()
    func startInstagramConnection(withToken token: String)
    func startInstagramDisconnection()
    func startLogout()
    
    func startUpdateUserLocation(location: CLLocation)
    
    func getCurrentUser()
    func saveShowOnMapStatus(status: Bool)
    
    
}

protocol AccountInfoInteractorOutputProtocol: class {
    func userRetrieved(user: User)
    func fbDisconnectionSuccess()
    func instagramConnectionSuccess()
    func instagramDisconnectionSuccess()
    func logoutSuccess()
    func updateLocationSuccess(address: String)
    func requestError(method: APIMethod, error: Error)
    
}

protocol AccountInfoRemoteDatamanagerOutputProtocol: class {
    func fbDisconnected()
    func instagramConnected()
    func instagramDisconnected()
    func logouted()
    
    func locationUpdated(location: CLLocation)
    
    func requestError(method: APIMethod, error: Error)
    
    
}


protocol AccountInfoRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:AccountInfoRemoteDatamanagerOutputProtocol? {get set}
    
    func requestUpdateUserLocation(withLongitude: Double, latitude: Double)
    func requestFBDisconnect()
    func requestInstagramConnection(withToken token: String)
    func requestInstagramDisconnection()
    func requestLogout()
}

protocol AccountInfoLocalDatamanagerInputProtocol: class {
    func clearUser() throws
    func saveInstagramStatus(userId: Int, status: Bool) throws
    func saveFacebookStatus(userId: Int, status: Bool) throws
}






