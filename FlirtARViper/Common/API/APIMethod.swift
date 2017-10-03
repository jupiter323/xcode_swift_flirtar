//
//  APIMethods.swift
//  FlirtARViper
//
//  Created on 21.08.17.
//

import Foundation


enum APIMethod: String {
    case signIn = "POST/ SignIn"
    case signUpFB = "POST/ SignUpFB"
    case checkEmail = "POST/ CheckEMail"
    case signUp = "POST/ SignUp"
    case passwordRecover = "POST/ RecoverPWD"
    case sendPinCode = "POST/ SendPin"
    case checkPinCode = "POST/ CheckPin"
    
    case photos = "C/U/ UserPhotos"
    
    case fbDisconnect = "DEL /FBDiscon"
    case signOut = "DEL / SignOut"
    
    case updateNotification = "PATCH /Notif"
    case getNotifications = "GET /Notif"
    
    case updateProfile = "PATCH /UserProf"
    case getProfile = "GET /Profile"
    case updateLocation = "PUT /Loc"
    
    case setLike = "PUT /Like"
    case setDislike = "DEL /Dislike"
    
    case getMessages = "GET /Messages"
    
    case removeDialog = "DEL /Chat"
    case deleteProfile = "DEL /Account"
    
    case getMatchUsers = "GET /Match"
    case putBlockUser = "PUT /Block"
    case putUnblockUser = "PUT /Unblock"
    case reportUser = "POST /Report"
    case getBlockedUsers = "GET /Blocked"
    
}
