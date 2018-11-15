//
//  SplashLocalDatamanager.swift
//  FlirtARViper
//
//  Created by on 19.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import CoreData

class SplashLocalDatamanager: SplashLocalDatamanagerInputProtocol {
    
    func saveUser(user: User, token: String, photos: [Photo]) throws {
        try CoreDataManager.shared.saveUser(user: user, token: token, photos: photos)
    }
    
    func clearDB() throws {
        try CoreDataManager.shared.clearSavedUser()
    }
}
