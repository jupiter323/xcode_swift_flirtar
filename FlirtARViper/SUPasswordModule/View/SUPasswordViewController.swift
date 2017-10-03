//
//  SUPasswordViewController.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUPasswordViewController: UIViewController, SUPasswordViewProtocol {
    
    //MARK: - Outlets
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
        let _ = passwordField.resignFirstResponder()
    }

    
    //MARK: - SUPasswordViewProtocol
    var presenter: SUPasswordPresenterProcotol?
    
    //MARK: - Actions
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func signUpTap(_ sender: Any) {
        validatePassword(passwordField)
    }
    
    //MARK: - Private
    fileprivate func validatePassword(_ textField: UITextField) {
        let result = textField.text?.isValidPassword()
        
        if result != true {
            textField.becomeFirstResponder()
            textField.shake()
        } else {
            let _ = passwordField.resignFirstResponder()
            presenter?.savePassword(password: textField.text)
            presenter?.showPhotosInfoView()
        }
    }
    
}

extension SUPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validatePassword(textField)
        return true
    }
    
}
