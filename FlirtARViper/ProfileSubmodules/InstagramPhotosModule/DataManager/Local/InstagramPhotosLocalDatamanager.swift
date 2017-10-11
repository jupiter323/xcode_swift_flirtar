//
//  InstagramPhotosLocalDatamanager.swift
//  FlirtARViper
//
//  Created by on 07.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import CoreData

class InstagramPhotosLocalDatamanager: InstagramPhotosLocalDatamanagerInputProtocol {
    func saveInstagramStatus(userId: Int, status: Bool) throws {
        try CoreDataManager.shared.saveUserInstagramStatus(userId: userId, status: status)
    }
}
