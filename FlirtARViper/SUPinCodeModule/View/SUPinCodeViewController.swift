//
//  SUPinCodeViewController.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD

class SUPinCodeViewController: UIViewController, SUPinCodeViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var pinCodeView: PinCodeInputView!
    
    //MARK: - Variables
    fileprivate var enteredPin: String = ""
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinCodeView.textField.becomeFirstResponder()
        pinCodeView.delegate = self
        
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helpers
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        pinCodeView.endEditing(true)
    }
    
    //MARK: - Actions
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func continueTap(_ sender: Any) {
        if enteredPin.characters.count == pinCodeView.valueCount {
            pinCodeView.endEditing(true)
            presenter?.startPinCodeChecking(withPinCode: enteredPin)
        } else {
            pinCodeView.textField.becomeFirstResponder()
        }
    }
    
    //MARK: - SUPinCodeViewProtocol
    var presenter: SUPinCodePresenterProcotol?
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.checking.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showPinCodeIsNotCorrect(method: String, errorMessage: String) {
        
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
        
    }
    
    func showPinCodeIsCorrect() {
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.pinIsCorrect.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showPasswordView()
        }

    }

}


extension SUPinCodeViewController: PinCodeInputViewDelegate {
    func pinCodeDidFill(withValue value: String) {
        enteredPin = value
        print(value)
        guard value.characters.count == pinCodeView.valueCount else {
            return
        }
        
        pinCodeView.endEditing(true)
        presenter?.startPinCodeChecking(withPinCode: value)

        
    }
}
