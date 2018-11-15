//
//  MessagesDetailPresenter.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

class MessagesDetailPresenter: MessagesDetailPresenterProtocol {
    
    weak var view: MessagesDetailViewProtocol?
    var wireframe: MessagesDetailWireframeProtocol?
    var interactor: MessagesDetailInteractorInputProtocol?
    
    var selectedDialog: Dialog?
    
    func viewWillAppear() {
        if let chatId = selectedDialog?.id {
            view?.showActivityIndicator(withType: .loading)
            interactor?.initSocket(withRoom: chatId)
            interactor?.startGettingMessages(forChat: chatId)
        }
        
        if let user = selectedDialog?.user {
            view?.fillGeneralInfo(withUser: user)
        }
    }
    
    func reloadDialog() {
        if let chatId = selectedDialog?.id {
            view?.showActivityIndicator(withType: .loading)
            interactor?.startGettingMessages(forChat: chatId)
        }
    }
    
    func dismissMe() {
        wireframe?.backToDialogs(fromView: view!)
    }
    
    func openProfile(profileId: Int?) {
        if profileId != nil {
            wireframe?.openProfileInfo(forProfile: profileId!)
        } else {
            guard let userId = selectedDialog?.user?.id else {
                return
            }
            wireframe?.openProfileInfo(forProfile: userId)
        }
        
    }
    
    
    func sendMessage(withText text: String,
                     attachment: LocalAttachment?) {
        
        if attachment != nil {
            view?.showActivityIndicator(withType: .sending)
            
        }
        
        interactor?.startMessageSending(withRoom: selectedDialog?.id,
                                        withText: text,
                                        attachment: attachment)
        
    }
    
    func reportUser(withText: String) {
        guard let userId = selectedDialog?.user?.id else {
            return
        }
        
        view?.showActivityIndicator(withType: .loading)
        interactor?.startReportUser(withText: withText, andUserId: userId)
    }
    
    func blockUser() {
        guard let userId = selectedDialog?.user?.id else {
            return
        }
        
        view?.showActivityIndicator(withType: .loading)
        interactor?.startBlockUser(userId: userId)
    }
    
    func loadMoreMessages() {
        if let chatId = selectedDialog?.id {
            interactor?.startLoadMoreMessages(forChat: chatId)
        } else {
            view?.hideActivityIndicator()
        }
    }
}

//MARK: - MessagesDetailInteractorOutputProtocol
extension MessagesDetailPresenter: MessagesDetailInteractorOutputProtocol {
    func didMessagesRecived(messages: [Message]) {
        view?.hideActivityIndicator()
        view?.showMessages(messages: messages)
    }
    
    func appendMessagesRecieved(messages: [Message]) {
        if messages.count != 0 {
            view?.appendMoreMessages(messages: messages)
        }
        view?.hideActivityIndicator()
    }
    
    func allMessagesLoaded() {
        view?.hideActivityIndicator()
    }
    
    func messagesRecieveError(errorMessage: String) {
        view?.hideActivityIndicator()
        view?.showError(errorMessage: errorMessage)
    }
    
    
    func newMessageFromSocket(message: Message) {
        view?.hideActivityIndicator()
        view?.appendNewMessage(message: message)
    }
    
    func userBlocked() {
        view?.hideActivityIndicator()
        view?.showUserBlocked()
    }
    
    func userReported() {
        view?.hideActivityIndicator()
        view?.showUserReported()
    }
    
    func errorWhileBanUser(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? BanUserError) != nil  {
            errorText = (error as! BanUserError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        view?.showError(errorMessage: errorText)
    }
}








