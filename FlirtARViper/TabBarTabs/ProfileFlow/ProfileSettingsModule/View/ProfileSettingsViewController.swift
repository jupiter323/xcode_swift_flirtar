//
//  ProfileSettingsViewController.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD
import IQKeyboardManagerSwift

class ProfileSettingsViewController: UIViewController, ProfileSettingsViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet var embedModules: [UIView]!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    //MARK: - Constraints
    @IBOutlet weak var personalBlockHeight: NSLayoutConstraint!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        presenter?.startSavingProfile()
    }
    
    @IBAction func deleteMyProfileTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete account", message: "Are you sure? It remove all you data.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.presenter?.startDeletingProfile()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - ProfileSettingsViewProtocol
    var presenter: ProfileSettingsPresenterProtocol?
    
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
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage) {
        HUD.show(.labeledProgress(title: withType.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showProfileSaveSucceess() {
        
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.saved.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.dismissMe()
        }
        
        
    }
    
    func showProfileDeleteSuccess() {
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.deleted.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showSplash()
        }
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showFillError(method: String, errorMessage: String) {
        let errorView = PKHUDTextView(text: errorMessage)
        errorView.titleLabel.numberOfLines = 0
        PKHUD.sharedHUD.contentView = errorView
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 5.0)
    }

}

extension ProfileSettingsViewController: PersonalInfoViewControllerDelegate {
    func heightChanged(newValue: CGFloat) {
        print(newValue)
        personalBlockHeight.constant = newValue
//        self.view.layoutIfNeeded()
//        self.view.layoutSubviews()
    }
}
