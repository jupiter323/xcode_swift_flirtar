//
//  Photo.swift
//  FlirtARViper
//
//  Created by  on 09.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import ObjectMapper

struct Photo {
    var photoID: Int?
    var url: String?
    var thumbnailUrl: String?
    var isPrimary: Bool?
}

extension Photo: Mappable {
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        photoID <- map[ServerPhotoJSONKeys.photoId.rawValue]
        url <- map[ServerPhotoJSONKeys.url.rawValue]
        thumbnailUrl <- map[ServerPhotoJSONKeys.thumbnailUrl.rawValue]
        isPrimary <- map[ServerPhotoJSONKeys.primary.rawValue]

        
    }
}
