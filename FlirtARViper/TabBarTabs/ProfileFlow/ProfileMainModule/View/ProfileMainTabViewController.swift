//
//  ProfileMainTabViewController.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD
import Photos
import BSImagePicker
import GBHFacebookImagePicker

enum PhotosProvider {
    case fb
    case local
}

class ProfileMainTabViewController: UIViewController, ProfileMainTabViewProtocol {

    //MARK: - Outlets
    //Data
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var genderPreferencesView: TitleTextView!
    @IBOutlet weak var agePreferencesView: TitleTextView!
    @IBOutlet weak var showOnMapSwitch: SwitchView!
    
    @IBOutlet weak var photoModule: UIView!
    
    //Draw
    @IBOutlet weak var roundedView: UIView!
    
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        roundedView.layoutIfNeeded()
        roundedView.layer.cornerRadius = 3.0
        showOnMapSwitch.delegate = self
        
        
        
    }
    
    //update when come back
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter?.viewWillApear()
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureController(withProfile profile: User) {
        firstNameLabel.text = profile.firstName ?? "No name"
        if let gender = profile.genderPreferences {
            switch gender {
            case .female:
                genderPreferencesView.subTitle = "Women"
            case .male:
                genderPreferencesView.subTitle = "Men"
            case .both:
                genderPreferencesView.subTitle = "Both"
            }
        } else {
            genderPreferencesView.subTitle = "No data"
        }
        
        if let minAge = profile.minAge,
            let maxAge = profile.maxAge {
            agePreferencesView.subTitle = "\(minAge) - \(maxAge)"
        } else {
            agePreferencesView.subTitle = "No data"
        }
        
        showOnMapSwitch.isOn = profile.showOnMap ?? false
        
    }
    
    //MARK: - Actions
    
    @IBAction func profileSettingsTap(_ sender: Any) {
        presenter?.showProfileSettings()
    }
    
    @IBAction func changePhotoTap(_ sender: Any) {
        presenter?.startSelectPhotos()
    }
    
    
    //MARK: - ProfileMainTabViewProtocol
    var presenter: ProfileMainTabPresenterProtocol?
    func showActivityIndicator(withType: ActivityIndicatiorMessage) {
        HUD.show(.labeledProgress(title: withType.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showProfile(profile: User) {
        //fill fields here
        configureController(withProfile: profile)
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func embedThisModule(module: UIViewController) {
        
        for view in photoModule.subviews {
            view.removeFromSuperview()
        }
        
        
        addChildViewController(module)
        module.view.frame = CGRect(x: 0, y: 0, width: photoModule.frame.size.width, height: photoModule.frame.size.height)
        photoModule.addSubview(module.view)
        module.didMove(toParentViewController: self)
        
    }
    
    func showLocalPicker(picker: UIViewController) {
        
        
        bs_presentImagePickerController(
            picker as! BSImagePickerViewController,
            animated: true,
            select: nil,
            deselect: nil,
            cancel: nil,
            finish: { (assets) in
                
                if assets.count != 3 {
                    self.errorPhotosCount(provider: .local)
                } else {
                    //if selected 3 -> save on server
                    print("DEBUG Profile View: assets - \(assets)")
                    let images = AssetHelper.resolveAssets(assets)
                    print("DEBUG Profile View: images - \(images)")
                    DispatchQueue.main.async {
                        self.presenter?.updatePhotos(withPhotos: images)
                    }
                }
        },
            completion: nil)

        
        
    }
    
    func showFbPicker(picker: NSObject) {
        (picker as! GBHFacebookImagePicker).presentFacebookAlbumImagePicker(from: self, delegate: self)
    }
    
    func errorPhotosCount(provider: PhotosProvider) {
        let alert = UIAlertController(title: "Photos count error", message: "Please select 3 photos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue selecting", style: .default, handler: { (_) in
            //show picker again and continue
            switch provider {
            case .fb:
                self.presenter?.selectFBPhotos()
            case .local:
                self.presenter?.selectLocalPhotos()
            }
            
            
        }))

        //simple cancel
        alert.addAction(UIAlertAction(title: "Cancel selection", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showPhotoSourceSelection() {
        let alert = UIAlertController(title: "Select photo source",
                                      message: "Photo provider",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery & Camera",
                                      style: .default,
                                      handler: { (_) in
                                        self.presenter?.selectLocalPhotos()
                                        //presenter show default
        }))
        
        alert.addAction(UIAlertAction(title: "Facebook",
                                      style: .default,
                                      handler: { (_) in
                                        //presenter show fb controller
                                        self.presenter?.selectFBPhotos()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - SwitchViewDelegate
extension ProfileMainTabViewController: SwitchViewDelegate {
    func valueChanged(switchView: SwitchView) {
        presenter?.updateShowOnMap(withStatus: switchView.isOn)
    }
}

//MARK: - GBHFacebookImagePickerDelegate
extension ProfileMainTabViewController: GBHFacebookImagePickerDelegate {
    
    func facebookImagePicker(imagePicker: UIViewController, successImageModels: [GBHFacebookImage], errorImageModels: [GBHFacebookImage], errors: [Error?]) {
        print(successImageModels)
        
        var images = [UIImage]()
        for eachImage in successImageModels {
            if eachImage.image != nil {
                images.append(eachImage.image!)
            }
        }
        
        if images.count != 3 {
            errorPhotosCount(provider: .fb)
        } else {
            DispatchQueue.main.async {
                self.presenter?.updatePhotos(withPhotos: images)
            }
        }
        
    }

    func facebookImagePicker(imagePicker: UIViewController,
                             didFailWithError error: Error?) {
        HUD.show(.labeledError(title: "FB Photos", subtitle: error?.localizedDescription))
        HUD.hide(afterDelay: 3.0)
        print(error?.localizedDescription ?? "")
    }
    
    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        print("cancelled")
    }
    
    func facebookImagePickerDismissed() {
        print("dismiss")
    }
}


