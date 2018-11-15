//
//  CDToken+CoreDataProperties.swift
//  FlirtARViper
//
//  Created by   on 24.08.17.
//  Copyright © 2017  . All rights reserved.
//

import CoreData

extension CDToken {
    @NSManaged var tokenValue: String
    
    //Relations
    @NSManaged var user: CDSavedUser
}
