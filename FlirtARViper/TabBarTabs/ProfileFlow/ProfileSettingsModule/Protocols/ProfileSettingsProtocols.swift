//
//  ProfileSettingsProtocols.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol ProfileSettingsViewProtocol: class {
    
    var presenter: ProfileSettingsPresenterProtocol? {get set}
    
    
    func embedThisModules(modules: [UIViewController])
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage)
    func hideActivityIndicator()
    func showProfileSaveSucceess()
    func showProfileDeleteSuccess()
    
    func showFillError(method: String, errorMessage: String)
    func showError(method: String, errorMessage: String)
}

protocol ProfileSettingsWireframeProtocol {
    static func configureProfileSettingsView() -> UIViewController
    func routeToSplash(fromView view: ProfileSettingsViewProtocol)
    func backToProfileMainTab(fromView view: ProfileSettingsViewProtocol)
    
}

protocol ProfileSettingsPresenterProtocol {
    var view: ProfileSettingsViewProtocol? {get set}
    var wireframe: ProfileSettingsWireframeProtocol? {get set}
    var interactor: ProfileSettingsInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    func dismissMe()
    func showSplash()
    
    func startSavingProfile()
    func startDeletingProfile()
    
}


protocol ProfileSettingsInteractorInputProtocol {
    var presenter: ProfileSettingsIntercatorOutputProtocol? {get set}
    var remoteDatamanager: ProfileSettingsRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: ProfileSettingsLocalDatamanagerInputProtocol? {get set}
    
    func saveProfile()
    func deleteProfile()
}

protocol ProfileSettingsIntercatorOutputProtocol: class {
    func saveSuccess()
    func deleteSuccess()
    
    func requestError(method: APIMethod, error: Error)
    func errorWhileFillingFields(method: APIMethod, errors: [Error])
}

protocol ProfileSettingsRemoteDatamanagerOutputProtocol: class {
    func profileSaved()
    func profileDeleted()
    
    func requestError(method: APIMethod, error: Error)
    func fillFieldsError(method: APIMethod, errors: [Error])
    
}


protocol ProfileSettingsRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:ProfileSettingsRemoteDatamanagerOutputProtocol? {get set}
    
    func requestSaveProfile(withProfile profile: User)
    func requestDeleteProfile()
}

protocol ProfileSettingsLocalDatamanagerInputProtocol: class {
    func updateProfile(withProfile profile: User, userId: Int) throws
    func clearUser() throws
}

