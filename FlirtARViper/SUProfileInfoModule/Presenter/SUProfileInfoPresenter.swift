//
//  SUProfileInfoPresenter.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUProfileInfoPresenter: SUProfileInfoPresenterProtocol {
    
    weak var view: SUProfileInfoViewProtocol?
    var wireframe: SUProfileInfoWireframeProtocol?
    var interactor: SUProfileInfoInteractorInputProtocol?
    
    func viewDidLoad() {
        
        let modules = configureEmbendedPersonalModule()
        view?.embedThisModules(modules: modules)
        
        
    }
    
    func startSignUp() {
        view?.showActivityIndicator(withType: .signingUp)
        interactor?.signUp()
    }

    
    func showTabBarView() {
        view?.removeEmbedModules()
        wireframe?.routeToTabBarView(fromView: view!)
    }
    
    func dismissMe() {
        view?.removeEmbedModules()
        wireframe?.backToPhotosConfirm(fromView: view!)
    }
    
    func saveShowOnMapStatus(status: Bool) {
        interactor?.saveShowOnMapStatus(status: status)
    }
    
    private func configureEmbendedPersonalModule() -> [UIViewController] {
        let personalInfo = PersonalInfoWireframe.configureSUProfileInfoView()
        let personalPreference = PersonalPreferenceWireframe.configurePersonalPreferenceView()
        return [personalInfo, personalPreference]
    }
}

extension SUProfileInfoPresenter: SUProfileInfoIntercatorOutputProtocol {
    
    func signUpSuccess() {
        print("DEBUG SUProfile Presenter: Signed up")
        view?.hideActivityIndicator()
        view?.showActivityIndicator(withType: .uploadingPhotos)
        
        print("DEBUG SUProfile Presenter: Start save photos")
        interactor?.savePhotos()
    }

    func photosUploadSuccess() {
        print("DEBUG SUProfile Presenter: Photos uploaded")
        view?.hideActivityIndicator()
        view?.showPhotosUploadedSuccess()
    }
    
    func errorWhileSignUp(method: APIMethod, error: Error) {
        print("DEBUG SUProfile Presenter: Sign up error - \(error.localizedDescription)")
        view?.hideActivityIndicator()
        var errorText = ""
        if (error as? SignUpError) != nil  {
            errorText = (error as! SignUpError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func errorWhileFillingFields(method: APIMethod, errors: [Error]) {
        
        print("DEBUG SUProfile Presenter: Sign up fields incorret")
        view?.hideActivityIndicator()
        
        if let fillErrors = errors as? [FillProfileError] {
            let errorsStrings = fillErrors.map({ (currentError) -> String in
                return currentError.localizedDescription
            })
            
            view?.showFillError(errorMessage: "This fields required: \n \(errorsStrings.joined(separator: "\n"))")
            
        }
    }
    
    func errorWhileUploadingPhotos(method: APIMethod, error: Error) {
        print("DEBUG SUProfile Presenter: Photos not uploaded")
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? PhotosUploadError) != nil  {
            errorText = (error as! PhotosUploadError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showPhotosUploadError(method: method.rawValue, errorMessage: errorText)
    }

}
