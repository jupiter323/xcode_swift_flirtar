//
//  PersonalInfoPresenter.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class PersonalInfoPresenter: PersonalInfoPresenterProtocol {

    weak var view: PersonalInfoViewProtocol? 
    var wireframe: PersonalInfoWireframeProtocol?
    var interactor: PersonalInfoInteractorInputProtocol?
    
    func viewWillAppear() {
        interactor?.getCurrentUser()
    }
    
    func saveUsername(username: String?) {
        interactor?.saveUsername(username: username)
    }
    func saveDateOfBirth(dateOfBirth: Date?) {
        interactor?.saveDateOfBirth(dateOfBirth: dateOfBirth)
    }
    func saveGender(gender: Gender?) {
        interactor?.saveGender(gender: gender)
    }
    func saveIntroduction(introduction: String?) {
        interactor?.saveIntroduction(introduction: introduction)
    }
    func saveInterests(interests: String?) {
        interactor?.saveInterests(interests: interests)
    }
    
}

extension PersonalInfoPresenter: PersonalInfoInteractorOutputProtocol {
    func userRetrieved(user: User) {
        view?.fillFieldsWithUser(user: user)
    }
}
