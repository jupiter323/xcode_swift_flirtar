//
//  SplashViewController.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD

class SplashViewController: UIViewController, SplashViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var agreementTextView: UITextView!
    
    //MARK: - UIViewContoller
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: - Helpers
    private func configureTextView() {
        agreementTextView.addLink(forText: "Terms of Service", url: URL(string: ExternalLinks.termsOfService.rawValue)!)
        agreementTextView.addLink(forText: "Privacy Policy", url: URL(string: ExternalLinks.privacyPolicy.rawValue)!)
        agreementTextView.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func fbContinueTap(_ sender: Any) {
        presenter?.loginWithFB()
    }
    
    //MARK: - SplashViewProtocol
    var presenter: SplashPresenterProtocol?
    
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
            self.presenter?.showNextScreen()
        }
    }


}

//MARK: - UITextViewDelegate
extension SplashViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}
