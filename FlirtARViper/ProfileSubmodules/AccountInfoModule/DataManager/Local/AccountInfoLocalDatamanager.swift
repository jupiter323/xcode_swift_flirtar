//
//  AccountInfoLocalDatamanager.swift
//  FlirtARViper
//
//  Created on 24.08.17.
//

import UIKit
import CoreData

class AccountInfoLocalDatamanager: AccountInfoLocalDatamanagerInputProtocol {
    func clearUser() throws {
        try CoreDataManager.shared.clearSavedUser()
    }
    
    func saveInstagramStatus(userId: Int, status: Bool) throws {
        try CoreDataManager.shared.saveUserInstagramStatus(userId: userId, status: status)
    }
    
    func saveFacebookStatus(userId: Int, status: Bool) throws {
        try CoreDataManager.shared.saveUserFBStatus(userId: userId, status: status)
    }
}
