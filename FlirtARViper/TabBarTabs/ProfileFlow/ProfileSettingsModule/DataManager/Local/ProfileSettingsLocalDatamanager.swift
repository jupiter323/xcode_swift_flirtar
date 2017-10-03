//
//  ProfileSettingsLocalDatamanager.swift
//  FlirtARViper
//
//  Created by  on 24.08.17.
//  Copyright © 2017 . All rights reserved.
//

import CoreData

class ProfileSettingsLocalDatamanager: ProfileSettingsLocalDatamanagerInputProtocol {
    func updateProfile(withProfile profile: User, userId: Int) throws {
        try CoreDataManager.shared.updateProfile(withProfile: profile, userId: userId)
    }
    
    func clearUser() throws {
        try CoreDataManager.shared.clearSavedUser()
    }
}
