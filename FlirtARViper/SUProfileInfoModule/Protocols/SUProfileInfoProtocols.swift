//
//  SUProfileInfoProtocols.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//


import UIKit


protocol SUProfileInfoViewProtocol: class {
    
    var presenter: SUProfileInfoPresenterProtocol? {get set}
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage)
    func hideActivityIndicator()
    
    func showPhotosUploadedSuccess()
    
    func showError(method: String, errorMessage: String)
    func showPhotosUploadError(method: String, errorMessage: String)
    func showFillError(errorMessage: String)
    
    func embedThisModules(modules: [UIViewController])
    func removeEmbedModules()
}

protocol SUProfileInfoWireframeProtocol {
    static func configureSUProfileInfoView() -> UIViewController
    func routeToTabBarView(fromView view: SUProfileInfoViewProtocol)
    func backToPhotosConfirm(fromView view: SUProfileInfoViewProtocol)
}

protocol SUProfileInfoPresenterProtocol {
    var view: SUProfileInfoViewProtocol? {get set}
    var wireframe: SUProfileInfoWireframeProtocol? {get set}
    var interactor: SUProfileInfoInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    
    func saveShowOnMapStatus(status: Bool)
    
    func startSignUp()
    func showTabBarView()
    func dismissMe()
    
}

protocol SUProfileInfoInteractorInputProtocol {
    var presenter: SUProfileInfoIntercatorOutputProtocol? {get set}
    var remoteDatamanager: SUProfileInfoRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: SUProfileInfoLocalDatamanagerInputProtocol? {get set}

    func saveShowOnMapStatus(status: Bool)
    func signUp()
    
    func savePhotos()
}

protocol SUProfileInfoIntercatorOutputProtocol: class {
    func signUpSuccess()
    func errorWhileSignUp(method: APIMethod, error: Error)
    func errorWhileFillingFields(method: APIMethod, errors: [Error])
    
    func photosUploadSuccess()
    func errorWhileUploadingPhotos(method: APIMethod, error: Error)
}

protocol SUProfileInfoRemoteDatamanagerOutputProtocol: class {
    func signedUp()
    
    func signUpError(method: APIMethod, error: Error)
    func fillFieldsError(method: APIMethod, errors: [Error])
    
    func photosUploaded(photos: [Photo])
    func photosUploadError(method: APIMethod, error: Error)
}


protocol SUProfileInfoRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:SUProfileInfoRemoteDatamanagerOutputProtocol? {get set}
    func requestSignUp(withUser user: User)
    func requestSavingPhotos(withPhotos photos: [UIImage])
}

protocol SUProfileInfoLocalDatamanagerInputProtocol: class {
    func saveUser(user: User, token: String) throws
    func savePhotos(photos: [Photo], forUser userId: Int) throws
    func clearDB() throws
}












