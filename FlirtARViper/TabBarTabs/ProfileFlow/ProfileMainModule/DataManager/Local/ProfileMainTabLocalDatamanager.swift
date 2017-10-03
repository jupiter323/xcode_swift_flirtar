//
//  ProfileMainTabLocalDatamanager.swift
//  FlirtARViper
//
//  Created by  on 24.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import CoreData

class ProfileMainTabLocalDatamanager: ProfileMainTabLocalDatamanagerInputProtocol {
    
    func saveUserMapStatus(userId: Int , status: Bool) throws {
        try CoreDataManager.shared.saveUserMapStatus(userId: userId, status: status)

    }
    
    
    func savePhotos(photos: [Photo], forUser userId: Int) throws {
        try CoreDataManager.shared.savePhotos(photos: photos, forUser: userId)
    }
    
}
