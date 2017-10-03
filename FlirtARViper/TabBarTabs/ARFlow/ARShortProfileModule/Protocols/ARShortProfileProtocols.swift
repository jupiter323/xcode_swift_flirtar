//
//  ARShortProfileProtocols.swift
//  FlirtARViper
//
//  Created by Daniel Harold on 16.08.17.
//  Copyright © 2017 Daniel Harold. All rights reserved.
//

import UIKit

protocol ARShortProfileViewProtocol: class {
    
    var presenter: ARShortProfilePresenterProtocol? {get set}
    
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showError(errorMessage: String)
    func showShortProfile(profile: ShortUser)
    
    func showButtons(buttons: [ARProfileButton])
    func hideButtons(buttons: [ARProfileButton])
    
    func likeStatusChanged()
    
    
}

protocol ARShortProfileWireframeProtocol {
    static func configureARShortProfileView(withMarkers: [Marker]) -> UIViewController
    
    func showFullInfo(fromView view: ARShortProfileViewProtocol,
                      withUser user: ShortUser)
}

protocol ARShortProfilePresenterProtocol {
    var view: ARShortProfileViewProtocol? {get set}
    var wireframe: ARShortProfileWireframeProtocol? {get set}
    var interactor: ARShortProfileInteractorInputProtocol? {get set}
    
    var markers: [Marker]? {get set}
    
    func viewWillAppear()
    
    func startSetLike()
    func showFullInfo()
    
    func showNextUser()
    func showPreviousUser()
    
}

protocol ARShortProfileInteractorInputProtocol {
    
    var presenter: ARShortProfileInteractorOutputProtocol? {get set}
    var remoteDatamanager: ARShortProfileRemoteDatamanagerInputProtocol? {get set}
    
    
    func startGettingInfo(forUser userId: Int)
    func startChangingStatus(forUser userId: Int, status: Bool)
    
}


protocol ARShortProfileInteractorOutputProtocol: class {
    
    
    func didLikeMarkSet()
    func likeMarkNotSet()
    
    func didProfileRecived(profile: ShortUser)
    func profileRecieveError(errorMessage: String)
}


protocol ARShortProfileRemoteDatamanagerOutputProtocol: class {
    func likeStatusChanged()
    func errorWhileChangingLikeStatus(text: String)
    
    func profileRecived(profile: ShortUser)
    func errorWhileRecievingProfile(text: String)
}



protocol ARShortProfileRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:ARShortProfileRemoteDatamanagerOutputProtocol? {get set}
    
    func requestUserInfo(withUserId userId: Int)
    func requestLikeUser(withUserId userId: Int)
    func requestUnlikeUser(withUserId userId: Int)
}
