//
//  APIParser.swift
//  FlirtARViper
//
//  Created by on 13.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIParser {
    
    //MARK: - Parse income JSON
    func parseMarkers(js: [JSON]) -> [Marker] {
        var markers = [Marker]()
        
        for eachJSMarker in js {
            
            var location: Location?
            if eachJSMarker["location"].dictionaryObject != nil {
                location = Location(JSON: eachJSMarker["location"].dictionaryObject!)
            }
            
            var user: MarkerUser?
            if eachJSMarker.dictionaryObject != nil {
                user = MarkerUser(JSON: eachJSMarker.dictionaryObject!)
                
                if eachJSMarker["photo"].dictionaryObject != nil {
                    let photo = Photo(JSON: eachJSMarker["photo"].dictionaryObject!)
                    user?.photo = photo
                }
                
            }
            
            if location != nil && user != nil {
                let marker = Marker(user: user, location: location)
                markers.append(marker)
            }
            
        }
        
        return markers
    }
    
    func parseBlockedUsers(js: JSON) -> [ShortUser] {
        var users = [ShortUser]()
        
        if let jsArray = js["results"].array {
            for eachUser in jsArray {
                if eachUser.dictionaryObject != nil {
                    
                    var user = ShortUser(JSON: eachUser.dictionaryObject!)
                    
                    if let photoDictionary = eachUser["photo"].dictionaryObject {
                        let photo = Photo(JSON: photoDictionary)
                        if photo != nil {
                            user?.photos.append(photo!)
                        }
                    }
                    
                    
                    if user != nil {
                        users.append(user!)
                    }
                }
            }
        }
        
        return users
    }
    
    func parseDialogs(js: JSON) -> [Dialog] {
        
        var dialogs = [Dialog]()
        
        if let jsArray = js["results"].array {
            for eachDialog in jsArray {
                if let dialogDictionary = eachDialog.dictionaryObject,
                    let user = eachDialog["user"].dictionaryObject {
                    var dialog = Dialog(JSON: dialogDictionary)
                    var dialogUser = ShortUser(JSON: user)
                    if let message = eachDialog[ServerMessageJSONKeys.message.rawValue].dictionaryObject {
                        let dialogMessage = Message(JSON: message)
                        dialog?.message = dialogMessage
                    }
                    
                    if let photo = eachDialog["user"]["photo"].dictionaryObject {
                        let dialogPhoto = Photo(JSON: photo)
                        if dialogPhoto != nil {
                            dialogUser?.photos.append(dialogPhoto!)
                        }
                    }
                    
                    dialog?.user = dialogUser
                    if dialog != nil {
                        dialogs.append(dialog!)
                    }
                }
            }
        }
        
        return dialogs
    }
    
    func parseShortUser(js: JSON) -> ShortUser? {
        if js.dictionaryObject != nil {
            var profile = ShortUser(JSON: js.dictionaryObject!)
            let photos = self.parsePhotos(js: js["photos"])
            
            profile?.photos = photos
            
            return profile
        } else {
            return nil
        }
    }
    
    func parseNewIncomeMessage(message: Any) -> Message? {
        
        print(message)
        
        guard let messageString = message as? String  else {
            return nil
        }
        
        let js = JSON(parseJSON: messageString) //JSON from string
        
        if let messageDictionary = js.dictionaryObject,
            let senderDictionary = js["sender"].dictionaryObject {
            var message = Message(JSON: messageDictionary)
            var sender = ShortUser(JSON: senderDictionary)
            
            if let photoDictionary = js["sender"]["photo"].dictionaryObject {
                let photo = Photo(JSON: photoDictionary)
                if photo != nil {
                    sender?.photos.append(photo!)
                }
            }
            
            message?.sender = sender
            
            return message
        }
        
        return nil
        
    }
    
    
    func parseMessages(js: JSON) -> [Message] {
        
        var messages = [Message]()
        
        if let jsArray = js["results"].array {
            for eachMessage in jsArray {
                if let messageDictionary = eachMessage.dictionaryObject,
                    let senderDictionary = eachMessage["sender"].dictionaryObject {
                    var message = Message(JSON: messageDictionary)
                    var sender = ShortUser(JSON: senderDictionary)
                    
                    if let photo = eachMessage["sender"]["photo"].dictionaryObject {
                        let messagePhoto = Photo(JSON: photo)
                        if messagePhoto != nil {
                            sender?.photos.append(messagePhoto!)
                        }
                    }
                    
                    message?.sender = sender
                    if message != nil {
                        messages.append(message!)
                    }
                }
            }
        }
        
        return messages
    }
    
    
    func parseShortUsers(js: JSON) -> [ShortUser] {
        
        var users = [ShortUser]()
        
        if let jsArray = js.array {
            for eachUser in jsArray {
                if let userDictionary = eachUser.dictionaryObject {
                    
                    var user = ShortUser(JSON: userDictionary)
                    
                    
                    let photos = self.parsePhotos(js: eachUser["photos"])
                    user?.photos = photos
                    
                    if user != nil {
                        users.append(user!)
                    }
                }
            }
        }
        
        return users
        
        
        
        
    }
    
    func parseUser(js: JSON) -> (user: User?, photos: [Photo], token: String?) {
        
        let photos = self.parsePhotos(js: js["user"]["photos"])
        
        
        if js["user"].dictionaryObject != nil {
            let user = User(JSON: js["user"].dictionaryObject!)
            let token = js["token"].stringValue
            
            return (user: user, photos: photos, token: token)
        }
        
        return (user: nil, photos: photos, token: nil)
    }
    
    

    func parsePhotos(js: JSON) -> [Photo] {
        
        var photos = [Photo]()
        
        let jsArray = js.array
        
        guard let jsPhotoArray = jsArray else {
            return photos
        }
        
        for eachPhoto in jsPhotoArray {
            if let photoDictionary = eachPhoto.dictionaryObject {
                let photo = Photo(JSON: photoDictionary)
                if photo != nil {
                    photos.append(photo!)
                }
            }
        }
        
        return photos

    }
    
    
    func parseSaveProfileErrors(js: JSON) -> [Error] {
        
        var errorsList = [Error]()
        
        if js["email"] != JSON.null {
            errorsList.append(FillProfileError.emailNotFilled)
        }
        
        if js["password"] != JSON.null {
            errorsList.append(FillProfileError.passwordNotFilled)
        }
        
        if js["interests"] != JSON.null {
            errorsList.append(FillProfileError.interestsNotFilled)
        }
        
        if js["short_introduction"] != JSON.null {
            errorsList.append(FillProfileError.introductionNotFilled)
        }
        
        return errorsList
        
    }
    
    func parseStringsArray(js: JSON) -> [String] {
        var strings = [String]()
        
        guard let jsArray = js.array else {
            return strings
        }
        
        for eachString in jsArray {
            strings.append(eachString.stringValue)
        }
        
        return strings
    }
    
    func parseInstagramPhotos(js: JSON) -> [Photo] {
        
        var photoLinks = [Photo]()
        
        guard let jsData = js.array else {
            return photoLinks
        }
        
        for eachPhoto in jsData {
            
            if eachPhoto.dictionaryObject != nil {
                let photo = Photo(JSON: eachPhoto.dictionaryObject!)
                if photo != nil {
                    photoLinks.append(photo!)
                }
            }
            
//            let photoLink = eachPhoto["url"].stringValue
//            photoLinks.append(photoLink)
        }
        
        return photoLinks
        
    }
    
    //MARK: - Outcome messages
    func prepareImageMessageToSend(textMessage: String,
                                   imageLink: String) -> String {
        let clearedText = BadWordHelper.shared.cleanUp(textMessage)
        return "{\"text\":\"\(clearedText)\",\"file_url\":\"\(imageLink)\",\"file_type\":\"image\"}"
    }
    
    func prepareVideoMessageToSend(textMessage: String,
                                   videoLink: String,
                                   thumbnailImageLink: String) -> String {
        let clearedText = BadWordHelper.shared.cleanUp(textMessage)
        return "{\"text\":\"\(clearedText)\",\"file_url\":\"\(videoLink)\",\"file_type\":\"video\",\"thumbnail\":\"\(thumbnailImageLink)\"}"
    }
    
    func prepareTextMessageToSend(textMessage: String) -> String {
        let clearedText = BadWordHelper.shared.cleanUp(textMessage)
        return "{\"text\":\"\(clearedText)\"}"
    }
    
    //MARK: - Serialize outcome Dictiomary
    func configureUserDictionary(user: User) -> [String: Any] {
        var userParams = [String: Any]()
        
        if user.email != nil {
            userParams[ServerUserJSONKeys.email.rawValue] = user.email!
        }
        if user.password != nil {
            userParams[ServerUserJSONKeys.password.rawValue] = user.password!
        }
        if user.firstName != nil {
            userParams[ServerUserJSONKeys.firstName.rawValue] = user.firstName!
        }
        if user.birthday != nil {
            let birthday = DateFormatter.apiModelDateFormatter.string(from: user.birthday!)
            userParams[ServerUserJSONKeys.birthday.rawValue] = birthday
        }
        if user.gender?.description != nil {
            userParams[ServerUserJSONKeys.gender.rawValue] = user.gender?.description
        }
        if user.shortIntroduction != nil {
            userParams[ServerUserJSONKeys.shortIntroduction.rawValue] = user.shortIntroduction!
        } else {
            userParams[ServerUserJSONKeys.shortIntroduction.rawValue] = ""
        }
        if user.interests != nil {
            userParams[ServerUserJSONKeys.interests.rawValue] = user.interests!
        } else {
            userParams[ServerUserJSONKeys.interests.rawValue] = ""
        }
        if user.genderPreferences?.description != nil {
            userParams[ServerUserJSONKeys.genderPreferences.rawValue] = user.genderPreferences?.description
        }
        if user.minAge != nil {
            userParams[ServerUserJSONKeys.minAge.rawValue] = user.minAge!
        }
        if user.maxAge != nil {
            userParams[ServerUserJSONKeys.maxAge.rawValue] = user.maxAge!
        }
        if user.showOnMap != nil {
            userParams[ServerUserJSONKeys.showOnMap.rawValue] = user.showOnMap!
        }
        
        return userParams
    }
    
    
    //Notifications
    func configureNotificationDictionary(notifications: [(type: CellConfiguration.NotificationType, status: Bool)]) -> [String: Any] {
        var userParams = [String: Any]()
        
        for notification in notifications {
            switch notification.type {
            case .like:
                userParams[ServerNotificationsJSONKeys.like.rawValue] = notification.status
            case .message:
                userParams[ServerNotificationsJSONKeys.message.rawValue] = notification.status
            case .newUserInArea:
                userParams[ServerNotificationsJSONKeys.user.rawValue] = notification.status
            case .all:
                break
            }
        }
        
        return userParams
    }
    
    
    
    //Photos
    func configureCreateUserPhotos(photos: [PhotoTuple]) -> [String: Any] {
        var photosDictionary = [String: [Any]]()
        
        var photosArray = [[ : ]]
        photosArray.removeAll()
        for i in 0..<photos.count {
            
            if photos[i].primary {
                let primaryPhoto = ["url":photos[i].link,
                                    "primary": photos[i].primary] as [String: Any]
                photosArray.append(primaryPhoto)
            } else {
                let photo = ["url": photos[i].link] as [String: Any]
                photosArray.append(photo)
            }
            
        }
        
        photosDictionary["photos"] = photosArray
        
        return photosDictionary
    }
    
    func configureUserPhotoForUpdate(photo: PhotoTuple) -> [String: Any] {
        return ["url":photo.link,
                "primary":photo.primary]
    }
    
    
    
}
