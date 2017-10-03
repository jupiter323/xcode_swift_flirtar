//
//  SULicenseProtocols.swift
//  FlirtARViper
//
//  Created by on 18.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol SULicenseViewProtocol {
    var presenter: SULicensePresenterProtocol? {get set}
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage)
    func hideActivityIndicator()
    
    func showPhotosUploadedSuccess()
    
    func showError(method: String, errorMessage: String)
    func showPhotosUploadError(method: String, errorMessage: String)
    func showFillError(method: String, errorMessage: String)
    
    func showLicenseAgreement(withText text: String)
    func showLicenseAgreementRecieveError(method: String, errorMessage: String)
}

protocol SULicenseWireframeProtocol {
    static func configureSULicenseView() -> UIViewController
    func routeToTabBarView(fromView view: SULicenseViewProtocol)
    func backToProfileConfirm(fromView view: SULicenseViewProtocol)
}

protocol SULicensePresenterProtocol {
    var view: SULicenseViewProtocol? {get set}
    var wireframe: SULicenseWireframeProtocol? {get set}
    var interactor: SULicenseInteractorInputProtocol? {get set}
    
    func getLicenseAgreement()
    
    func saveProfile()
    func showTabBarView()
    func dismissMe()
}

protocol SULicenseInteractorInputProtocol {
    var presenter: SULicenseInteractorOutputProtocol? {get set}
    var remoteDatamanager: SULicenseRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: SULicenseLocalDatamanagerInputProtocol? {get set}
    
    func getLicenseAgreement()
    func startSaveProfile()
    func savePhotos()
}

protocol SULicenseInteractorOutputProtocol {
    func licenseRecieved(withText text: String)
    func licenseRecieveError(method: APIMethod, error: Error)
    
    func profileSavedSuccess()
    func errorWhileSignUp(method: APIMethod, error: Error)
    func errorWhileFillingFields(method: APIMethod, errors: [Error])
    
    func photosUploadSuccess()
    func errorWhileUploadingPhotos(method: APIMethod, error: Error)

}

protocol SULicenseRemoteDatamanagerOutputProtocol {
    func licenseRecieved(withText text: String)
    func licenseRecieveError(method: APIMethod, error: Error)
    
    func profileSaved()
    
    func profileSaveError(method: APIMethod, error: Error)
    func fillFieldsError(method: APIMethod, errors: [Error])
    
    func photosUploaded(photos: [Photo])
    func photosUploadError(method: APIMethod, error: Error)
}

protocol SULicenseRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:SULicenseRemoteDatamanagerOutputProtocol? {get set}
    func requestLicenseAgreement()
    func requestSaveProfile(withUser user: User)
    func requestSavingPhotos(withPhotos photos: [UIImage])
}

protocol SULicenseLocalDatamanagerInputProtocol: class {
    func saveUser(user: User, token: String) throws
    func savePhotos(photos: [Photo], forUser userId: Int) throws
    func clearDB() throws
}
