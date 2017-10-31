//
//  Message.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import ObjectMapper

enum MessageFileType: String {
    case image = "image"
    case video = "video"
    
    static func type(by description: String) -> MessageFileType? {
        if description == MessageFileType.image.rawValue {
            return .image
        } else if description == MessageFileType.video.rawValue {
            return .video
        }
        
        return nil
    }
}

struct LocalAttachment {
    var type: MessageFileType?
    var image: UIImage?
    var videoURL: URL?
}

struct Message {
    var id: Int?
    var messageText: String?
    var fileType: MessageFileType?
    var fileUrl: String?
    var thumbnailImageUrl: String?
    var created: Date?
    var isRead: Bool?
    var sender: ShortUser?
    
}

extension Message: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map[ServerMessageJSONKeys.id.rawValue]
        messageText <- map[ServerMessageJSONKeys.message.rawValue]
        
        
        var fileTypeIncome: String?
        fileTypeIncome <- map[ServerMessageJSONKeys.fileType.rawValue]
        if let fileTypeIncome = fileTypeIncome {
            fileType = MessageFileType.type(by: fileTypeIncome)
        }
        
        fileUrl <- map[ServerMessageJSONKeys.fileUrl.rawValue]
        thumbnailImageUrl <- map[ServerMessageJSONKeys.thumnailImage.rawValue]
        
        var date: String?
        date <- map[ServerMessageJSONKeys.created.rawValue]
        if let date = date {
            created = DateFormatter.markerModelDateFormatter.date(from: date)
        }
        
        isRead <- map[ServerMessageJSONKeys.isRead.rawValue]
        
        
    }
}














