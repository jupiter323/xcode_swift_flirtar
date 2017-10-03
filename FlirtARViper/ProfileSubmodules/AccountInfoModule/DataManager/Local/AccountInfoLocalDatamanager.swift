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
}
