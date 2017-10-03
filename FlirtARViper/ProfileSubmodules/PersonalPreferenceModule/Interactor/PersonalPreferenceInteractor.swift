//
//  PersonalPreferenceInteractor.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation


class PersonalPreferenceInteractor: PersonalPreferenceInteractorInputProtocol {
    
    weak var presenter: PersonalPreferenceInteractorOutputProtocol?
    
    func saveLookingGender(gender: GenderPreference?) {
        ProfileService.currentUser?.genderPreferences = gender
    }
    func saveLookingRange(range: RangeModel?) {
        ProfileService.currentUser?.minAge = range?.start
        ProfileService.currentUser?.maxAge = range?.end
    }
    
    func getCurrentUser() {
        if let user = ProfileService.savedUser {
            presenter?.userRetrieved(user: user)
        }
    }
}
