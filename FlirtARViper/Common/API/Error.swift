//
//  Error.swift
//  FlirtARViper
//
//  Created by   on 21.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation

enum SuccessMessage: String {
    case logInSuccess = "Success"
    case emailAvailable = "Email is available"
    case signedUp = "Signed Up"
    case signedUpWithoutPhotos = "Signed Up (photos not uploaded)"
    case fbDisconnected = "Account disconnected"
    case saved = "Saved"
    case logouted = "Logouted"
    case deleted = "Deleted"
    case passwordRecovered = "Recover email successfully sent"
    case pinCodeSend = "Check pin code in mail"
    case pinIsCorrect = "Correct Pin"
}

enum ActivityIndicatiorMessage: String {
    case loading = "Loading..."
    case waiting = "Waiting..."
    case saving = "Saving..."
    case checking = "Checking..."
    case updating = "Updating..."
    case signingUp = "Signing Up"
    case uploadingPhotos = "Saving photos"
    case sending = "Sending..."
    case removing = "Removing..."
    case deleting = "Deleting..."
}

enum CoreDataError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case objectAlreadySaved
}

enum LoginError: Error {
    case userResponseError
    case credentialsIncorrectError
    case noTokenError
    
    var localizedDescription: String {
        switch self {
        case .userResponseError:
            return "No user in response"
        case .credentialsIncorrectError:
            return "Username or password incorrect"
        case .noTokenError:
            return "No token in response"
        }
    }
}

enum SignUpError: Error {
    case userResponseError
    case internalError
    
    var localizedDescription: String {
        switch self {
        case .userResponseError:
            return "No user in response"
        case .internalError:
            return "Internal error"
        }
    }
    
}

enum DialogError: Error {
    case selectedChatInvalid
    
    var localizedDescription: String {
        switch self {
        case .selectedChatInvalid:
            return "Selected chat invalid"
        }
    }
    
}

enum EmailCheckError: Error {
    case emailNotAvailable
    
    var localizedDescription: String {
        switch self {
        case .emailNotAvailable:
            return "Email is not available"
        }
    }
}

enum PinCodeError: Error {
    case pinCodeNotSent
    case pinCodeUnmatch
    case emailNotExist
    
    var localizedDescription: String {
        switch self {
        case .pinCodeNotSent:
            return "Pin code not sent"
        case .pinCodeUnmatch:
            return "Pin code incorrect"
        case .emailNotExist:
            return "No email for checking"
        }
    }
    
}

enum PasswordRecoverError: Error {
    case emailNotSended
    
    var localizedDescription: String {
        switch self {
        case .emailNotSended:
            return "Recover email not sent"
        }
    }
    
}

enum NotificationError: Error {
    case notificationChangeError
    case notAllNotificationsChanged
    case notificationsNotRecieved
    case notificationTypeInvalid
    
    var localizedDescription: String {
        switch self {
        case .notificationsNotRecieved:
            return "Notifications not loaded"
        case .notificationChangeError:
            return "Notification doesn't changed"
        case .notAllNotificationsChanged:
            return "Not all notifications changed"
        case .notificationTypeInvalid:
            return "Notification type invalid"
        }
    }
    
}

enum UpdateProfileError: Error {
    case internalError
    case profileResponseError
    case profileLoadingError
    case profileNotValid
    
    var localizedDescription: String {
        switch self {
        case .internalError:
            return "Internal error"
        case .profileResponseError:
            return "Not user in response"
        case .profileLoadingError:
            return "Profile loading error"
        case .profileNotValid:
            return "Profile not valid"
        }
    }
}

enum GetProfileError: Error {
    case profileResponseError
    case profileLoadingError
    
    var localizedDescription: String {
        switch self {
        case .profileResponseError:
            return "Not user in response"
        case .profileLoadingError:
            return "Profile loading error"
        }
    }
}

enum LikeError: Error {
    case likeNotSet
    case unlikeNotSet
    
    var localizedDescription: String {
        switch self {
        case .likeNotSet:
            return "Like not set"
        case .unlikeNotSet:
            return "Unlike not set"
        }
    }
    
}

enum FillProfileError: Error {
    case emailNotFilled
    case passwordNotFilled
    case interestsNotFilled
    case introductionNotFilled
    case firstnameNotFilled
    case birthdayNotFilled
    
    var localizedDescription: String {
        switch self {
        case .emailNotFilled:
            return "email"
        case .passwordNotFilled:
            return "password"
        case .interestsNotFilled:
            return "interests (please type interest and press enter to add it)"
        case .introductionNotFilled:
            return "introduction"
        case .firstnameNotFilled:
            return "firstname"
        case .birthdayNotFilled:
            return "birthday"
        }
    }
}

enum PhotosUploadError: Error {
    case photosNotUploaded
    
    var localizedDescription: String {
        switch self {
        case .photosNotUploaded:
            return "Photos not uploaded"
        }
    }
}

enum UpdateLocationError: Error {
    case invalidLocation
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidLocation:
            return "Invalid location"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}

enum ManualLocationError: Error {
    case emptyAddress
    case invalidAddress
    
    var localizedDescription: String {
        switch self {
        case .emptyAddress:
            return "Address can't be empty"
        case .invalidAddress:
            return "Invalid address"
        }
    }
}

enum GetMatchUsersError: Error {
    case usersNotRecieved
    
    var localizedDescription: String {
        switch self {
        case .usersNotRecieved:
            return "Users not recieved"
        }
    }
}

enum BanUserError: Error {
    case userNotBlocked
    case userNotReported
    
    var localizedDescription: String {
        switch self {
        case .userNotBlocked:
            return "User not blocked"
        case .userNotReported:
            return "User not reported"
        }
    }
    
}







