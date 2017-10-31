//
//  APIRouter.swift
//  FlirtARViper
//
//  Created on 01.08.17.
//

import Foundation
import Alamofire
import SwiftyJSON


//base simple router
protocol SimpleRouter {
    var path: String {get}
}

//request router
protocol RequestRouter: SimpleRouter {
    var method: HTTPMethod {get}
    var parameters: Parameters? {get}
}

//websocket router
protocol WebSocketRouter: SimpleRouter {
    func asStringUrl () -> String
}

struct API {
    static let apiLink = "http://52.204.177.82/api/"
    //"http://52.204.177.82/api/"
    static let socketLink = "ws://52.204.177.82:8888"
    //"ws://52.204.177.82:8888/
    static let mapsApi = "AIzaSyCgDLWiOF73WzcKX_F1fShtTSVY7M6Rwg0"
}

//router for Socket requests
enum SocketRouter: WebSocketRouter {
    
    case dialogs(token: String)
    case messages(roomId: Int, token: String)
    
    var path: String {
        switch self {
        case .dialogs(let token):
            return "/stream/\(token)/"
        case .messages(let roomId, let token):
            return "/chat/\(roomId)/\(token)/"
        }
    }
    
    func asStringUrl() -> String {
        return API.socketLink + path
    }
    
}

//router for API requests
enum APIRouter: URLRequestConvertible, RequestRouter {
    
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
    case getLikesList(page: Int?)
    
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
    case getInterestsBase()
    case getBadWordsContent()
    
    case getInstagramPhotos(userId: Int)
    case saveInstagramToken(token: String)
    case disconnectInstagram()
    
    //Feedback
    case sendFeedback(rate: Int, comment: String)
    
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
    
    
    var method: HTTPMethod {
        switch self {
        case .checkEmailAvailability, .signIn, .signInFB, .signUp, .createUserPhotos, .registerDeviceForNotifications, .recoverPassword, .sendPinCode, .checkPinCode, .reportUser, .saveInstagramToken, .sendFeedback:
            return .post
        case .getUsersLocations, .getUserProfile, .getUser, .getNotifications, .getListMessages, .getMessages, .getMatchUsers, .getBlockedUsers, .getInterestsBase, .getBadWordsContent, .getInstagramPhotos, .getLikesList:
            return .get
        case .updateUserLocation, .updatePhoto, .likeUser, .dislikeUser, .blockUser:
            return .put
        case .updateUserProfile, .updateNotificationSettings:
            return .patch
        case .signOut, .disconnectFB, .unlikeUser, .removeChat, .deleteAccount,  .unblockUser, .disconnectInstagram:
            return .delete
        }
    }
    
    var path: String {
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
        case .getLikesList:
            return "accounts/like/"
            
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
        case .getInterestsBase:
            return "accounts/interest/"
        case .getBadWordsContent:
            return "accounts/objectionable-content/"
            
        case .getInstagramPhotos(let userId):
            return "accounts/photos/instagram/\(userId)/"
        case .saveInstagramToken:
            return "accounts/instagram/"
        case .disconnectInstagram:
            return "accounts/instagram/disconnect/"
            
        //Feedback
        case .sendFeedback:
            return "support/feedback/"
            
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
    
    var parameters: Parameters? {
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
            return APIParser().configureUserDictionary(user: user)
        case .updateUserLocation(let longitude, let latitude):
            return ["latitude": latitude, "longitude" : longitude]
        case .getUsersLocations(let distance):
            return ["distance": distance]
        case .updateUserProfile(let user):
            return APIParser().configureUserDictionary(user: user)
        case .getUser(_):
            return ["" : ""]
        case .updateNotificationSettings(let notifications):
            return APIParser().configureNotificationDictionary(notifications: notifications)
        case .registerDeviceForNotifications(let registerId, let type, let deviceId, let status):
            return ["registration_id":registerId,
                    "type": type,
                    "device_id": deviceId,
                    "active": status]
        case .createUserPhotos(let photos):
            return APIParser().configureCreateUserPhotos(photos: photos)
        case .updatePhoto(_, let newPhoto):
            return APIParser().configureUserPhotoForUpdate(photo: newPhoto)
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
            
        case .saveInstagramToken(let token):
            return ["token":token]
            
        case .sendFeedback(let rate, let comment):
            return ["rate": "\(rate)",
                    "comment": comment]
            
        case .getLikesList(let page):
            if page != nil {
                return ["page":page!]
            } else {
                return nil
            }
    case .signOut, .getUserProfile, .disconnectFB, .likeUser, .unlikeUser, .getNotifications, .removeChat, .dislikeUser, .deleteAccount, .blockUser, .unblockUser, .getInterestsBase, .getBadWordsContent, .getInstagramPhotos, .disconnectInstagram:
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
    
}
