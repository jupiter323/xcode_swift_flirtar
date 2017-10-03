//
//  SUChoosePhotoProtocol.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


protocol SUChoosePhotoViewProtocol: class {
    var presenter: SUChoosePhotoPresenterProtocol? {get set}
    func showPhotoSourceSelection()
}

protocol SUChoosePhotoWireframeProtocol {
    static func configureSUChoosePhotoView() -> UIViewController
    func backToPassword(fromView view: SUChoosePhotoViewProtocol)
    func routeToPhotosConfirm(fromView view: SUChoosePhotoViewProtocol,
                              sourceType type: PhotosProvider)
}

protocol SUChoosePhotoPresenterProtocol {
    var view: SUChoosePhotoViewProtocol? {get set}
    var wireframe: SUChoosePhotoWireframeProtocol? {get set}
    
    func showPhotosConfirm(sourceType type: PhotosProvider)
    func dismissMe()
    
    func startSelectPhotos()
    
}
