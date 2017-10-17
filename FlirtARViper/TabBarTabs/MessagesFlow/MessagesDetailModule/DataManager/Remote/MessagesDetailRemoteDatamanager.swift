//
//  MessagesDetailRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessagesDetailRemoteDatamanager: MessagesDetailRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:MessagesDetailRemoteDatamanagerOutputProtocol?
    
    func requestUserMessages(withChatId chatId: Int) {
        let request = APIRouter.getMessages(chatId: chatId, page: nil)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileRecievingMessages(text: error!.localizedDescription)
                } else {
                    let previous = js!["previous"].int
                    let current = js!["current"].int
                    let next = js!["next"].int
                    
                    var messages = APIParser().parseMessages(js: js!)
                    messages.reverse()
                    
                    self.remoteRequestHandler?.messagesRecieved(messages: messages, currentPage: current, nextPage: next, previousPage: previous)
                }
        }
        
    }
    
    func requestMoreUserMessages(withChatId chatId: Int,
                                 page: Int) {
        
        let request = APIRouter.getMessages(chatId: chatId, page: page)
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.errorWhileRecievingMessages(text: error!.localizedDescription)
            } else {
                let previous = js!["previous"].int
                let current = js!["current"].int
                let next = js!["next"].int
                
                var messages = APIParser().parseMessages(js: js!)
                messages.reverse()
                
                self.remoteRequestHandler?.appendMessagesRecieved(messages: messages, currentPage: current, nextPage: next, previousPage: previous)
            }
        }
        
        
        
    }
    
    func requestBlockUser(forUser userId: Int) {
        let request = APIRouter.blockUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileBanUser(method: APIMethod.putBlockUser, error: BanUserError.userNotBlocked)
                } else {
                    self.remoteRequestHandler?.userBlocked()
                }
        }
        
    }
    
    func requestReportUser(forUser userId: Int, reason: String) {
        let request = APIRouter.reportUser(userId: userId, reportString: reason)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileBanUser(method: APIMethod.reportUser, error: BanUserError.userNotReported)
                } else {
                    self.remoteRequestHandler?.userReported()
                }
        }
        
    }
    
}
