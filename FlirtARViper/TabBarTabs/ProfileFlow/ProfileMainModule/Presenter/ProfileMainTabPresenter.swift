//
//  ProfileMainTabPresenter.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit
import BSImagePicker
import Photos
import GBHFacebookImagePicker

class ProfileMainTabPresenter: ProfileMainTabPresenterProtocol {
    weak var view: ProfileMainTabViewProtocol?
    var wireframe: ProfileMainTabWireframeProtocol?
    var interactor: ProfileMainTabInteractorInputProtocol?
    
    fileprivate var newPicker: BSImagePickerViewController!
    fileprivate var fbPicker: GBHFacebookImagePicker!
    fileprivate var distance: CGFloat!
    
    fileprivate var photo: Photo?
    
    init() {
        newPicker = BSImagePickerViewController()
        fbPicker = GBHFacebookImagePicker()
        distance = 0.0
    }
    
    
    func viewDidLoad(withDistance distance: CGFloat) {
        view?.showActivityIndicator(withType: .loading)
        interactor?.startLoadingProfile()
        self.distance = distance
        
        let module = configureEmbendedInstagramModule()
        view?.embedThisModule(module: module, type: .instagramPhotos)
        
    }
    
    func showProfileSettings() {
        wireframe?.routeToProfileSettings(fromView: view!)
    }
    
    func viewWillApear() {
        view?.showActivityIndicator(withType: .loading)
        interactor?.updateProfileFromService()
        view?.hideActivityIndicator()
    }
    
    func updatePhotos(withPhotos photos: [UIImage]) {
        
        print("DEBUG Profile Presenter: Start upload photos")
        print("DEBUG Profile Presenter: Photos - \(photos)")
        
        view?.showActivityIndicator(withType: .uploadingPhotos)
        
        if photo != nil,
            let newPhoto = photos.first {
            interactor?.startReplacePhoto(withPhoto: newPhoto, replacePhoto: photo!)
        } else {
            interactor?.startUpdatePhotos(withPhotos: photos)
        }
    }
    
    func startSelectPhotos(photo: Photo? = nil) {
        self.photo = photo
        //check is facebook user
        if let isFBUser = ProfileService.currentUser?.isFacebook {
            //if true -> provide selection
            if isFBUser {
                view?.showPhotoSourceSelection()
            } else {
                //else -> only local storage
                selectLocalPhotos()
            }
        } else {
            //if isFB incorrect -> show local
            selectLocalPhotos()
        }
    }
    
    func selectLocalPhotos() {
        var maxPhotosCount = 3
        if photo != nil {
            maxPhotosCount = 1
        }
        newPicker.maxNumberOfSelections = maxPhotosCount
        newPicker.takePhotos = true
        view?.showLocalPicker(picker: newPicker)
        
    }
    
    func selectFBPhotos() {
        if photo == nil {
            GBHFacebookImagePicker.pickerConfig.allowMultipleSelection = true
            GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures = 3
        } else {
            GBHFacebookImagePicker.pickerConfig.allowMultipleSelection = false
            GBHFacebookImagePicker.pickerConfig.maximumSelectedPictures = 1
        }
        view?.showFbPicker(picker: fbPicker)
    }
    
    fileprivate func configureEmbendedPhotoModule(withPhotos photos: [Photo]) -> UIViewController {
        let photoModule = UserPhotosWireframe.configurePhotosController(withPhotos: photos, orientation: .horizontal, containerType: .settingsProfile, distance: self.distance)
        return photoModule
    }
    
    fileprivate func configureEmbendedInstagramModule() -> UIViewController {
        let userId = ProfileService.savedUser?.userID
        let instagramPhotosModule = InstagramPhotosWireframe.configureInstagramPhotosView(withUser: userId)
        return instagramPhotosModule
    }
    
}

extension ProfileMainTabPresenter: ProfileMainTabIntercatorOutputProtocol {
    func profileRecieved(profile: User) {
        view?.hideActivityIndicator()
        view?.showProfile(profile: profile)
    }
    func errorWhileLoading(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? GetProfileError) != nil  {
            errorText = (error as! GetProfileError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func photosRecieved(photos: [Photo]) {
        newPicker = BSImagePickerViewController()
        view?.hideActivityIndicator()
        let module = configureEmbendedPhotoModule(withPhotos: photos)
        view?.embedThisModule(module: module,
                              type: .apiPhotos)
    }
    
    func photosUpdateError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? PhotosUploadError) != nil  {
            errorText = (error as! PhotosUploadError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func profileUpdatedFromService(profile: User) {
        view?.showProfile(profile: profile)
    }
    
    func errorWhileUpdatingMapStatus(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? UpdateProfileError) != nil  {
            errorText = (error as! UpdateProfileError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
        interactor?.updateProfileFromService()
    }
    
}
