//
//  PersonalInfoInteractor.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class PersonalInfoInteractor: PersonalInfoInteractorInputProtocol {
    
    weak var presenter: PersonalInfoInteractorOutputProtocol?

    
    func saveUsername(username: String?) {
        ProfileService.currentUser?.firstName = username
    }
    func saveDateOfBirth(dateOfBirth: Date?) {
        ProfileService.currentUser?.birthday = dateOfBirth
    }
    func saveGender(gender: Gender?) {
        ProfileService.currentUser?.gender = gender
    }
    func saveIntroduction(introduction: String?) {
        ProfileService.currentUser?.shortIntroduction = introduction
    }
    func saveInterests(interests: String?) {
        ProfileService.currentUser?.interests = interests
    }
    
    func getCurrentUser() {
        if let user = ProfileService.savedUser {
            presenter?.userRetrieved(user: user)
        }
    }
}
