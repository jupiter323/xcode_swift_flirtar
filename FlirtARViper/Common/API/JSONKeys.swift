//
//  JSONKeys.swift
//  FlirtARViper
//
//  Created by   on 10.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation

enum ServerUserJSONKeys: String {
    case id = "id"
    case email = "email"
    case password = "password"
    case firstName = "first_name"
    case birthday = "birthday"
    case gender = "gender"
    case shortIntroduction = "short_introduction"
    case interests = "interests"
    case genderPreferences = "gender_preferences"
    case minAge = "min_age"
    case maxAge = "max_age"
    case showOnMap = "show_on_map"
    case isFacebook = "is_facebook"
    case photo = "photo"
    case age = "age"
    case instagramConnected = "instagram_connected"
}

enum ServerSignUpJSONKeys: String {
    case codeMatch = "Verification code match."
    case codeSent = "Verification email successfully sent."
    case passwordRecover = "Recover email successfully sent."
}

enum ServerPhotoJSONKeys: String {
    case photoId = "id"
    case url = "url"
    case primary = "primary"
}

enum ServerLocationJSONKeys: String {
    case id = "id"
    case latitude = "latitude"
    case longitude = "longitude"
    case modified = "modified"
}


enum ServerNotificationsJSONKeys: String {
    case like = "is_like"
    case message = "is_message"
    case user = "is_user"
}


enum ServerShortUserJSONKeys: String {
    case id = "id"
    case firstName = "first_name"
    case age = "age"
    case gender = "gender"
    case interests = "interests"
    case shortIntroduction = "short_introduction"
    case isLiked = "is_liked"
    case photos = "photos"
}

enum ServerDialogJSONKeys: String {
    case id = "id"
    case user = "user"
    case unreadCount = "unread_count"
    case message = "message"
}


enum ServerMessageJSONKeys: String {
    case id = "id"
    case message = "message"
    case fileType = "file_type"
    case created = "created"
    case isRead = "is_read"
    case fileUrl = "file_url"
    case sender = "sender"
    case thumnailImage = "thumbnail"
}





