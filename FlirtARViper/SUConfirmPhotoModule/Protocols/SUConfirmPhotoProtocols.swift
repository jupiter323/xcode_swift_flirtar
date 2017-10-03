//
//  SUConfirmPhotoProtocols.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


protocol SUConfirmPhotoViewProtocol: class {
    var presenter: SUConfirmPhotoPresenterProtocol? {get set}
    
    func showLocalPicker(picker: UIViewController)
    func showFbPicker(picker: NSObject)
    
    func showPhotos(photos: [UIImage])
    
}

protocol SUConfirmPhotoWireframeProtocol {
    static func configureSUConfirmPhotoView(withSourceType type: PhotosProvider) -> UIViewController
    func backToPassword(fromView view: SUConfirmPhotoViewProtocol)
    func routeToProfileConfirm(fromView view: SUConfirmPhotoViewProtocol)
}

protocol SUConfirmPhotoPresenterProtocol {
    var view: SUConfirmPhotoViewProtocol? {get set}
    var wireframe: SUConfirmPhotoWireframeProtocol? {get set}
    var interactor: SUConfirmPhotoInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    func showProfileConfirm()
    func dismissMe()
    
    func updatePhotos(withPhotos photos: [UIImage])
}

protocol SUConfirmPhotoInteractorInputProtocol {
    var presenter: SUConfirmPhotoIntercatorOutputProtocol? {get set}
    
    func savePhotos(photos: [UIImage])
}

protocol SUConfirmPhotoIntercatorOutputProtocol: class {
    func providePhotos(photos: [UIImage])
}





