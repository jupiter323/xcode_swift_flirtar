//
//  MessagesDetailWireframe.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


class MessagesDetailWireframe: MessagesDetailWireframeProtocol {
    static func configureMessagesDetailView(withDialog dialog: Dialog) -> UIViewController {
        let dialogDetailController = UIStoryboard(name: "MessagesDetail", bundle: nil).instantiateViewController(withIdentifier: "MessagesDetailViewController")
        
        if let view = dialogDetailController as? MessagesDetailViewController {
            
            let presenter = MessagesDetailPresenter()
            let interactor = MessagesDetailInteractor()
            let wireframe = MessagesDetailWireframe()
            let remoteDatamanager = MessagesDetailRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            presenter.selectedDialog = dialog
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return dialogDetailController
            
        }
        return UIViewController()
    }
    
    func openProfileInfo(forProfile profileId: Int) {
        let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUserId: profileId)
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController?.present(arProfileDetailController, animated: true, completion: nil)
    }
    
    func backToDialogs(fromView view: MessagesDetailViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
    
}
