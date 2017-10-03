//
//  APIRouter.swift
//  FlirtARViper
//
//  Created on 01.08.17.
//

import Foundation
import Alamofire
import SwiftyJSON

struct API {
    static let apiLink = "http://52.204.177.82/api/"
    static let mapsApi = "AIzaSyCgDLWiOF73WzcKX_F1fShtTSVY7M6Rwg0"
}


enum APIRouter: URLRequestConvertible {
    
    //SignUp/Login Flow
    case checkEmailAvailability(email: String)
    case signIn(email: String, password: String)
    case signInFB(accessToken: String)
    case signOut
    case signUp(user: User)
    case disconnectFB
    case recoverPassword(email: String)
    case sendPinCode(email: String)
    case checkPinCode(email: String, pinCode: String)
    
    //Likes
    case likeUser(userId: Int)
    case unlikeUser(userId: Int)
    case dislikeUser(userId: Int)
    
    //Like/Dislike
    case getMatchUsers(page: Int?)
    
    //Location
    case updateUserLocation(longitude: Double, latitude: Double)
    case getUsersLocations(byDistance: Double)
    
    //Profile
    case getUserProfile()
    case updateUserProfile(user: User)
    case createUserPhotos(photos: [PhotoTuple])
    case getUser(userId: Int)
    case updatePhoto(photoId: Int, newPhoto: PhotoTuple)
    case deleteAccount()
    case blockUser(userId: Int)
    case unblockUser(userId: Int)
    case reportUser(userId: Int, reportString: String)
    case getBlockedUsers(page: Int?)
    
    //Notifications
    case updateNotificationSettings([(type: CellConfiguration.NotificationType, status: Bool)])
    case registerDeviceForNotifications(registrationId: String,
                                        type: String,
                                        deviceId: String,
                                        status: Bool)
    case getNotifications()
    
    //Chat
    case getListMessages(page: Int?)
    case getMessages(chatId: Int, page: Int?)
    case removeChat(chatId: Int)
    
    
    private var method: HTTPMethod {
        switch self {
        case .checkEmailAvailability, .signIn, .signInFB, .signUp, .createUserPhotos, .registerDeviceForNotifications, .recoverPassword, .sendPinCode, .checkPinCode, .reportUser:
            return .post
        case .getUsersLocations, .getUserProfile, .getUser, .getNotifications, .getListMessages, .getMessages, .getMatchUsers, .getBlockedUsers:
            return .get
        case .updateUserLocation, .updatePhoto, .likeUser, .dislikeUser, .blockUser:
            return .put
        case .updateUserProfile, .updateNotificationSettings:
            return .patch
        case .signOut, .disconnectFB, .unlikeUser, .removeChat, .deleteAccount,  .unblockUser:
            return .delete
        }
    }
    
    private var path: String {
        switch self {
        //SignUp/Login Flow
        case .checkEmailAvailability:
            return "accounts/check-email/"
        case .signIn:
            return "accounts/sign-in/"
        case .signOut:
            return "accounts/sign-out/"
        case .signInFB:
            return "accounts/facebook/"
        case .signUp:
            return "accounts/sign-up/"
        case .disconnectFB:
            return "accounts/facebook/disconnect/"
        case .recoverPassword:
            return "accounts/recover-password/"
        case .sendPinCode:
            return "accounts/send-code/"
        case .checkPinCode:
            return "accounts/check-code/"
            
            
        
        //Likes
        case .likeUser(let userId):
            return "accounts/\(userId)/like/"
        case .unlikeUser(let userId):
            return "accounts/\(userId)/like/"
        case .dislikeUser(let userId):
            return "accounts/\(userId)/dislike/"
            
        //Like/Dislike
        case .getMatchUsers:
            return "accounts/matching/"
            
        //Location
        case .updateUserLocation:
            return "accounts/current/location/"
        case .getUsersLocations:
            return "accounts/list/"
            
        //Profile
        case .getUserProfile:
            return "accounts/current/profile/"
        case .updateUserProfile:
            return "accounts/current/profile/"
        case .createUserPhotos:
            return "accounts/current/photo/"
        case .getUser(let userId):
            return "accounts/\(userId)/"
        case .updatePhoto(let photoId, _ ):
            return "accounts/current/photo/\(photoId)/"
        case .deleteAccount:
            return "accounts/delete/"
        case .blockUser(let userId), .unblockUser(let userId):
            return "accounts/\(userId)/block/"
        case .reportUser(let userId, _):
            return "accounts/\(userId)/report/"
        case .getBlockedUsers:
            return "accounts/block/"
            
        //Notifications
            
        case .updateNotificationSettings:
            return "notification/settings/"
        case .registerDeviceForNotifications:
            return "register-device/"
        case .getNotifications:
            return "notification/settings/"
            
            
            
        //Chat
        case .getListMessages:
            return "chat/"
        case .getMessages(let chatId, _):
            return "chat/\(chatId)/messages/"
        case .removeChat(let chatId):
            return "chat/\(chatId)/delete/"
        }
        
        
        
        
        
        
        
    }
    
