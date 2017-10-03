//
//  ProfileSettingsPresenter.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class ProfileSettingsPresenter: ProfileSettingsPresenterProtocol {
    weak var view: ProfileSettingsViewProtocol?
    var wireframe: ProfileSettingsWireframeProtocol?
    var interactor: ProfileSettingsInteractorInputProtocol?
    
    func viewDidLoad() {
        let modules = configureEmbendedPersonalModule()
        view?.embedThisModules(modules: modules)
    }
    func dismissMe() {
        wireframe?.backToProfileMainTab(fromView: view!)
    }
    
    func showSplash() {
        wireframe?.routeToSplash(fromView: view!)
    }
    
    private func configureEmbendedPersonalModule() -> [UIViewController] {
        let personalInfo = PersonalInfoWireframe.configureSUProfileInfoView()
        let personalPreference = PersonalPreferenceWireframe.configurePersonalPreferenceView()
        let notificationsInfo = NotificationsInfoWireframe.configureNotificationsInfoView()
        let accountInfo = AccountInfoWireframe.configureAccountInfoView()
        return [personalInfo, personalPreference, notificationsInfo, accountInfo]
    }
    
    func startSavingProfile() {
        view?.showActivityIndicator(withType: .saving)
        interactor?.saveProfile()
    }
    
    func startDeletingProfile() {
        view?.showActivityIndicator(withType: .deleting)
        interactor?.deleteProfile()
    }
}

extension ProfileSettingsPresenter: ProfileSettingsIntercatorOutputProtocol {
    func saveSuccess() {
        view?.hideActivityIndicator()
        view?.showProfileSaveSucceess()
    }
    
    func deleteSuccess() {
        view?.hideActivityIndicator()
        view?.showProfileDeleteSuccess()
    }
    
    func requestError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? UpdateProfileError) != nil  {
            errorText = (error as! UpdateProfileError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
        
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
