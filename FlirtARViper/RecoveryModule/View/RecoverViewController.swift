//
//  RecoverViewController.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD

class RecoverViewController: UIViewController, RecoveryViewProtocol {

    
    //MARK: - Outlets
    @IBOutlet weak var emailField: InputTextField!
    
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helpers
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        let _ = emailField.resignFirstResponder()
    }
    
    
    
    //MARK: - RecoveryViewProtocol
    var presenter: RecoveryPresenterProtocol?
    
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.loading.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showRecoverError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showSuccessRecover() {
        
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.passwordRecovered.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.dismissMe()
        }
        
    }
    
    //MARK: - Actions
    @IBAction func sendTap(_ sender: Any) {
        
        guard let email = emailField.text else {
            return
        }
        
        if email.characters.count == 0 {
            let _ = emailField.becomeFirstResponder()
        } else {
            presenter?.startPasswordRecovering(with: email)
        }
        
        
    }

    @IBAction func backTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func signupTap(_ sender: Any) {
        presenter?.showSignup()
    }
}

extension RecoverViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var result: Bool? = false
        
        result = textField.text?.isValidEmail()
        
        if result != true {
            textField.shake()
        }
        
        return result ?? false
    }
    
    
}




