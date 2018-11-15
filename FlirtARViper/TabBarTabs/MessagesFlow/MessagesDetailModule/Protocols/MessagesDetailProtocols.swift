//
//  MessagesDetailProtocols.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


protocol MessagesDetailViewProtocol: class {
    
    var presenter: MessagesDetailPresenterProtocol? {get set}
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage)
    func hideActivityIndicator()
    func showError(errorMessage: String)
    func showMessages(messages: [Message])
    
    func appendNewMessage(message: Message)
    
    func appendMoreMessages(messages: [Message])
    
    func fillGeneralInfo(withUser user: ShortUser)
    
    func showUserBlocked()
    func showUserReported()
}

protocol MessagesDetailWireframeProtocol {
    static func configureMessagesDetailView(withDialog dialog: Dialog) -> UIViewController
    func backToDialogs(fromView view: MessagesDetailViewProtocol)
    func openProfileInfo(forProfile profileId: Int)
}

protocol MessagesDetailPresenterProtocol {
    var view: MessagesDetailViewProtocol? {get set}
    var wireframe: MessagesDetailWireframeProtocol? {get set}
    var interactor: MessagesDetailInteractorInputProtocol? {get set}
    
    var selectedDialog: Dialog? {get set}
    
    func viewWillAppear()
    func reloadDialog()
    func sendMessage(withText text: String,
                     attachment: LocalAttachment?)
    func reportUser(withText: String)
    func blockUser()
    
    func loadMoreMessages()
    
    func openProfile(profileId: Int?)
    func dismissMe()
}

protocol MessagesDetailInteractorInputProtocol {
    
    var presenter: MessagesDetailInteractorOutputProtocol? {get set}
    var remoteDatamanager: MessagesDetailRemoteDatamanagerInputProtocol? {get set}
    
    func initSocket(withRoom room: Int)
    
    func startGettingMessages(forChat chatId: Int)
    func startMessageSending(withRoom room: Int?,
                             withText text: String,
                             attachment: LocalAttachment?)
    
    func startLoadMoreMessages(forChat chatId: Int)
    func startReportUser(withText text: String, andUserId userId: Int)
    func startBlockUser(userId: Int)
}

protocol MessagesDetailInteractorOutputProtocol: class {
    func didMessagesRecived(messages: [Message])
    func messagesRecieveError(errorMessage: String)
    
    func newMessageFromSocket(message: Message)
    
    func appendMessagesRecieved(messages: [Message])
    func allMessagesLoaded()
    
    func userBlocked()
    func userReported()
    func errorWhileBanUser(method: APIMethod, error: Error)
    
}

protocol MessagesDetailRemoteDatamanagerOutputProtocol: class {
    func messagesRecieved(messages: [Message],
                          currentPage: Int?,
                          nextPage: Int?,
                          previousPage: Int?)
    
    func errorWhileRecievingMessages(text: String)
    
    func appendMessagesRecieved(messages: [Message],
                                currentPage: Int?,
                                nextPage: Int?,
                                previousPage: Int?)
    
    func userBlocked()
    func userReported()
    func errorWhileBanUser(method: APIMethod, error: Error)
    
}



protocol MessagesDetailRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:MessagesDetailRemoteDatamanagerOutputProtocol? {get set}
    func requestUserMessages(withChatId chatId: Int)
    
    func requestMoreUserMessages(withChatId chatId: Int,
                                 page: Int)
    
    func requestReportUser(forUser userId: Int, reason: String)
    func requestBlockUser(forUser userId: Int)
}


