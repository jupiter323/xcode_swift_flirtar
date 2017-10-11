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
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var interestsCollection: UICollectionView!
    @IBOutlet weak var introductionLabel: UILabel!
    
    
    
    @IBOutlet weak var photoModule: UIView!
    @IBOutlet weak var instagramPhotosModule: UIView!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    //Constraints
    @IBOutlet weak var instagramPhotosHeight: NSLayoutConstraint!
    
    //Draw
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var instagramRoundedView: UIView!
    @IBOutlet weak var roundedInsetView: UIView!
    
    
    @IBOutlet weak var nameAgeView: UIView!
    @IBOutlet weak var interestsView: UIView!
    
    //MARK: - Constraints
    @IBOutlet var infoBlockHeight: NSLayoutConstraint!
    @IBOutlet var infoBlockInitialHeight: NSLayoutConstraint!
    
    @IBOutlet var nameAgeInitialConstraintHeight: NSLayoutConstraint!
    @IBOutlet var nameAgeHeight: NSLayoutConstraint!
    
    @IBOutlet var interestsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var interestsViewRight: NSLayoutConstraint!
    
    
    
    //MARK: - Variables
    fileprivate var interests = [String]()
    fileprivate var collectionViewInitialHeight: CGFloat = 0.0
    fileprivate var roundedViewInitialHeight: CGFloat = 0.0
    fileprivate var introductionIsFullSize: Bool = false
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedInsetView.layoutIfNeeded()
        let distance = roundedInsetView.bounds.height + 20.0
        
        presenter?.viewDidLoad(withDistance: distance)
        
        roundedView.layoutIfNeeded()
        roundedView.round(radius: 3.0)
        instagramRoundedView.layoutIfNeeded()
        instagramRoundedView.round(radius: 3.0)
//        showOnMapSwitch.delegate = self
        
        interestsCollection.register(UINib(nibName: "InterestViewCell", bundle: nil), forCellWithReuseIdentifier: "profileInterestCell")
        
        interestsCollection.layoutIfNeeded()
        collectionViewInitialHeight = 35.0//interestsCollection.bounds.height
        
        roundedViewInitialHeight = roundedView.bounds.height
        
        introductionLabel.isUserInteractionEnabled = true
        introductionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(introductionTapped(recognizer:))))
        
    }
    
    //update when come back
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter?.viewWillApear()
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(false)
        
        if interests.count > 3 {
            moreInfoButton.isHidden = false
            interestsViewRight.constant = 70.0
//            interestsView.layoutIfNeeded()
            interestsCollection.collectionViewLayout.invalidateLayout()
        } else {
            moreInfoButton.isHidden = true
            interestsViewRight.constant = 20.0
//            interestsView.layoutIfNeeded()
            interestsCollection.collectionViewLayout.invalidateLayout()
        }
        
        
        roundedView.layoutIfNeeded()
        
        infoBlockInitialHeight.isActive = true
        infoBlockHeight.constant = roundedViewInitialHeight
        infoBlockHeight.isActive = false
        
        nameAgeInitialConstraintHeight.isActive = true
        nameAgeHeight.isActive = false
        
//        interestsCollection.collectionViewLayout.invalidateLayout()
        interestsHeight.constant = 35.0
        interestsHeight.isActive = true
