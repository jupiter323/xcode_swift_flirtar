//
//  MessagesMainProtocols.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol MessagesMainTabViewProtocol: class {
    
    var presenter: MessagesMainTabPresenterProtocol? {get set}
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage)
    func hideActivityIndicator()
    func showError(method: String, errorMessage: String)
    func showMessages(dialogs: [Dialog])
    
    func appendMoreMessages(dialogs: [Dialog])
    func newMessage(message: Message, forRoom room: Int)
    
    func dialogRemoved()
    func hideRemoveDialogAlert()
    func showRemoveDialogAlert()
    
    func embedThisModule(module: UIViewController)
}

protocol MessagesMainTabWireframeProtocol {
    static func configureMessagesMainTapView() -> UIViewController
    
    func routeToDetailMessages(fromView view: MessagesMainTabViewProtocol,
                               withDialog dialog: Dialog)
}

protocol MessagesMainTabPresenterProtocol {
    var view: MessagesMainTabViewProtocol? {get set}
    var wireframe: MessagesMainTabWireframeProtocol? {get set}
    var interactor: MessagesMainTabInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func reloadDialogs()
    func openChat(selectedChat chat: Dialog)
    
    func loadMoreDialogs()
    
    func removeDialog()
    func removeCancel()
    func showRemoveDialogAlert(chat: Dialog)
    
}

protocol MessagesMainTabInteractorInputProtocol {
    
    var presenter: MessagesMainTabInteractorOutputProtocol? {get set}
    var remoteDatamanager: MessagesMainTabRemoteDatamanagerInputProtocol? {get set}
    
    func startGettingMessages()
    func startRemoveDialog(dialog: Dialog)
    
    func startLoadMoreDialogs()
    func clearPages()
    
    func addDialogsObserver()
    func removeDialogsObserver()
}

protocol MessagesMainTabInteractorOutputProtocol: class {
    func didMessagesRecived(dialogs: [Dialog])
    func messagesRecieveError(method: APIMethod, error: Error)
    
    func appendMessagesRecieved(dialogs: [Dialog])
    func newMessage(message: Message, forRoom room: Int)
    
    func dialogRemoved()
    func errorWhileRemovingDialog(method: APIMethod, error: Error)

}

protocol MessagesMainTabRemoteDatamanagerOutputProtocol: class {
    func messagesRecieved(dialogs: [Dialog],
                          currentPage: Int?,
                          nextPage: Int?,
                          previousPage: Int?)
    
    func errorWhileRecievingMessages(method: APIMethod, error: Error)
    
    func appendMessagesRecieved(dialogs: [Dialog],
                                currentPage: Int?,
                                nextPage: Int?,
                                previousPage: Int?)
    
    func dialogRemoved()
    func errorWhileRemovingDialog(method: APIMethod, error: Error)
    
}



protocol MessagesMainTabRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:MessagesMainTabRemoteDatamanagerOutputProtocol? {get set}
    func requestUserMessagesList()
    
    func requestMoreUserMessagesList(page: Int)
    
    func requestRemoveDialog(withId chatId: Int, andUser userId: Int)
}







