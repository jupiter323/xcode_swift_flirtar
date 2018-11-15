//
//  SUConformPhotoPresenter.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import BSImagePicker
import GBHFacebookImagePicker

class SUConfirmPhotoPresenter: SUConfirmPhotoPresenterProtocol {
    
    weak var view: SUConfirmPhotoViewProtocol?
    var wireframe: SUConfirmPhotoWireframeProtocol?
    var interactor: SUConfirmPhotoInteractorInputProtocol?
    
    fileprivate var newPicker: BSImagePickerViewController!
    fileprivate var fbPicker: GBHFacebookImagePicker!
    
    init(withType type: PhotosProvider) {
        switch type {
        case .fb:
            fbPicker = GBHFacebookImagePicker()
        case .local:
            newPicker = BSImagePickerViewController()
        }
    }
    
    func viewDidLoad() {
        
        if newPicker != nil {
            newPicker.maxNumberOfSelections = 3
            newPicker.takePhotos = true
            view?.showLocalPicker(picker: newPicker)
        } else if fbPicker != nil {
            GBHFacebookImagePicker.pickerConfig.allowMultipleSelection = true
            GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures = 3
            view?.showFbPicker(picker: fbPicker)
        }
        
        
        
    }
    
    func showProfileConfirm() {
//        newPicker = nil
//        fbPicker = nil
        wireframe?.routeToProfileConfirm(fromView: view!)
    }
    
    func dismissMe() {
//        newPicker = nil
//        fbPicker = nil
        wireframe?.backToPassword(fromView: view!)
    }
    
    func updatePhotos(withPhotos photos: [UIImage]) {
        interactor?.savePhotos(photos: photos)
    }
}

extension SUConfirmPhotoPresenter: SUConfirmPhotoIntercatorOutputProtocol {
    func providePhotos(photos: [UIImage]) {
        view?.showPhotos(photos: photos)
    }
}
