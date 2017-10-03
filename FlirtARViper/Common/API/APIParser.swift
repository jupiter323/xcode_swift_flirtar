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
            }
            
            if location != nil && user != nil {
                let marker = Marker(user: user, location: location)
                markers.append(marker)
            }
            
        }
        
        return markers
    }
    
    func parseBlockedUsers(js: JSON) -> [MarkerUser] {
        var users = [MarkerUser]()
        
        if let jsArray = js["results"].array {
            for eachUser in jsArray {
                if eachUser.dictionaryObject != nil {
                    
                    let user = MarkerUser(JSON: eachUser.dictionaryObject!)
                    
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
                    let dialogUser = MarkerUser(JSON: user)
                    if let message = eachDialog[ServerMessageJSONKeys.message.rawValue].dictionaryObject {
                        let dialogMessage = Message(JSON: message)
                        dialog?.message = dialogMessage
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
    
    
    func parseMessages(js: JSON) -> [Message] {
        
        var messages = [Message]()
        
        if let jsArray = js["results"].array {
            for eachMessage in jsArray {
                if let messageDictionary = eachMessage.dictionaryObject,
                    let senderDictionary = eachMessage["sender"].dictionaryObject {
                    var message = Message(JSON: messageDictionary)
                    let sender = MarkerUser(JSON: senderDictionary)
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
    
    
    
}
