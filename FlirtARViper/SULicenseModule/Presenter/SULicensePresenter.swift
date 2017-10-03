//
//  SULicensePresenter.swift
//  FlirtARViper
//
//  Created by on 18.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SULicensePresenter: SULicensePresenterProtocol {
    var view: SULicenseViewProtocol?
    var wireframe: SULicenseWireframeProtocol?
    var interactor: SULicenseInteractorInputProtocol?
    
    func getLicenseAgreement() {
        view?.showActivityIndicator(withType: .loading)
        interactor?.getLicenseAgreement()
    }
    
    func saveProfile() {
        view?.showActivityIndicator(withType: .saving)
        interactor?.startSaveProfile()
    }
    
    func showTabBarView() {
        wireframe?.routeToTabBarView(fromView: view!)
    }
    
    func dismissMe() {
        wireframe?.backToProfileConfirm(fromView: view!)
    }
}


extension SULicensePresenter: SULicenseInteractorOutputProtocol {
    func licenseRecieved(withText text: String) {
        view?.hideActivityIndicator()
        view?.showLicenseAgreement(withText: text)
    }
    
    func licenseRecieveError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        view?.showLicenseAgreementRecieveError(method: method.rawValue, errorMessage: error.localizedDescription)
    }
    
    func profileSavedSuccess() {
        view?.hideActivityIndicator()
        view?.showActivityIndicator(withType: .uploadingPhotos)
        interactor?.savePhotos()
    }
    
    func errorWhileSignUp(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? SignUpError) != nil  {
            errorText = (error as! SignUpError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func photosUploadSuccess() {
        view?.hideActivityIndicator()
        view?.showPhotosUploadedSuccess()
    }
    
    func errorWhileUploadingPhotos(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? PhotosUploadError) != nil  {
            errorText = (error as! PhotosUploadError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showPhotosUploadError(method: method.rawValue, errorMessage: errorText)
    }
    
    func errorWhileFillingFields(method: APIMethod, errors: [Error]) {
        view?.hideActivityIndicator()
        
        if let fillErrors = errors as? [FillProfileError] {
            let errorsStrings = fillErrors.map({ (currentError) -> String in
                return currentError.localizedDescription
            })
            
            
            view?.showFillError(method: method.rawValue, errorMessage: "This fields required: \n \(errorsStrings.joined(separator: "\n"))")
            
        }
    }
}
