//
//  ShortUser.swift
//  FlirtARViper
//
//  Created by  on 14.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import ObjectMapper

struct ShortUser {
    var id: Int?
    var firstName: String?
    var age: String?
    var gender: Gender?
    var interests: String?
    var shortIntroduction: String?
    var isLiked: Bool?
    var photos: [Photo] = [Photo]()
}


extension ShortUser: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map[ServerShortUserJSONKeys.id.rawValue]
        firstName <- map[ServerShortUserJSONKeys.firstName.rawValue]
        age <- map[ServerShortUserJSONKeys.age.rawValue]
        
        var genderString: String?
        genderString <- map[ServerShortUserJSONKeys.gender.rawValue]
        if let genderString = genderString {
            gender = Gender.gender(by: genderString)
        }
        
        shortIntroduction <- map[ServerShortUserJSONKeys.shortIntroduction.rawValue]
        interests <- map[ServerShortUserJSONKeys.interests.rawValue]
        
        isLiked <- map[ServerShortUserJSONKeys.isLiked.rawValue]
    }
}
