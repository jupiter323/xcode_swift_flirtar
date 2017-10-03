//
//  LoginViewController.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController, LoginViewProtocol {

    
    //MARK: - Outlets
    @IBOutlet weak var loginField: InputTextField!
    @IBOutlet weak var passwordField: InputTextField!
    
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
        let _ = loginField.resignFirstResponder()
        let _ = passwordField.resignFirstResponder()
    }
    
    
    //MARK: - LoginViewProtocol
    var presenter: LoginPresenterProtocol?
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.loading.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showLoginError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showSuccessLogin() {
        
        
        
        
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.logInSuccess.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showMainTab()
        }
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func forgotPasswordTap(_ sender: Any) {
        presenter?.showPasswordRecover()
    }
    
    @IBAction func loginTap(_ sender: Any) {
        
        guard let email = loginField.text, let password = passwordField.text else {
            return
        }
        
        if email.characters.count == 0 {
            let _ = loginField.becomeFirstResponder()
        } else if password.characters.count == 0 {
            let _ = passwordField.becomeFirstResponder()
        } else {
            presenter?.startLogin(with: email, password: password)
        }
        
        
    }
    
    @IBAction func loginWithFBTap(_ sender: Any) {
        presenter?.startLoginWithFB()
    }
    
    @IBAction func signUpTap(_ sender: Any) {
        presenter?.showSignup()
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var result: Bool? = false
        
        if textField === passwordField {
            result = textField.text?.isValidPassword()
        } else {
            result = textField.text?.isValidEmail()
        }
        
        if result != true {
            textField.shake()
        } else {
            if textField === passwordField {
                let _ = passwordField.resignFirstResponder()
            } else {
                let _ = passwordField.becomeFirstResponder()
            }
        }
        
        return true
    }
    
}


