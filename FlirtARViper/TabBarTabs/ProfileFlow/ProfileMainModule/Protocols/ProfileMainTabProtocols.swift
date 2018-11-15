//
//  ProfileMainTabProtocols.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

enum PhotosModuleType {
    case apiPhotos
    case instagramPhotos
}

protocol ProfileMainTabViewProtocol: class {
    
    var presenter: ProfileMainTabPresenterProtocol? {get set}
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage)
    func hideActivityIndicator()
    
    func showProfile(profile: User)
    func showError(method: String, errorMessage: String)
    
    func showLocalPicker(picker: UIViewController)
    func showFbPicker(picker: NSObject)
    
    func showPhotoSourceSelection()
    
    func embedThisModule(module: UIViewController,
                         type: PhotosModuleType)
}

protocol ProfileMainTabWireframeProtocol {
    static func configureProfileMainTapView() -> UIViewController
    func routeToProfileSettings(fromView view: ProfileMainTabViewProtocol?)
}

protocol ProfileMainTabPresenterProtocol {
    var view: ProfileMainTabViewProtocol? {get set}
    var wireframe: ProfileMainTabWireframeProtocol? {get set}
    var interactor: ProfileMainTabInteractorInputProtocol? {get set}
    
    func viewDidLoad(withDistance distance: CGFloat)
    func viewWillApear()
    func showProfileSettings()
    func startSelectPhotos(photo: Photo?)
    func selectLocalPhotos()
    func selectFBPhotos()
    
    //func updateShowOnMap(withStatus status: Bool)
    func updatePhotos(withPhotos photos: [UIImage])
}


protocol ProfileMainTabInteractorInputProtocol {
    var presenter: ProfileMainTabIntercatorOutputProtocol? {get set}
    var remoteDatamanager: ProfileMainTabRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: ProfileMainTabLocalDatamanagerInputProtocol? {get set}
    
    func startLoadingProfile()
    func updateProfileFromService()
    
//    func startUpdateShowOnMapStatus(status: Bool)
    func startUpdatePhotos(withPhotos photos: [UIImage])
    func startReplacePhoto(withPhoto newPhoto: UIImage,
                           replacePhoto oldPhoto: Photo)
}

protocol ProfileMainTabIntercatorOutputProtocol: class {
    func profileRecieved(profile: User)
    func errorWhileLoading(method: APIMethod, error: Error)
    
    func photosRecieved(photos: [Photo])
    func photosUpdateError(method: APIMethod, error: Error)
    
    func profileUpdatedFromService(profile: User)
//    func errorWhileUpdatingMapStatus(method: APIMethod, error: Error)
    
}

protocol ProfileMainTabRemoteDatamanagerOutputProtocol: class {
    func profileRecievedSuccess(profile: User)
    func profileRecievingError(method: APIMethod, error: Error)
    
    func photosRecievedSuccess(photos: [Photo])
    func photosUpdateError(method: APIMethod, error: Error)
    
    func photoReplacedSuccess(newPhoto: Photo,
                              oldPhoto: Photo)
    func photoReplaceError(method: APIMethod, error: Error)
    
}


protocol ProfileMainTabRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:ProfileMainTabRemoteDatamanagerOutputProtocol? {get set}
    func requestUserProfile()
    func requestUpdatePhotos(images: [UIImage])
    func requestReplacePhoto(newPhoto: UIImage,
                             oldPhoto: Photo)
}


protocol ProfileMainTabLocalDatamanagerInputProtocol: class {
    func savePhotos(photos: [Photo], forUser userId: Int) throws
}

