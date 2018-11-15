//
//  MessagesMainTabPresenter.swift
//  FlirtARViper
//
//  Created by  on 16.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

class MessagesMainTabPresenter: MessagesMainTabPresenterProtocol {
    weak var view: MessagesMainTabViewProtocol?
    var wireframe: MessagesMainTabWireframeProtocol?
    var interactor: MessagesMainTabInteractorInputProtocol?
    
    fileprivate var dialog: Dialog?
    
    func viewDidLoad() {
        let module = configureEmbendedLikes()
        view?.embedThisModule(module: module)
    }
    
    func viewWillAppear() {
        view?.showActivityIndicator(withType: .loading)
        interactor?.startGettingMessages()
        
        interactor?.addDialogsObserver()
        
        let mainTabController = ((view as? MessagesMainTabViewController)?.parent?.parent as? TabBarViewController)!
        mainTabController.clearBadgeNumber()
    }
    
    func viewWillDisappear() {
        interactor?.clearPages()
        
        interactor?.removeDialogsObserver()
    }
    
    func reloadDialogs() {
        view?.showActivityIndicator(withType: .loading)
        interactor?.startGettingMessages()
    }
    
    func loadMoreDialogs() {
        interactor?.startLoadMoreDialogs()
    }
    
    func openChat(selectedChat chat: Dialog) {
        wireframe?.routeToDetailMessages(fromView: view!,
                                         withDialog: chat)
    }
    
    
    func removeDialog() {
        view?.showActivityIndicator(withType: .removing)
        guard let dialog = dialog else {
            self.errorWhileRemovingDialog(method: APIMethod.removeDialog, error: DialogError.selectedChatInvalid)
            return
        }
        interactor?.startRemoveDialog(dialog: dialog)
    }
    
    func showRemoveDialogAlert(chat: Dialog) {
        dialog = chat
        view?.showRemoveDialogAlert()
    }
    
    func removeCancel() {
        dialog = nil
    }
    
    fileprivate func configureEmbendedLikes() -> UIViewController {
        let likesModule = MessagesLikesWireframe.configureMessagesLikesView()
        return likesModule
    }
    
}

extension MessagesMainTabPresenter: MessagesMainTabInteractorOutputProtocol {
    func didMessagesRecived(dialogs: [Dialog]) {
        view?.hideActivityIndicator()
        view?.showMessages(dialogs: dialogs)
    }
    
    func messagesRecieveError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        view?.showError(method: method.rawValue, errorMessage: error.localizedDescription)
    }
    
    func appendMessagesRecieved(dialogs: [Dialog]) {
        if dialogs.count != 0 {
            view?.appendMoreMessages(dialogs: dialogs)
        }
    }
    
    func newMessage(message: Message, forRoom room: Int) {
        view?.newMessage(message: message, forRoom: room)
    }
    
    func dialogRemoved() {
        view?.hideActivityIndicator()
        view?.dialogRemoved()
    }
    
    func errorWhileRemovingDialog(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? DialogError) != nil  {
            errorText = (error as! DialogError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
}
