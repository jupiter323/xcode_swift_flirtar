//
//  SUEmailViewController.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD


class SUEmailViewController: UIViewController, SUEmailViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var emailTextField: InputTextField!
    @IBOutlet weak var continueButton: UIButton!
    
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
        let _ = emailTextField.resignFirstResponder()
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    @IBAction func signUpFBTap(_ sender: Any) {
        presenter?.startSignUpWithFB()
    }
    
    @IBAction func continueTap(_ sender: Any) {
        
        let result = emailTextField.text?.isValidEmail()
        if result != true {
            emailTextField.shake()
        } else {
            let _ = emailTextField.resignFirstResponder()
            presenter?.startEmailAvailabilityChecking(withEmail: emailTextField.text!)
        }
        
//        presenter?.startEmailAvailabilityChecking(withEmail: emailTextField.text!)
    }
    
    
    @IBAction func logInTap(_ sender: Any) {
        presenter?.showLogin()
    }
    
    
    @IBAction func textEdit(_ sender: Any) {
        if emailTextField.text?.characters.count != 0 {
            continueButton.isHidden = false
        } else {
            continueButton.isHidden = true
        }
    }
    
    
    //MARK: - SUEmailViewProtocol
    var presenter: SUEmailPresenterProtocol?
    
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.waiting.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showEmailIsAvailable() {
        

        
        HUD.show(.labeledSuccess(title: SuccessMessage.emailAvailable.rawValue, subtitle: nil))
        HUD.hide(afterDelay: 3.0)
        
        presenter?.startRequestPinCode()
        

        
    }
    
    func showPinCodeSendSuccess() {
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.pinCodeSend.rawValue, subtitle: nil))
        HUD.hide(afterDelay: 3.0)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showPinCodeView()
        }
    }
    
    func showFBSuccessLogin() {
        
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.logInSuccess.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showMainTab()
        }
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    

}

extension SUEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let result = textField.text?.isValidEmail()
        if result != true {
            textField.shake()
        } else {
            let _ = emailTextField.resignFirstResponder()
            presenter?.startEmailAvailabilityChecking(withEmail: emailTextField.text!)
        }
        return true
    }
    
}
