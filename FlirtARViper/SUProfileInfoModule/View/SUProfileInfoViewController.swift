//
//  SUProfileInfoViewController.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD
import IQKeyboardManagerSwift

class SUProfileInfoViewController: UIViewController, SUProfileInfoViewProtocol {
    
    //MARK: - Outlet
    @IBOutlet var embedModules: [UIView]!
    @IBOutlet weak var showOnMapSwitch: SwitchView!
    
    //MARK: - Constraints
    @IBOutlet weak var personalBlockHeight: NSLayoutConstraint!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        showOnMapSwitch.delegate = self
        presenter?.saveShowOnMapStatus(status: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: - Actions

    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    
    @IBAction func saveButtonTap(_ sender: Any) {
        presenter?.startSignUp()
    }
    
    
    //MARK: - SUProfileInfoViewProtocol
    
    var presenter: SUProfileInfoPresenterProtocol?
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage) {
        HUD.show(.labeledProgress(title: withType.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showFillError(errorMessage: String) {
        let errorView = PKHUDTextView(text: errorMessage)
        errorView.titleLabel.numberOfLines = 0
        PKHUD.sharedHUD.contentView = errorView
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 5.0)
    }
    
    func embedThisModules(modules: [UIViewController]) {
        
        for i in 0..<embedModules.count {
            let container = embedModules[i]
            let newModule = modules[i]
            
            addChildViewController(newModule)
            newModule.view.frame = CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height)
            container.addSubview(newModule.view)
            newModule.didMove(toParentViewController: self)
            
            if newModule is PersonalInfoViewController {
                (newModule as! PersonalInfoViewController).delegate = self
            }
            
        }
    }
    
    func removeEmbedModules() {
        for eachController in childViewControllers {
            
            if eachController is PersonalInfoViewController {
                (eachController as! PersonalInfoViewController).delegate = nil
            }
            
            eachController.view.removeFromSuperview()
            eachController.removeFromParentViewController()
        }
        embedModules = nil
    }
    
    
    func showPhotosUploadedSuccess() {
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.saved.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showTabBarView()
        }
    }
    
    func showPhotosUploadError(method: String, errorMessage: String) {
        let delay = 3.0
        
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: delay)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
//            self.presenter?.showTabBarView()
//        }
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }

    

}


extension SUProfileInfoViewController: SwitchViewDelegate {
    func valueChanged(switchView: SwitchView) {
        presenter?.saveShowOnMapStatus(status: switchView.isOn)
    }
}

extension SUProfileInfoViewController: PersonalInfoViewControllerDelegate {
    func heightChanged(newValue: CGFloat) {
        print(newValue)
        personalBlockHeight.constant = newValue
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
}









