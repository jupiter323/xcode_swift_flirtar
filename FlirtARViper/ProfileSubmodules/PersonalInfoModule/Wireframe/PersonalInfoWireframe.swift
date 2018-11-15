//
//  PersonalInfoWireframe.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class PersonalInfoWireframe: PersonalInfoWireframeProtocol {
    
    static func configureSUProfileInfoView() -> UIViewController {
        let personalInfoController = UIStoryboard(name: "PersonalInfo", bundle: nil).instantiateViewController(withIdentifier: "PersonalInfoViewController")
        
        if let view = personalInfoController as? PersonalInfoViewController {
            
            
            let presenter = PersonalInfoPresenter()
            let interactor = PersonalInfoInteractor()
            let wireframe = PersonalInfoWireframe()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            return personalInfoController
            
        }
        return UIViewController()
    }
}