//        interestsCollection.collectionViewLayout.invalidateLayout()
        
        introductionIsFullSize = false
        
        
        introductionLabel.layoutIfNeeded()
        introductionLabel.text = ProfileService.savedUser?.shortIntroduction ?? "No data"
        introductionLabel.addReadMoreText(with: " ",
                                          moreText: "Full Desc.",
                                          moreTextFont: introductionLabel.font,
                                          moreTextColor: UIColor(red: 251/255,
                                                                 green: 95/255,
                                                                 blue: 119/255,
                                                                 alpha: 1.0))
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureController(withProfile profile: User) {
        firstNameLabel.text = profile.firstName ?? "No name"
        
        if let userBirthday = profile.birthday {
            let yearsBetween = Date().years(from: userBirthday)
            ageLabel.text = "\(yearsBetween) y.o"
        } else {
            ageLabel.text = ""
        }
        
        
        
        introductionLabel.layoutIfNeeded()
        introductionLabel.text = profile.shortIntroduction ?? "No data"
        
        introductionLabel.addReadMoreText(with: " ",
                                      moreText: "Full Desc.",
                                      moreTextFont: introductionLabel.font,
                                      moreTextColor: UIColor(red: 251/255,
                                                             green: 95/255,
                                                             blue: 119/255,
                                                             alpha: 1.0))
        
        
        guard let interestsString = profile.interests else {
            return
        }
        
        let interestsArrayByComma = interestsString.components(separatedBy: ",")
        interests = interestsArrayByComma.filter{$0 != ""}
        interestsCollection.reloadData()
        
        
        
    }
    
    //MARK: - Actions
    
    @IBAction func profileSettingsTap(_ sender: Any) {
        presenter?.showProfileSettings()
    }
    
    @IBAction func changePhotoTap(_ sender: Any) {
        presenter?.startSelectPhotos()
    }
    
    @IBAction func moreInfoTap(_ sender: Any) {
        
        
        moreInfoButton.isHidden = true
        interestsViewRight.constant = 20.0
        interestsView.layoutIfNeeded()
        
        interestsCollection.collectionViewLayout.invalidateLayout()
        
        nameAgeView.layoutIfNeeded()
        nameAgeHeight.constant = nameAgeView.bounds.height
        nameAgeHeight.isActive = true
        nameAgeInitialConstraintHeight.isActive = false
        
        interestsCollection.layoutIfNeeded()
        let contentHeight = interestsCollection.contentSize.height
        interestsHeight.constant = contentHeight
        interestsHeight.isActive = true
        
        
        infoBlockHeight.constant = calculateInfoBlockHeight()
        
        infoBlockInitialHeight.isActive = false
        infoBlockHeight.isActive = true
        
//        introductionLabel.text = ProfileService.savedUser?.shortIntroduction ?? ""
        
        if !introductionIsFullSize {
            introductionLabel.addReadMoreText(with: " ",
                                              moreText: "Full Desc.",
                                              moreTextFont: introductionLabel.font,
                                              moreTextColor: UIColor(red: 251/255,
                                                                     green: 95/255,
                                                                     blue: 119/255,
                                                                     alpha: 1.0))
        }
        
        
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
    
    func embedThisModule(module: UIViewController,
                         type: PhotosModuleType) {
        
        switch type {
        case .apiPhotos:
            for view in photoModule.subviews {
                view.removeFromSuperview()
            }
            
            addChildViewController(module)
            module.view.frame = CGRect(x: 0, y: 0, width: photoModule.frame.size.width, height: photoModule.frame.size.height)
            photoModule.addSubview(module.view)
            module.didMove(toParentViewController: self)
        case .instagramPhotos:
            
            for view in instagramPhotosModule.subviews {
                view.removeFromSuperview()
            }
            
            addChildViewController(module)
            module.view.frame = CGRect(x: 0, y: 0, width: instagramPhotosModule.frame.size.width, height: instagramPhotosModule.frame.size.height)
            instagramPhotosModule.addSubview(module.view)
            module.didMove(toParentViewController: self)
            
            if let instaPhotos = module as? InstagramPhotosViewController {
                instaPhotos.delegate = self
            }
            
            
        }
        
        
        
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
    
    //MARK: - Helpers
    func calculateInfoBlockHeight() -> CGFloat {
        
        introductionLabel.layoutIfNeeded()
        let introWidth = introductionLabel.bounds.width
        let font = introductionLabel.font
        let introductionText = introductionLabel.text ?? ""//ProfileService.savedUser?.shortIntroduction ?? ""
        let textHeight = introductionText.estimateFrameForText(font: font!,
                                                               width: introWidth).height
        //5 + 5 bottom and top constraints
        let a = nameAgeHeight.constant + interestsHeight.constant
        let b = textHeight + 10.0
        let c = a + b
        
        return c
    }
    
    @objc private func introductionTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            
            introductionLabel.text = ProfileService.savedUser?.shortIntroduction ?? ""
            
            
            nameAgeView.layoutIfNeeded()
            nameAgeHeight.constant = nameAgeView.bounds.height
            nameAgeHeight.isActive = true
            nameAgeInitialConstraintHeight.isActive = false
            
            infoBlockHeight.constant = calculateInfoBlockHeight()
            
            infoBlockInitialHeight.isActive = false
            infoBlockHeight.isActive = true
            
            introductionIsFullSize = true
            
            
        }
    }
    
}

//MARK: - InstagramPhotosViewControllerDelegate
extension ProfileMainTabViewController: InstagramPhotosViewControllerDelegate {
    func photosUpdated(moduleHeight: CGFloat) {
        instagramPhotosHeight.constant = moduleHeight
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


extension ProfileMainTabViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let interestCell = cell as? InterestViewCell
        guard interestCell != nil else { return }
        interestCell!.configureCell(withInterest: interests[indexPath.row],
                                    maxFontSize: 13.0,
                                    fontColor: UIColor(red: 62/255,
                                                       green: 67/255,
                                                       blue: 79/255,
                                                       alpha: 1.0),
                                    fontName: "VarelaRound")
    }
}

extension ProfileMainTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileInterestCell", for: indexPath)
        return cell
        
    }
}


extension ProfileMainTabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //3 columns
        collectionView.layoutIfNeeded()
        let cellWidth = collectionView.bounds.width / 3.0
        //1 row
        let cellHeight = collectionViewInitialHeight
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    //No spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
    }
}








