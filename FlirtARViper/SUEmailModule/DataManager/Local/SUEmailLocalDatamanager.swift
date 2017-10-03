//
//  SUEmailLocalDatamanager.swift
//  FlirtARViper
//
//  Created by on 14.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import CoreData

class SUEmailLocalDatamanager: SUEmailLocalDatamanagerInputProtocol {
    func saveUser(user: User, token: String, photos: [Photo]) throws {
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        
        if let newUser = NSEntityDescription.entity(forEntityName: "CDSavedUser", in: managedOC),
            let newToken = NSEntityDescription.entity(forEntityName: "CDToken", in: managedOC),
            let newPhoto = NSEntityDescription.entity(forEntityName: "CDPhoto", in: managedOC) {
            
            let dbUser = CDSavedUser(entity: newUser, insertInto: managedOC)
            let dbToken = CDToken(entity: newToken, insertInto: managedOC)
            
            for i in 0..<photos.count {
                let dbPhoto = CDPhoto(entity: newPhoto, insertInto: managedOC)
                if let photoUrl = photos[i].url,
                    let photoId = photos[i].photoID,
                    let isPrimary = photos[i].isPrimary {
                    dbPhoto.photoUrl = photoUrl
                    dbPhoto.orderNumber = Int16(i)
                    dbPhoto.photoId = Int16(photoId)
                    dbPhoto.isPrimary = isPrimary
                    dbUser.userPhotos.insert(dbPhoto)
                }
            }
            
            
            
            
            dbToken.tokenValue = token
            
            
            if user.birthday != nil {
                dbUser.birthday = user.birthday!
            }
            if user.email != nil {
                dbUser.email = user.email!
            }
            
            if user.firstName != nil {
                dbUser.firstname = user.firstName!
            }
            
            if user.gender != nil {
                dbUser.gender = Int16((user.gender)!.rawValue)
            }
            
            if user.genderPreferences != nil {
                dbUser.genderPreferences = Int16((user.genderPreferences)!.rawValue)
            }
            
            if user.userID != nil {
                dbUser.id = Int16(user.userID!)
            }
            
            if user.interests != nil {
                dbUser.interests = user.interests!
            }
            
            if user.isFacebook != nil {
                dbUser.isFacebook = user.isFacebook!
            }
            
            if user.maxAge != nil {
                dbUser.maxAge = Int16(user.maxAge!)
            }
            
            if user.minAge != nil {
                dbUser.minAge = Int16(user.minAge!)
            }
            
            if user.password != nil {
                dbUser.password = user.password!
            }
            
            if user.shortIntroduction != nil {
                dbUser.shortIntroduction = user.shortIntroduction!
            }
            
            if user.showOnMap != nil {
                dbUser.showOnMap = user.showOnMap!
            }
            
            dbUser.userToken = dbToken
            
            try managedOC.save()
            
        }
    }
    
    func clearDB() throws {
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let deleteUserFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDSavedUser")
        let deleteUserRequest = NSBatchDeleteRequest(fetchRequest: deleteUserFetch)
        
        let deleteTokenFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDToken")
        let deleteTokenRequest = NSBatchDeleteRequest(fetchRequest: deleteTokenFetch)
        
        let deletePhotosFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPhoto")
        let deletePhotosRequest = NSBatchDeleteRequest(fetchRequest: deletePhotosFetch)
        
        try managedOC.execute(deleteUserRequest)
        try managedOC.execute(deleteTokenRequest)
        try managedOC.execute(deletePhotosRequest)
        try managedOC.save()
    }
}
