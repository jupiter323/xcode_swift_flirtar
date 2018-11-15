//
//  SUProfileInfoLocalDatamanager.swift
//  FlirtARViper
//
//  Created by on 20.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import CoreData


class SUProfileInfoLocalDatamanager: SUProfileInfoLocalDatamanagerInputProtocol {
    
    func saveUser(user: User, token: String) throws {
        try CoreDataManager.shared.saveUser(user: user, token: token)
    }
    
    func savePhotos(photos: [Photo], forUser userId: Int) throws {
        try CoreDataManager.shared.savePhotos(photos: photos, forUser: userId)
    }
    
    func clearDB() throws {
        try CoreDataManager.shared.clearSavedUser()
    }
}
