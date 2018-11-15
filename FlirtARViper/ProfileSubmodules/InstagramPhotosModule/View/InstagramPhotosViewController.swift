//
//  InstagramPhotosViewController.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import PKHUD

protocol InstagramPhotosViewControllerDelegate: class {
    func photosUpdated(moduleHeight: CGFloat,
                       photosCount: Int)
}

class InstagramPhotosViewController: UIViewController, InstagramPhotosViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var photosPageControl: UIPageControl!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    @IBOutlet weak var instagramCountView: UIView!
    @IBOutlet weak var instagramButtonView: UIView!
    
    @IBOutlet weak var instagramSwitchView: SwitchView!
    
    //Constraints
    @IBOutlet weak var photosCollectionHeight: NSLayoutConstraint!
    
    
    //MARK: - Variables
    fileprivate var photos = [Photo]() {
        willSet {
            
            delegate?.photosUpdated(moduleHeight: calculateModuleHeight(elementsCount: newValue.count),
                                    photosCount: newValue.count)
            
            if newValue.count == 0 {
                photosCollectionHeight.constant = 0.0
            } else {
                photosCollectionHeight.constant = calculateCellWidth() + 10.0
            }
            
            photosCollectionView.layoutIfNeeded()
        }
    }
    
    weak var delegate: InstagramPhotosViewControllerDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instagramSwitchView.delegate = self
        instagramSwitchView.isOn = ProfileService.savedUser?.instagramConnected ?? false

        photosCollectionView.register(UINib(nibName: "InstagramPhotoViewCell", bundle: nil), forCellWithReuseIdentifier: "instagramPhotoViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        instagramCountView.isHidden = false
        instagramButtonView.isHidden = true
        
        presenter?.reloadPhotos()
        
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(self.instagramTokenChanged(_:)),
                         name: NSNotification.Name(NotificationName.postInstagramTokenChanged.rawValue),
                         object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    //MARK: - InstagramPhotosViewProtocol
    var presenter: InstagramPhotosPresenterProtocol?
    
    func showPhotos(photos: [Photo]) {
        
        instagramCountView.isHidden = false
        instagramButtonView.isHidden = true
        
        //top 12 photos
        let boundedPhotos = Array(photos.prefix(3 * 4))
        
        self.photos = boundedPhotos
        photosCollectionView.reloadData()
        
        if photos.count != 0 {
            photosCount.text = "\(photos.count) Instagram photos"
        } else {
            photosCount.text = "No Instagram photos"
        }
        let pages = Int(ceil(Double(boundedPhotos.count) / 3.0))
        photosPageControl.numberOfPages = pages
        
    }
    
    func showConnectButton() {
        instagramCountView.isHidden = true
        instagramButtonView.isHidden = false
        
        delegate?.photosUpdated(moduleHeight: 32.0,
                                photosCount: 0)
    }
    
    func showRequestError(method: String, errorMessage: String) {
        instagramSwitchView.isOn = false
    }
    
    //MARK: - Helpers
    func calculateModuleHeight(elementsCount: Int) -> CGFloat {
        
        let elementsHeightWithOffsets: CGFloat = 32.0
        
        if elementsCount == 0 {
            return 0.0//elementsHeightWithOffsets
        }
        
        //32 = label height + offsets
        photosCollectionView.layoutIfNeeded()
        let cellWidth = calculateCellWidth() + 10.0
        var totalHeight: CGFloat!
        if cellWidth <= 0 {
            totalHeight = 0.0
        } else {
            totalHeight = cellWidth + elementsHeightWithOffsets
        }
        return totalHeight
        
    }
    
    func calculateCellWidth() -> CGFloat {
        return (photosCollectionView.bounds.width - 8.0 * 2.0 - 4.0 * 2.0) / 3.0
    }
    
    //MARK: - Observers
    @objc func instagramTokenChanged(_ notification: Notification) {
        presenter?.reloadPhotos()
    }
    
}

//MARK: - SwitchViewDelegate
extension InstagramPhotosViewController: SwitchViewDelegate {
    func valueChanged(switchView: SwitchView) {
        if switchView.isOn {
            presenter?.showInstagramAuth()
        }
    }
}

//MARK: - InstagramAuthDelegate
extension InstagramPhotosViewController: InstagramAuthDelegate {
    func authSuccess(token: String) {
        presenter?.instagramConnection(withToken: token)
    }
    
    func authFail(error: String) {
        instagramSwitchView.isOn = false
    }
}

//MARK: - UIScrollViewDelegate
extension InstagramPhotosViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let width = scrollView.bounds.size.width
        let currentPage = Int(ceil(offset/width))
        photosPageControl.currentPage = currentPage
    }
}

//MARK: - UICollectionViewDataSource
extension InstagramPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "instagramPhotoViewCell",
                                                      for: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension InstagramPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let instagramCell = cell as? InstagramPhotoViewCell
        instagramCell?.configureWithPhotoString(photo: photos[indexPath.row])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension InstagramPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //3 columns
        let cellWidth = (collectionView.bounds.width - 8.0 * 2.0 - 4.0 * 2.0) / 3.0
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
    
    //No spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0,4,0,4);  // top, left, bottom, right
    }
}





