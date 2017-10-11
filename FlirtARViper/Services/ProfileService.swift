//
//  ProfileService.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Alamofire
import CoreLocation

class ProfileService {
    //editable user NOT saved on server
    static var currentUser: User? = User()
    //saved on SERVER user
    static var savedUser:User? = User()
    
    //auth token
    static var token: String? {
        
        willSet {
            if let newValue = newValue {
                SessionManager.default.adapter = TokenAdapter(accessToken: newValue)
            } else {
                SessionManager.default.adapter = nil
            }
        }
        
    }
    
    //user custom geolocation
    static var userLocation: CLLocation?
    
    //notifications token
    static var fcmToken: String?
    
    //user photos
    static var localPhotos = [UIImage]()
    static var recievedPhotos = [Photo]()
    
    //clear user when logout
    static func clearProfileService() {
        
        SocketManager.shared.closeDialogSocket()
        SocketManager.shared.closeMessageSocket()
        
        self.currentUser = User()
        self.savedUser = User()
        self.token = nil
        self.localPhotos.removeAll()
        self.recievedPhotos.removeAll()
        
        
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        let rootViewController = window?.rootViewController as? TabBarViewProtocol
        
        guard let tabBarController = rootViewController else {
            return
        }
        
        tabBarController.presenter?.dismissMe()
        
        
        
    }
    
    //try to restore user from localdatabase
    static func isUserLoggedIn() -> Bool {
        do {
            
            let userTuple = try CoreDataManager.shared.getSavedUser()
            guard let userInfo = userTuple else {
                return false
            }
            
            ProfileService.savedUser = userInfo.user
            ProfileService.currentUser = userInfo.user
            ProfileService.token = userInfo.token
            ProfileService.recievedPhotos = userInfo.photos
            
            return true
            
        } catch {
            return false
        }
    }
    
    
}
