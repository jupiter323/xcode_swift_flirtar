//
//  CoreDataManager.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    func clearSavedUser() throws {
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
            
            if user.instagramConnected != nil {
                dbUser.instagramConnect = user.instagramConnected!
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
    
    func saveUser(user: User, token: String) throws {
        
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        
        if let newUser = NSEntityDescription.entity(forEntityName: "CDSavedUser", in: managedOC),
            let newToken = NSEntityDescription.entity(forEntityName: "CDToken", in: managedOC) {
            
            let dbUser = CDSavedUser(entity: newUser, insertInto: managedOC)
            let dbToken = CDToken(entity: newToken, insertInto: managedOC)
            
            
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
            
            if user.instagramConnected != nil {
                dbUser.instagramConnect = user.instagramConnected!
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
    
    func updateProfile(withProfile profile: User, userId: Int) throws {
        
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<CDSavedUser> = NSFetchRequest(entityName: String(describing: CDSavedUser.self))
        request.predicate = NSPredicate(format: "id == %d", argumentArray: [userId])
        
        
        let fetchedUser = try managedOC.fetch(request)
        if fetchedUser.count != 0 {
            
            if profile.birthday != nil {
                fetchedUser.first!.birthday = profile.birthday!
            }
            
            if profile.firstName != nil {
                fetchedUser.first!.firstname = profile.firstName!
            }
            
            if profile.gender != nil {
                fetchedUser.first!.gender = Int16((profile.gender)!.rawValue)
            }
            
            if profile.genderPreferences != nil {
                fetchedUser.first!.genderPreferences = Int16((profile.genderPreferences)!.rawValue)
            }
            
            if profile.userID != nil {
                fetchedUser.first!.id = Int16(profile.userID!)
            }
            
            if profile.interests != nil {
                fetchedUser.first!.interests = profile.interests!
            }
            
            if profile.isFacebook != nil {
                fetchedUser.first!.isFacebook = profile.isFacebook!
            }
            
            if profile.instagramConnected != nil {
                fetchedUser.first!.instagramConnect = profile.instagramConnected!
            }
            
            if profile.maxAge != nil {
                fetchedUser.first!.maxAge = Int16(profile.maxAge!)
            }
            
            if profile.minAge != nil {
                fetchedUser.first!.minAge = Int16(profile.minAge!)
            }
            
            if profile.shortIntroduction != nil {
                fetchedUser.first!.shortIntroduction = profile.shortIntroduction!
            }
            
            if profile.showOnMap != nil {
                fetchedUser.first!.showOnMap = profile.showOnMap!
            }
            
            try managedOC.save()
            
            
        }
        
    }
    
    
    func savePhotos(photos: [Photo], forUser userId: Int) throws {
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<CDSavedUser> = NSFetchRequest(entityName: String(describing: CDSavedUser.self))
        request.predicate = NSPredicate(format: "id == %d", argumentArray: [userId])
        
        
        let fetchedUser = try managedOC.fetch(request)
        if fetchedUser.count != 0 {
            
            
            if let newPhoto = NSEntityDescription.entity(forEntityName: "CDPhoto", in: managedOC) {
                
                for i in 0..<photos.count {
                    let dbPhoto = CDPhoto(entity: newPhoto, insertInto: managedOC)
                    if let photoUrl = photos[i].url,
                        let photoId = photos[i].photoID,
                        let isPrimary = photos[i].isPrimary {
                        dbPhoto.photoUrl = photoUrl
                        dbPhoto.orderNumber = Int16(i)
                        dbPhoto.photoId = Int16(photoId)
                        dbPhoto.isPrimary = isPrimary
                        fetchedUser.first!.userPhotos.insert(dbPhoto)
                    }
                }
                
                try managedOC.save()
                
            }
            
        }
    }
    
    func saveUserMapStatus(userId: Int , status: Bool) throws {
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<CDSavedUser> = NSFetchRequest(entityName: String(describing: CDSavedUser.self))
        request.predicate = NSPredicate(format: "id == %d", argumentArray: [userId])
        
        
        let fetchedUser = try managedOC.fetch(request)
        if fetchedUser.count != 0 {
            
            fetchedUser.first!.showOnMap = status
            try managedOC.save()
            
            
        }
    }
    
    func saveUserFBStatus(userId: Int , status: Bool) throws {
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<CDSavedUser> = NSFetchRequest(entityName: String(describing: CDSavedUser.self))
        request.predicate = NSPredicate(format: "id == %d", argumentArray: [userId])
        
        
        let fetchedUser = try managedOC.fetch(request)
        if fetchedUser.count != 0 {
            fetchedUser.first!.isFacebook = status
            try managedOC.save()
        }
    }
    
    func saveUserInstagramStatus(userId: Int , status: Bool) throws {
        guard let managedOC = CoreDataEngine.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<CDSavedUser> = NSFetchRequest(entityName: String(describing: CDSavedUser.self))
        request.predicate = NSPredicate(format: "id == %d", argumentArray: [userId])
        
        
        let fetchedUser = try managedOC.fetch(request)
        if fetchedUser.count != 0 {
            fetchedUser.first!.instagramConnect = status
            try managedOC.save()
        }
    }
    
    
    func getSavedUser() throws -> (user: User, token: String, photos: [Photo])? {
        
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
            user.instagramConnected = userCoreData?.instagramConnect
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
