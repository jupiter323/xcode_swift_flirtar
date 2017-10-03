//
//  PersonalPreferenceWireframe.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


class PersonalPreferenceWireframe: PersonalPreferenceWireframeProtocol {
    
    static func configurePersonalPreferenceView() -> UIViewController {
        let personalPreferenceController = UIStoryboard(name: "PersonalPreference", bundle: nil).instantiateViewController(withIdentifier: "PersonalPreferenceViewController")
        
        if let view = personalPreferenceController as? PersonalPreferenceViewController {
            
            
            let presenter = PersonalPreferencePresenter()
            let interactor = PersonalPreferenceInteractor()
            let wireframe = PersonalPreferenceWireframe()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            return personalPreferenceController
            
        }
        return UIViewController()
    }
}
