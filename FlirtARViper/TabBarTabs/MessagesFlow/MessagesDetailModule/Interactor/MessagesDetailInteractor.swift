//
//  MessagesDetailInteractor.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON

class MessagesDetailInteractor: MessagesDetailInteractorInputProtocol {
    
    //MARK: - Variables
    fileprivate var currentPage: Int?
    fileprivate var previousPage: Int?
    fileprivate var nextPage: Int?
    fileprivate var totalCount: Int = 0
    fileprivate var startNumber: Int = 0
    
    //MARK: - MessagesDetailInteractorInputProtocol
    func initSocket(withRoom room: Int) {
        SocketManager.shared.configureMessageSocket(withRoom: room)
        SocketManager.shared.messageDelegate = self
    }
    
    
    
    weak var presenter: MessagesDetailInteractorOutputProtocol?
    var remoteDatamanager: MessagesDetailRemoteDatamanagerInputProtocol?
    
    func startGettingMessages(forChat chatId: Int) {
        
        totalCount = 0
        startNumber = 0
        
        remoteDatamanager?.requestUserMessages(withChatId: chatId)
    }
    
    func startMessageSending(withRoom room: Int?,
                             withText text: String,
                             attachment: LocalAttachment?) {
        
        guard let roomNumber = room else {
            return
        }
        
        initSocket(withRoom: roomNumber)
        
        
        //check attachment
        if let attachmentType = attachment?.type,
            let attachmentImage = attachment?.image {
            
            //check type
            switch attachmentType {
            case .image:
                //send image with text
                sendMessageWithImage(withText: text,
                                     andImage: attachmentImage)
                
            case .video:
                //send video with text
                sendMessageWithVideo(withText: text,
                                     video: attachment?.videoURL,
                                     thumbnail: attachmentImage)
            }
            
        } else {
            //send only text
            sendTextMessage(withText: text)
        }
        
        
    }
    
    func startLoadMoreMessages(forChat chatId: Int) {
        
        guard currentPage != nil else {
            presenter?.appendMessagesRecieved(messages: [Message]())
            return
        }
        
        let main = Int(totalCount/20) + 1// current
        startNumber = totalCount % 20
        
        
        remoteDatamanager?.requestMoreUserMessages(withChatId: chatId, page: main)
        
    }
    
    func startReportUser(withText text: String, andUserId userId: Int) {
        remoteDatamanager?.requestReportUser(forUser: userId, reason: text)
    }
    
    func startBlockUser(userId: Int) {
        remoteDatamanager?.requestBlockUser(forUser: userId)
    }
    
    //MARK: - Helpers
    fileprivate func sendMessageWithImage(withText text: String,
                                          andImage image: UIImage) {
        
        let awsService = AWSS3Service()
        awsService.uploadPhoto(images: [image], completionHandler: { (links) in
            
            if let image = links.first {
                let dataDict = APIParser().prepareImageMessageToSend(textMessage: text, imageLink: image)
                SocketManager.shared.sendMessageSocket(messageText: dataDict)
            } else {
                self.sendTextMessage(withText: text)
            }
            
            
        })
        
    }
    
    fileprivate func sendMessageWithVideo(withText text: String,
                                          video videoUrl: URL?,
                                          thumbnail image: UIImage) {
        
        let awsService = AWSS3Service()
        
        guard let attachmentVideo = videoUrl else {
            sendTextMessage(withText: text)
            return
        }
        
        awsService.uploadVideo(videoPath: attachmentVideo,
                               videoThumbnail: image,
                               completionHandler: { (link, thumbImage) in
                                if let videoLink = link,
                                    let thumbImageLink = thumbImage {
                                    let dataDict = APIParser().prepareVideoMessageToSend(textMessage: text, videoLink: videoLink, thumbnailImageLink: thumbImageLink)
                                    SocketManager.shared.sendMessageSocket(messageText: dataDict)
                                    
                                } else {
                                    self.sendTextMessage(withText: text)
                                }
        })
        
    }
    
    fileprivate func sendTextMessage(withText text: String) {
        let dataDict = APIParser().prepareTextMessageToSend(textMessage: text)
        SocketManager.shared.sendMessageSocket(messageText: dataDict)
    }
    
    fileprivate func newIncomeMessage(message: Any) {
        
        let newMessage = APIParser().parseNewIncomeMessage(message: message)
        
        if newMessage != nil {
            self.totalCount += 1
            self.presenter?.newMessageFromSocket(message: newMessage!)
        }
        
    }
    
}


//MARK: - MessageSocketDelegate
extension MessagesDetailInteractor: MessageSocketDelegate {
    func newMessage(message: Any) {
        newIncomeMessage(message: message)
    }
}

//MARK: - MessagesDetailRemoteDatamanagerOutputProtocol
extension MessagesDetailInteractor: MessagesDetailRemoteDatamanagerOutputProtocol {
    func messagesRecieved(messages: [Message],
                          currentPage: Int?,
                          nextPage: Int?,
                          previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        totalCount += messages.count
        
        presenter?.didMessagesRecived(messages: messages)
    }
    
    func appendMessagesRecieved(messages: [Message],
                                currentPage: Int?,
                                nextPage: Int?,
                                previousPage: Int?) {
        if currentPage != nil {
            self.currentPage = currentPage
        }
        
        if nextPage != nil {
            self.nextPage = nextPage
        }
        
        if previousPage != nil {
            self.previousPage = previousPage
        }
        
//        totalCount += messages.count
        
        let totalElements = messages.count - 1
        if totalElements >= startNumber {
            let newEmelements = messages[startNumber...totalElements]
            let newElemArray:[Message] = Array(newEmelements)
            
            totalCount += newElemArray.count
            
            presenter?.appendMessagesRecieved(messages: newElemArray)
        } else {
            presenter?.allMessagesLoaded()
        }
    }
    
    
    func errorWhileRecievingMessages(text: String) {
        presenter?.messagesRecieveError(errorMessage: text)
    }
    
    func userBlocked() {
        presenter?.userBlocked()
    }
    
    func userReported() {
        presenter?.userReported()
    }
    
    func errorWhileBanUser(method: APIMethod, error: Error) {
        presenter?.errorWhileBanUser(method: method, error: error)
    }
    
}












