//
//  ARProfileProtocols.swift
//  FlirtARViper
//
//  Created on 12.08.17.
//

import UIKit

protocol ARProfileViewProtocol: class {
    
    var presenter: ARProfilePresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showError(method: String, errorMessage: String)
    func showShortProfile(profile: ShortUser)
    func showInterests(interests: [String])
    
    func likeStatusChanged(newValue: Bool)
    
    func embedThisModule(module: UIViewController,
                         type: PhotosModuleType)
    
    func showUserBlocked()
    func showUserReported()
    
}

protocol ARProfileWireframeProtocol {
    static func configureARFullProfileView(withUser user: ShortUser) -> UIViewController
    static func configureARFullProfileView(withUserId userId: Int) -> UIViewController
    
    func backToMainAR(fromView view: ARProfileViewProtocol)
}

protocol ARProfilePresenterProtocol {
    var view: ARProfileViewProtocol? {get set}
    var wireframe: ARProfileWireframeProtocol? {get set}
    var interactor: ARProfileInteractorInputProtocol? {get set}
    
    var selectedUser: ShortUser? {get set}
    var selectedUserId: Int? {get set}
    
    func reportUser(withText: String)
    func blockUser()
    
    func viewDidLoad()
    func viewWillAppear(distance: CGFloat?)
    
    
    func startLike()
    func startDislike()
    func startUnlike()
    
    func dismissMe()
    
}

protocol ARProfileInteractorInputProtocol {
    
    var presenter: ARProfileInteractorOutputProtocol? {get set}
    var remoteDatamanager: ARProfileRemoteDatamanagerInputProtocol? {get set}
    
    func startChangingStatus(forUser userId: Int, status: Bool)
    func startUnlikeUser(forUser userId: Int)
    func startLoadingUser(userId: Int)
    
    func startReportUser(withText text: String, andUserId userId: Int)
    func startBlockUser(userId: Int)
    
    
}


protocol ARProfileInteractorOutputProtocol: class {
    
    func userRecieved(user: ShortUser)
    func errorWhileRecievingUser(method: APIMethod, error: Error)
    
    func didLikeMarkSet(newValue: Bool)
    func likeMarkNotSet(method: APIMethod, error: Error)
    
    func userBlocked()
    func userReported()
    func errorWhileBanUser(method: APIMethod, error: Error)
}


protocol ARProfileRemoteDatamanagerOutputProtocol: class {
    
    func userRecieved(user: ShortUser)
    func userRecieveError(method: APIMethod, error: Error)
    
    func likeStatusChanged(newValue: Bool)
    func errorWhileChangingLikeStatus(method: APIMethod, error: Error)
    
    func userBlocked()
    func userReported()
    func errorWhileBanUser(method: APIMethod, error: Error)
    
}



protocol ARProfileRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:ARProfileRemoteDatamanagerOutputProtocol? {get set}
    
    func requestUserFromServer(withUserId userId: Int)
    func requestLikeUser(withUserId userId: Int)
    func requestDislikeUser(withUserId userId: Int)
    func requestUnlikeUser(withUserId userId: Int)
    
    func requestReportUser(forUser userId: Int, reason: String)
    func requestBlockUser(forUser userId: Int)
}




























