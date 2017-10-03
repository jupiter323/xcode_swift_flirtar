//
//  SUChoosePhotoPresenter.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUChoosePhotoPresenter: SUChoosePhotoPresenterProtocol {
    
    weak var view: SUChoosePhotoViewProtocol?
    var wireframe: SUChoosePhotoWireframeProtocol?
    
    func showPhotosConfirm(sourceType type: PhotosProvider) {
        wireframe?.routeToPhotosConfirm(fromView: view!,
                                        sourceType: type)
    }
    
    func startSelectPhotos() {
        //check is facebook user
        if let isFBUser = ProfileService.currentUser?.isFacebook {
            //if true -> provide selection
            if isFBUser {
                view?.showPhotoSourceSelection()
            } else {
                //else -> only local storage
                wireframe?.routeToPhotosConfirm(fromView: view!,
                                                sourceType: .local)
            }
        } else {
            //if isFB incorrect -> show local
            wireframe?.routeToPhotosConfirm(fromView: view!,
                                            sourceType: .local)
        }
    }
    
    func dismissMe() {
        wireframe?.backToPassword(fromView: view!)
    }
}
