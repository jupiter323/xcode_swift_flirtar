//
//  CDSavedUser+CoreDataProperties.swift
//  FlirtARViper
//
//  Created by   on 24.08.17.
//  Copyright © 2017  . All rights reserved.
//

import CoreData

extension CDSavedUser {
    @NSManaged var birthday: Date
    @NSManaged var email: String
    @NSManaged var firstname: String
    @NSManaged var gender: Int16
    @NSManaged var genderPreferences: Int16
    @NSManaged var id: Int16
    @NSManaged var interests: String
    @NSManaged var isFacebook: Bool
    @NSManaged var maxAge: Int16
    @NSManaged var minAge: Int16
    @NSManaged var password: String
    @NSManaged var shortIntroduction: String
    @NSManaged var showOnMap: Bool
    
    //Relations
    @NSManaged var userToken: CDToken
    @NSManaged var userPhotos: Set<CDPhoto>
}