    private var parameters: Parameters? {
        switch self {
        case .checkEmailAvailability(let email):
            return ["email": email]
        case .signIn(let email, let password):
            return ["email": email, "password" : password]
        case .signInFB(let token):
            return ["access_token": token]
        case .recoverPassword(let email):
            return ["email":email]
            
        case .sendPinCode(let email):
            return ["email":email]
            
        case .checkPinCode(let email, let pinCode):
            return ["email":email,
                    "code":pinCode]
            
        case .signUp(let user):
            return configureUserDictionary(user: user)
        case .updateUserLocation(let longitude, let latitude):
            return ["latitude": latitude, "longitude" : longitude]
        case .getUsersLocations(let distance):
            return ["distance": distance]
        case .updateUserProfile(let user):
            return configureUserDictionary(user: user)
        case .getUser(_):
            return ["" : ""]
        case .updateNotificationSettings(let notifications):
            return configureNotificationDictionary(notifications: notifications)
        case .registerDeviceForNotifications(let registerId, let type, let deviceId, let status):
            return ["registration_id":registerId,
                    "type": type,
                    "device_id": deviceId,
                    "active": status]
        case .createUserPhotos(let photos):
            return configureCreateUserPhotos(photos: photos)
        case .updatePhoto(_, let newPhoto):
            return configureUserPhotoForUpdate(photo: newPhoto)
        case .getListMessages(let page):
            if page != nil {
                return ["page":page!]
            } else {
                return nil
            }
        case .getMessages(_, let page):
            if page != nil {
                return ["page":page!]
            } else {
                return nil
            }
            
        case .getMatchUsers(let page):
            if page != nil {
                return ["page":page!]
            } else {
                return nil
            }
            
        case .reportUser(_, let reportString):
            return ["reason": reportString]
            
        case .getBlockedUsers(let page):
            if page != nil {
                return ["page":page!]
            } else {
                return nil
            }
            
        case .signOut, .getUserProfile, .disconnectFB, .likeUser, .unlikeUser, .getNotifications, .removeChat, .dislikeUser, .deleteAccount, .blockUser, .unblockUser:
            return nil
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try API.apiLink.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createUserPhotos:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encodedData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            urlRequest.httpBody = encodedData
        case .updatePhoto:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encodedData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            urlRequest.httpBody = encodedData
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
    
    //MARK: - Helpers
    //Profile & Login & SignUp
    private func configureUserDictionary(user: User) -> [String: Any] {
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
    private func configureNotificationDictionary(notifications: [(type: CellConfiguration.NotificationType, status: Bool)]) -> [String: Any] {
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
    private func configureCreateUserPhotos(photos: [PhotoTuple]) -> [String: Any] {
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
    
    private func configureUserPhotoForUpdate(photo: PhotoTuple) -> [String: Any] {
        return ["url":photo.link,
                "primary":photo.primary]
    }
    
}
