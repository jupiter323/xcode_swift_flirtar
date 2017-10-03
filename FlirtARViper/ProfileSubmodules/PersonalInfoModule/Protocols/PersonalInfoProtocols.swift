//
//  PersonalInfoProtocols.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol PersonalInfoViewProtocol: class {
    
    var presenter: PersonalInfoPresenterProtocol? {get set}
    var delegate: PersonalInfoViewControllerDelegate? {get set}
    
    func fillFieldsWithUser(user: User)
}

protocol PersonalInfoWireframeProtocol {
    static func configureSUProfileInfoView() -> UIViewController
}

protocol PersonalInfoPresenterProtocol {
    var view: PersonalInfoViewProtocol? {get set}
    var wireframe: PersonalInfoWireframeProtocol? {get set}
    var interactor: PersonalInfoInteractorInputProtocol? {get set}
    
    func viewWillAppear()
    
    func saveUsername(username: String?)
    func saveDateOfBirth(dateOfBirth: Date?)
    func saveGender(gender: Gender?)
    func saveIntroduction(introduction: String?)
    func saveInterests(interests: String?)
    
}

protocol PersonalInfoInteractorInputProtocol {
    var presenter: PersonalInfoInteractorOutputProtocol? {get set}
    
    func saveUsername(username: String?)
    func saveDateOfBirth(dateOfBirth: Date?)
    func saveGender(gender: Gender?)
    func saveIntroduction(introduction: String?)
    func saveInterests(interests: String?)
    
    func getCurrentUser()
    
}


protocol PersonalInfoInteractorOutputProtocol: class {
    func userRetrieved(user: User)
}












