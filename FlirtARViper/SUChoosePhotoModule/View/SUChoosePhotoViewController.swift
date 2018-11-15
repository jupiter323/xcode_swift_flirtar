//
//  SUChoosePhotoViewController.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUChoosePhotoViewController: UIViewController, SUChoosePhotoViewProtocol {
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func choosePhotosTap(_ sender: Any) {
        presenter?.startSelectPhotos()
    }
    
    
    
    
    //MARK: - SUChoosePhotoViewProtocol
    var presenter: SUChoosePhotoPresenterProtocol?
    
    func showPhotoSourceSelection() {
        let alert = UIAlertController(title: "Select photo source",
                                      message: "Photo provider",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery & Camera",
                                      style: .default,
                                      handler: { (_) in
                                        self.presenter?.showPhotosConfirm(sourceType: .local)
                                        //presenter show default
        }))
        
        alert.addAction(UIAlertAction(title: "Facebook",
                                      style: .default,
                                      handler: { (_) in
                                        //presenter show fb controller
                                        self.presenter?.showPhotosConfirm(sourceType: .fb)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

}
