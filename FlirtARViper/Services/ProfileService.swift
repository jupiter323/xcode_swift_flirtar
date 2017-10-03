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
            
            let userTuple = try self.getSavedUser()
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
    
    
    private static func getSavedUser() throws -> (user: User, token: String, photos: [Photo])? {
        
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<CDSavedUser> = NSFetchRequest(entityName: String(describing: CDSavedUser.self))
        
        let userCoreData = try managedOC.fetch(request).first
        
        if userCoreData != nil {
            var user = User()
            let token = userCoreData!.userToken.tokenValue
            
            user.birthday = userCoreData?.birthday
            user.email = userCoreData?.email
            user.firstName = userCoreData?.firstname
            
            let gender = Gender(rawValue: Int(userCoreData!.gender))
            user.gender = gender
            
            
            let genderPreferences = GenderPreference(rawValue: Int(userCoreData!.genderPreferences))
            user.genderPreferences = genderPreferences
            
            user.interests = userCoreData?.interests
            user.isFacebook = userCoreData?.isFacebook
            user.maxAge = Int(userCoreData!.maxAge)
            user.minAge = Int(userCoreData!.minAge)
            user.password = userCoreData?.password
            user.shortIntroduction = userCoreData?.shortIntroduction
            user.showOnMap = userCoreData?.showOnMap
            user.userID = Int(userCoreData!.id)
            
            var photos = [Photo](repeating: Photo(), count: userCoreData!.userPhotos.count)
            for dbPhoto in userCoreData!.userPhotos {
                var photo = Photo()
                photo.url = dbPhoto.photoUrl
                photo.isPrimary = dbPhoto.isPrimary
                photo.photoID = Int(dbPhoto.photoId)
                
                let orderNumber = Int(dbPhoto.orderNumber)
                
                if orderNumber < photos.count {
                    photos[orderNumber] = photo
                }
            }
            
            return (user, token, photos)
            
            
        } else {
            return nil
        }        
        
        
    }
    
}
