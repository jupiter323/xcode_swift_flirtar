//
//  SULicenseViewController.swift
//  FlirtARViper
//
//  Created by on 18.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import PKHUD

class SULicenseViewController: UIViewController, SULicenseViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var licenseTextView: UITextView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    //MARK: - Constraints
    @IBOutlet weak var licenseTextViewHeight: NSLayoutConstraint!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        agreeButton.isEnabled = false
        presenter?.getLicenseAgreement()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func agreeButtonTap(_ sender: Any) {
        presenter?.saveProfile()
    }

    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    //MARK: - SULicenseViewProtocol
    var presenter: SULicensePresenterProtocol?
    func showActivityIndicator(withType: ActivityIndicatiorMessage) {
        HUD.show(.labeledProgress(title: withType.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showPhotosUploadedSuccess() {
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.signedUp.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showTabBarView()
        }

    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)

    }
    
    func showPhotosUploadError(method: String, errorMessage: String) {
        let delay = 3.0
        
        HUD.show(.labeledError(title: SuccessMessage.signedUp.rawValue, subtitle: errorMessage))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showTabBarView()
        }
    }
    
    func showFillError(method: String, errorMessage: String) {
        let errorView = PKHUDTextView(text: errorMessage)
        errorView.titleLabel.numberOfLines = 0
        PKHUD.sharedHUD.contentView = errorView
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 5.0)
    }
    
    func showLicenseAgreement(withText text: String) {
        
        agreeButton.isEnabled = true
//        licenseTextView.text = text
        
        licenseTextView.layoutIfNeeded()
        let width = licenseTextView.frame.width
        let font = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        let height = licenseTextView.text.estimateFrameForText(font: font, width: width).height
        
        licenseTextViewHeight.constant = height + (15.0 * 2)
        
        

    }
    
    func showLicenseAgreementRecieveError(method: String, errorMessage: String) {
        agreeButton.isEnabled = false
        licenseTextView.text = ""
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
}
