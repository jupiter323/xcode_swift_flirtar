//
//  CDPhoto+CoreDataProperties.swift
//  FlirtARViper
//
//  Created by   on 24.08.17.
//  Copyright © 2017  . All rights reserved.
//

import CoreData

extension CDPhoto {
    @NSManaged var isPrimary: Bool
    @NSManaged var orderNumber: Int16
    @NSManaged var photoId: Int16
    @NSManaged var photoUrl: String
    
    //Relations
    @NSManaged var user: CDSavedUser
}
