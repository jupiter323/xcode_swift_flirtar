//
//  SocketManager.swift
//  FlirtARViper
//
//  Created by on 25.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftWebSocket

protocol MessageSocketDelegate: class {
    func newMessage(message: Any)
}

protocol DialogSocketDelegate: class {
    func newMessage(message: Any)
}

class SocketManager {
    
    //MARK: - Public
    static var shared = SocketManager()
    weak var messageDelegate: MessageSocketDelegate?
    weak var dialogDelegate: DialogSocketDelegate?
    
    //MARK: Configuration
    func configureDialogSocket() {
        if dialogSocket == nil,
            let token = ProfileService.token {
            dialogSocket = WebSocket("ws://52.204.177.82:8888/stream/\(token)/")
            
            listenDialogSocket()
        }
    }
    
    func configureMessageSocket(withRoom roomId: Int) {
        if messageSocket == nil,
            let token = ProfileService.token {
            messageSocket = WebSocket("ws://52.204.177.82:8888/chat/\(roomId)/\(token)/")
            
            listenMessageSocket()
        }
    }
    
    //MARK: - Send message
    func sendMessageSocket(messageText text: String) {
        messageSocket?.send(text: text)
    }
    
    //MARK: - Close
    func closeDialogSocket() {
        dialogSocketReloadTimer.invalidate()
        dialogSocket?.close()
        dialogSocket = nil
    }
    
    func closeMessageSocket() {
        messageSocketReloadTimer.invalidate()
        messageSocket?.close()
        messageSocket = nil
    }
    
    
    
    //MARK: - Private
    //MARK: Message socket implementation
    private func listenMessageSocket() {
        
        messageSocket?.event.open = {
            print("MessageSocket openned")
            self.messageSocketReloadTimer.invalidate()
        }
        
        messageSocket?.event.error = { error in
            print("MessageSocket error: \(error.localizedDescription)")
        }
        
        messageSocket?.event.close = { code, reason, clean in
            print("MessageSocket closed")
            
            self.messageSocketReloadTimer = Timer
                .scheduledTimer(timeInterval: 5.0,
                                target: self,
                                selector: #selector(self.reloadMessageSocket),
                                userInfo: nil,
                                repeats: true)
            
        }
        
        messageSocket?.event.message = { message in
            self.messageDelegate?.newMessage(message: message)
        }
        
    }
    
    private func listenDialogSocket() {
        
        dialogSocket?.event.open = {
            print("DialogSocket openned")
            self.dialogSocketReloadTimer.invalidate()
        }
        
        dialogSocket?.event.error = { error in
            print("DialogSocket error: \(error.localizedDescription)")
        }
        
        dialogSocket?.event.close = { code, reason, clean in
            print("DialogSocket closed")
            
            self.dialogSocketReloadTimer = Timer
                .scheduledTimer(timeInterval: 5.0,
                                target: self,
                                selector: #selector(self.reloadDialogSocket),
                                userInfo: nil,
                                repeats: true)
            
        }
        
        dialogSocket?.event.message = { message in
            self.dialogDelegate?.newMessage(message: message)
        }
        
    }
    
    
    
    //MARK: - Variables
    fileprivate var dialogSocket: WebSocket?
    fileprivate var messageSocket: WebSocket?
    
    fileprivate var messageSocketReloadTimer = Timer()
    fileprivate var dialogSocketReloadTimer = Timer()
    
    //MARK: - Helpers
    @objc private func reloadMessageSocket() {
        messageSocket?.open()
    }
    
    @objc private func reloadDialogSocket() {
        dialogSocket?.open()
    }
    
    
    
}
