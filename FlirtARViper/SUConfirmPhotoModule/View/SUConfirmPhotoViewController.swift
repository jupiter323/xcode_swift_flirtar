//
//  SUConfirmPhotoViewController.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD
import BSImagePicker
import GBHFacebookImagePicker

class SUConfirmPhotoViewController: UIViewController, SUConfirmPhotoViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var photosCollection: UICollectionView!
    
    //MARK: - Data
    fileprivate var profilePhotos: [UIImage]!
    fileprivate var fbSelectResult: FBPhotosSelectResult!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init
        profilePhotos = [UIImage]()
        fbSelectResult = .success
        
        //logic
        presenter?.viewDidLoad()
        
        //register uicollectioncell
        photosCollection.register(UINib(nibName: "PhotoViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func confirmTap(_ sender: Any) {
        if profilePhotos.count == 3 {
            presenter?.showProfileConfirm()
        } else {
            errorPhotosCount()
        }
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    
    //MARK: - SUConfirmPhotoViewProtocol
    var presenter: SUConfirmPhotoPresenterProtocol?
    
    func showLocalPicker(picker: UIViewController) {
        bs_presentImagePickerController(
            picker as! BSImagePickerViewController,
            animated: true,
            select: nil,
            deselect: nil,
            cancel: { (_) in
                self.presenter?.dismissMe()
        },
            finish: { (assets) in
                
                if assets.count != 3 {
                    self.errorPhotosCount()
                } else {
                    //if selected 3 -> save on server
                    let images = AssetHelper.resolveAssets(assets)
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
    
    func showPhotos(photos: [UIImage]) {
        profilePhotos = photos
        photosCollection.reloadData()
    }
    
    //MARK: - Helpers
    func errorPhotosCount() {
        
        let alert = UIAlertController(title: "Photos count error", message: "Please select 3 photos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue selecting", style: .default, handler: { (_) in
            self.presenter?.viewDidLoad()
        }))
        alert.addAction(UIAlertAction(title: "Go back", style: .destructive, handler: { (_) in
            self.presenter?.dismissMe()
        }))

        present(alert, animated: true, completion: nil)
        
    }
}

enum FBPhotosSelectResult {
    case incorrectPhotosCount
    case cancelled
    case success
}

//MARK: - GBHFacebookImagePickerDelegate
extension SUConfirmPhotoViewController: GBHFacebookImagePickerDelegate {
    
    func facebookImagePicker(imagePicker: UIViewController, successImageModels: [GBHFacebookImage], errorImageModels: [GBHFacebookImage], errors: [Error?]) {
        print(successImageModels)
        
        var images = [UIImage]()
        for eachImage in successImageModels {
            if eachImage.image != nil {
                images.append(eachImage.image!)
            }
        }
        
        if images.count != 3 {
            self.fbSelectResult = .incorrectPhotosCount
        } else {
            self.fbSelectResult = .success
            DispatchQueue.main.async {
                self.presenter?.updatePhotos(withPhotos: images)
            }
        }
    
    }
    
    func facebookImagePicker(imagePicker: UIViewController,
                             didFailWithError error: Error?) {
        
        let delay = 3.0
        
        HUD.show(.labeledError(title: "FB Photos", subtitle: error?.localizedDescription))
        HUD.hide(afterDelay: delay)
        print(error?.localizedDescription ?? "")
        
        self.fbSelectResult = .cancelled
        
    }
    
    func facebookImagePicker(didCancelled imagePicker: UIViewController) {
        self.fbSelectResult = .cancelled
    }
    
    func facebookImagePickerDismissed() {
        switch self.fbSelectResult {
        case .cancelled:
            self.presenter?.dismissMe()
        case .incorrectPhotosCount:
            self.errorPhotosCount()
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDataSource
extension SUConfirmPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoViewCell
        guard cell != nil else {
            return UICollectionViewCell()
        }
        
        cell!.configureCell(withPhoto: profilePhotos[indexPath.row] , row: indexPath.row, allPhotos: profilePhotos.count)
        return cell!
    }
    
}

//MARK: - UICollectionViewDelegate
extension SUConfirmPhotoViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SUConfirmPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewFrame = collectionView.frame
        
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionViewFrame.width, height: collectionViewFrame.height * 0.7)
        case 1,2:
            return CGSize(width: collectionViewFrame.width / 2, height: collectionViewFrame.height * 0.3)
        default:
            return CGSize(width: collectionViewFrame.width / 2, height: collectionViewFrame.height / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
