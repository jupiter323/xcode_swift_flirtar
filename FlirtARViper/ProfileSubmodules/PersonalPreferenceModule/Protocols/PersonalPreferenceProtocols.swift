//
//  PersonalPreferenceProtocols.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//


import UIKit

protocol PersonalPreferenceViewProtocol: class {
    
    var presenter: PersonalPreferencePresenterProtocol? {get set}
    func fillFieldsWithUser(user: User)
}

protocol PersonalPreferenceWireframeProtocol {
    static func configurePersonalPreferenceView() -> UIViewController
}

protocol PersonalPreferencePresenterProtocol {
    var view: PersonalPreferenceViewProtocol? {get set}
    var wireframe: PersonalPreferenceWireframeProtocol? {get set}
    var interactor: PersonalPreferenceInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    
    func saveLookingGender(gender: GenderPreference?)
    func saveLookingRange(range: RangeModel?)
}

protocol PersonalPreferenceInteractorInputProtocol {
    
    var presenter: PersonalPreferenceInteractorOutputProtocol? {get set}
    
    func saveLookingGender(gender: GenderPreference?)
    func saveLookingRange(range: RangeModel?)
    
    func getCurrentUser()
}

protocol PersonalPreferenceInteractorOutputProtocol: class {
    func userRetrieved(user: User)
}
