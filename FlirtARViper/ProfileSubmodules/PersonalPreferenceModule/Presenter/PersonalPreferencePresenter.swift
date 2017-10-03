//
//  PersonalPreferencePresenter.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class PersonalPreferencePresenter: PersonalPreferencePresenterProtocol {
    
    weak var view: PersonalPreferenceViewProtocol?
    var wireframe: PersonalPreferenceWireframeProtocol?
    var interactor: PersonalPreferenceInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.getCurrentUser()
    }
    
    func saveLookingGender(gender: GenderPreference?) {
        interactor?.saveLookingGender(gender: gender)
    }
    func saveLookingRange(range: RangeModel?) {
        interactor?.saveLookingRange(range: range)
    }
    
    
}

extension PersonalPreferencePresenter: PersonalPreferenceInteractorOutputProtocol {
    func userRetrieved(user: User) {
        view?.fillFieldsWithUser(user: user)
    }
}
