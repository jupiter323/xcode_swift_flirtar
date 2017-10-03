//
//  User.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import ObjectMapper

enum Gender: Int {
    
    case female = 0
    case male = 1
    
    var description: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        }
    }
    
    static func gender(by description: String) -> Gender {
        switch description {
        case Gender.male.description:
            return Gender.male
        default:
            return Gender.female
        }
    }
}

enum GenderPreference: Int {
    
    case female = 0
    case male = 1
    case both = 2
    
    var description: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .both:
            return "both"
        }
    }
    
    static func genderPreference(by description: String) -> GenderPreference {
        switch description {
        case GenderPreference.male.description:
            return GenderPreference.male
        case GenderPreference.female.description:
            return GenderPreference.female
        default:
            return GenderPreference.both
        }
    }
}


struct User {
    var userID: Int?
    var email: String?
    var password: String?
    var firstName: String?
    var birthday: Date?
    var gender: Gender?
    var shortIntroduction: String?
    var interests: String?
    var genderPreferences: GenderPreference?
    var minAge: Int?
    var maxAge: Int?
    var showOnMap: Bool?
    var isFacebook: Bool?
    
    init() {}
    
    func validateForSignUp() -> [FillProfileError] {
        
        var errorsList = [FillProfileError]()
        
        if self.birthday == nil {
            errorsList.append(.birthdayNotFilled)
        }
        
//        if self.email == nil {
//            errorsList.append(.emailNotFilled)
//        } else if self.email!.isEmpty {
//            errorsList.append(.emailNotFilled)
//        }
        
        if self.firstName == nil {
            errorsList.append(.firstnameNotFilled)
        } else if self.firstName!.isEmpty {
            errorsList.append(.firstnameNotFilled)
        }
        
        if self.interests == nil {
            errorsList.append(.interestsNotFilled)
        } else if self.interests!.isEmpty {
            errorsList.append(.interestsNotFilled)
        }
        
//        if self.password == nil {
//            errorsList.append(.passwordNotFilled)
//        } else if self.password!.isEmpty {
//            errorsList.append(.passwordNotFilled)
//        }
        
        if self.shortIntroduction == nil {
            errorsList.append(.introductionNotFilled)
        } else if self.shortIntroduction!.isEmpty {
            errorsList.append(.introductionNotFilled)
        }
        
        return errorsList

    }
    
    func validateForUpdate() -> [FillProfileError] {
        
        var errorsList = [FillProfileError]()
        
        if self.birthday == nil {
            errorsList.append(.birthdayNotFilled)
        }
        
        if self.firstName == nil {
            errorsList.append(.firstnameNotFilled)
        } else if self.firstName!.isEmpty {
            errorsList.append(.firstnameNotFilled)
        }
        
        if self.interests == nil {
            errorsList.append(.interestsNotFilled)
        } else if self.interests!.isEmpty {
            errorsList.append(.interestsNotFilled)
        }
        
        if self.shortIntroduction == nil {
            errorsList.append(.introductionNotFilled)
        } else if self.shortIntroduction!.isEmpty {
            errorsList.append(.introductionNotFilled)
        }
        
        return errorsList
        
    }
    
    func validateForMapsUpdate() -> UserMapValidation? {
        
        guard let minimunAge = self.minAge, let maximumAge = self.maxAge, self.genderPreferences != nil else {
            return .preferencesInvalid
        }
        
        print("DEBUG User: Photos - \(ProfileService.recievedPhotos)")
        
        if ProfileService.recievedPhotos.count == 0 {
            return .photosInvalid
        } else if minimunAge == 0 || maximumAge == 0 {
            return .preferencesInvalid
        } else {
            return nil
        }
    }
}

extension User: Mappable {
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        userID <- map[ServerUserJSONKeys.id.rawValue]
        email <- map[ServerUserJSONKeys.email.rawValue]
        password <- map[ServerUserJSONKeys.password.rawValue]
        firstName <- map[ServerUserJSONKeys.firstName.rawValue]
        
        var birthdayString: String?
        birthdayString <- map[ServerUserJSONKeys.birthday.rawValue]
        if let birthdayString = birthdayString {
            birthday = DateFormatter.apiModelDateFormatter.date(from: birthdayString)
        }
        
        var genderString: String?
        genderString <- map[ServerUserJSONKeys.gender.rawValue]
        if let genderString = genderString {
            gender = Gender.gender(by: genderString)
        }
        
        shortIntroduction <- map[ServerUserJSONKeys.shortIntroduction.rawValue]
        interests <- map[ServerUserJSONKeys.interests.rawValue]
        
        var genderPreferencesString: String?
        genderPreferencesString <- map[ServerUserJSONKeys.genderPreferences.rawValue]
        if let genderPreferencesString = genderPreferencesString {
            if genderPreferencesString != "" {
                genderPreferences = GenderPreference.genderPreference(by: genderPreferencesString)
            }
        }
        
        var serverMinAge: Int?
        serverMinAge <- map[ServerUserJSONKeys.minAge.rawValue]
        if let serverMinAge = serverMinAge {
            if serverMinAge >= 18 && serverMinAge <= 65 {
                minAge <- map[ServerUserJSONKeys.minAge.rawValue]
            }
        }
        
        var serverMaxAge: Int?
        serverMaxAge <- map[ServerUserJSONKeys.maxAge.rawValue]
        if let serverMaxAge = serverMaxAge {
            if serverMaxAge >= 18 && serverMaxAge <= 65 {
                maxAge <- map[ServerUserJSONKeys.maxAge.rawValue]
            }
        }
        
        showOnMap <- map[ServerUserJSONKeys.showOnMap.rawValue]
        isFacebook <- map[ServerUserJSONKeys.isFacebook.rawValue]
        
    }
}
