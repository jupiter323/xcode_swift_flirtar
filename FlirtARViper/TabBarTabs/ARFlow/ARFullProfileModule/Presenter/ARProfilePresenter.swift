//
//  ARProfilePresenter.swift
//  FlirtARViper
//
//  Created on 14.08.17.
//

import UIKit


class ARProfilePresenter: ARProfilePresenterProtocol {
    weak var view: ARProfileViewProtocol?
    var wireframe: ARProfileWireframeProtocol?
    var interactor: ARProfileInteractorInputProtocol?
    
    var selectedUser: ShortUser?
    var selectedUserId: Int?
    
    func viewWillAppear() {
        
        if let currentUser = selectedUser {
            view?.showShortProfile(profile: currentUser)
            let module = configureEmbendedPhotoModule(withPhotos: currentUser.photos)
            view?.embedThisModule(module: module)
        } else if let userId = selectedUserId {
            //request user from server
            view?.showActivityIndicator()
            interactor?.startLoadingUser(userId: userId)
        } else {
            return
        }
        
        
        guard let interestsString = selectedUser?.interests else {
            return
        }
        
        let interestsArrayByComma = interestsString.components(separatedBy: ",")
        let interestsArrayBySpace = interestsString.components(separatedBy: " ")
        
        if interestsArrayByComma.count >= interestsArrayBySpace.count {
            view?.showInterests(interests: interestsArrayByComma.filter{$0 != ""})
        } else {
            view?.showInterests(interests: interestsArrayBySpace.filter{$0 != ""})
        }
        
        view?.hideActivityIndicator()
        
        
    }
    
    func startUnlike() {
        guard let userId = selectedUser?.id else {
            return
        }
        
        interactor?.startUnlikeUser(forUser: userId)
        
        
    }
    
    func startLike() {
        guard let userId = selectedUser?.id else {
            return
        }
        
        interactor?.startChangingStatus(forUser: userId,
                                        status: false)
        
    }
    
    func startDislike() {
        guard let userId = selectedUser?.id else {
            return
        }
        
        interactor?.startChangingStatus(forUser: userId,
                                        status: true)
    }
    
    func reportUser(withText: String) {
        guard let userId = selectedUser?.id else {
            return
        }
        
        view?.showActivityIndicator()
        interactor?.startReportUser(withText: withText, andUserId: userId)
    }
    
    func blockUser() {
        guard let userId = selectedUser?.id else {
            return
        }
        
        view?.showActivityIndicator()
        interactor?.startBlockUser(userId: userId)
        
    }
    
    
    func dismissMe() {
        wireframe?.backToMainAR(fromView: view!)
    }
    
    fileprivate func configureEmbendedPhotoModule(withPhotos photos: [Photo]) -> UIViewController {
        let photoModule = UserPhotosWireframe.configurePhotosController(withPhotos: photos, orientation: .horizontal, containerType: .arProfile)
        return photoModule
    }

}

extension ARProfilePresenter: ARProfileInteractorOutputProtocol {
    
    func userRecieved(user: ShortUser) {
        view?.hideActivityIndicator()
        selectedUser = user
        self.viewWillAppear()
    }
    
    func errorWhileRecievingUser(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? SignUpError) != nil  {
            errorText = (error as! GetProfileError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func didLikeMarkSet(newValue: Bool) {
        view?.hideActivityIndicator()
        selectedUser?.isLiked = newValue
        view?.likeStatusChanged(newValue: newValue)
    }
    
    func likeMarkNotSet(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? LikeError) != nil  {
            errorText = (error as! LikeError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func userReported() {
        view?.hideActivityIndicator()
        view?.showUserReported()
    }
    
    func userBlocked() {
        view?.hideActivityIndicator()
        view?.showUserBlocked()
    }
    
    func errorWhileBanUser(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? BanUserError) != nil  {
            errorText = (error as! BanUserError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
}
