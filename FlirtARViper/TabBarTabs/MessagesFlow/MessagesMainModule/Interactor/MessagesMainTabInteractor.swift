//
//  MessagesMainTabInteractor.swift
//  FlirtARViper
//
//  Created by  on 16.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import SwiftyJSON

class MessagesMainTabInteractor: MessagesMainTabInteractorInputProtocol {
    
    //MARK: - Variables
    fileprivate var currentPage: Int?
    fileprivate var previousPage: Int?
    fileprivate var nextPage: Int?
    
    
    //MARK: - MessagesMainTabInteractorInputProtocol
    weak var presenter: MessagesMainTabInteractorOutputProtocol?
    var remoteDatamanager: MessagesMainTabRemoteDatamanagerInputProtocol?
    
    func startGettingMessages() {
        currentPage = nil
        previousPage = nil
        nextPage = nil
        remoteDatamanager?.requestUserMessagesList()
    }
    
    func startRemoveDialog(dialog: Dialog) {
        guard let chatId = dialog.id,
            let userId = dialog.user?.id else {
            presenter?.errorWhileRemovingDialog(method: APIMethod.removeDialog, error: DialogError.selectedChatInvalid)
            return
        }
        
        remoteDatamanager?.requestRemoveDialog(withId: chatId, andUser:  userId)
    }
    
    func startLoadMoreDialogs() {
        guard let next = nextPage else {
            //call presenter
            presenter?.appendMessagesRecieved(dialogs: [Dialog]())
            return
        }
        
        remoteDatamanager?.requestMoreUserMessagesList(page: next)
        
    }
    
    func clearPages() {
        self.currentPage = nil
        self.nextPage = nil
        self.previousPage = nil
    }
    
    func addDialogsObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageInDialog(_:)), name: NSNotification.Name(MessageNotificationName.postNewDialog.rawValue), object: nil)
        
        
    }
    
    func removeDialogsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Observer
    @objc func newMessageInDialog(_ notification: Notification) {
        if let messageString = notification.userInfo?["data"] as? String {
            
            let js = JSON(parseJSON: messageString)            
            
            if let jsDict = js["payload"]["data"].dictionary {
                var message = Message()
                
                
                if jsDict["message"]?.stringValue == nil ||
                    jsDict["room"]?.intValue == nil  {
                    return
                }
                
                message.messageText = (jsDict["message"]?.stringValue)!
                
                
                let fileTypeIncome = jsDict["file_type"]?.stringValue ?? ""
                if !fileTypeIncome.isEmpty {
                    message.fileType = MessageFileType.type(by: fileTypeIncome)
                }
                
                let fileUrl = jsDict["file_url"]?.stringValue ?? ""
                if !fileUrl.isEmpty {
                    message.fileUrl = fileUrl
                }
                
                let thumbnail = jsDict["thumbnail"]?.stringValue ?? ""
                if !thumbnail.isEmpty {
                    message.thumbnailImageUrl = thumbnail
                }
                
                let date = jsDict["created"]?.stringValue ?? ""
                if !date.isEmpty {
                    message.created = DateFormatter.markerModelDateFormatter.date(from: date)
                }
                
                message.isRead = jsDict["is_read"]?.boolValue
                
                let room = (jsDict["room"]?.intValue)!
                
                presenter?.newMessage(message: message, forRoom: room)

                
            }
            
        }
    }
    
}

//MARK: - MessagesMainTabRemoteDatamanagerOutputProtocol
extension MessagesMainTabInteractor: MessagesMainTabRemoteDatamanagerOutputProtocol {
    
    func messagesRecieved(dialogs: [Dialog],
                          currentPage: Int?,
                          nextPage: Int?,
                          previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.didMessagesRecived(dialogs: dialogs)
    }
    
    func errorWhileRecievingMessages(method: APIMethod, error: Error) {
        presenter?.messagesRecieveError(method: method, error: error)
    }
    
    func appendMessagesRecieved(dialogs: [Dialog],
                                currentPage: Int?,
                                nextPage: Int?,
                                previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
    
        presenter?.appendMessagesRecieved(dialogs: dialogs)
    }
    
    func dialogRemoved() {
        presenter?.dialogRemoved()
    }
    
    func errorWhileRemovingDialog(method: APIMethod, error: Error) {
        presenter?.errorWhileRemovingDialog(method: method, error: error)
    }
}
