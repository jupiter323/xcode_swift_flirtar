//
//  Dialog.swift
//  FlirtARViper
//
//  Created by   on 16.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import ObjectMapper


struct Dialog {
    var id: Int?
    var user: ShortUser?
    var unreadCount: Int?
    var message: Message?
}


extension Dialog: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map[ServerDialogJSONKeys.id.rawValue]
        unreadCount <- map[ServerDialogJSONKeys.unreadCount.rawValue]
    }
}
