//
//  MessagesMainTabRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 16.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessagesMainTabRemoteDatamanager: MessagesMainTabRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:MessagesMainTabRemoteDatamanagerOutputProtocol?
    
    func requestUserMessagesList() {
        
        let request = APIRouter.getListMessages(page: nil)
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.errorWhileRecievingMessages(method: APIMethod.getMessages, error: error!)
            } else {
                let dialogs = APIParser().parseDialogs(js: js!)
                let previous = js!["previous"].int
                let current = js!["current"].int
                let next = js!["next"].int
                
                
                self.remoteRequestHandler?
                    .messagesRecieved(dialogs: dialogs,
                                      currentPage: current,
                                      nextPage: next,
                                      previousPage: previous)
            }
        }
        
    }
    
    func requestMoreUserMessagesList(page: Int) {
        
        let request = APIRouter.getListMessages(page: page)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, _) in
                if js != nil {
                    let dialogs = APIParser().parseDialogs(js: js!)
                    let previous = js!["previous"].int
                    let current = js!["current"].int
                    let next = js!["next"].int
                    
                    self.remoteRequestHandler?
                        .appendMessagesRecieved(dialogs: dialogs,
                                                currentPage: current,
                                                nextPage: next,
                                                previousPage: previous)
                }
                
        }
        
    }
    
    
    func requestRemoveDialog(withId chatId: Int, andUser userId: Int) {
        let request = APIRouter.removeChat(chatId: chatId)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileRemovingDialog(method: APIMethod.removeDialog, error: error!)
                } else {
                    self.requestRemoveLike(forUser: userId)
                }
        }
        
    }
    
    func requestRemoveLike(forUser userId: Int) {
        let request = APIRouter.unlikeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileRemovingDialog(method: APIMethod.setDislike, error: error!)
                } else {
                    self.remoteRequestHandler?.dialogRemoved()
                }
        }
        

    }
    
}
