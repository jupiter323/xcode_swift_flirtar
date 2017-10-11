//
//  ARShortProfileViewController.swift
//  FlirtARViper
//
//  Created by on 16.08.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD

protocol ARShortProfileViewControllerDelegate: class {
    func removeFromParentTapped()
}

class ARShortProfileViewController: UIViewController, ARShortProfileViewProtocol {
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var interestsCollection: UICollectionView!
    
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var backImageView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var likesView: LikesAnimationView!
    
    //MARK: - Variables
    fileprivate var isLiked = false
    fileprivate var interests = [String]()
    
    weak var delegate: ARShortProfileViewControllerDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.ovalImage()
        configureCircle()
        likesView.isHidden = true
        
        interestsCollection.register(UINib(nibName: "InterestViewCell", bundle: nil), forCellWithReuseIdentifier: "interestsShortItem")
        
        interestsCollection.dataSource = self
        interestsCollection.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureCircle() {
        backImageView.layoutIfNeeded()
        
        let centerPoint = photoView.center
        let radius = photoView.bounds.height / 2 + 3.0
        let color = UIColor(red: 235/255,
                            green: 65/255,
                            blue: 91/255,
                            alpha: 0.5).cgColor
        
        backImageView.addCircle(centerPoint: centerPoint,
                                radius: radius,
                                color: color)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        
        likesView.configureAnimation()
        
    }
    
    //MARK: - Actions
    
    @IBAction func moreInfoButtonTap(_ sender: Any) {
        presenter?.showFullInfo()
    }
    
    @IBAction func nextUserTap(_ sender: Any) {
        presenter?.showNextUser()
    }
    
    @IBAction func previousUserTap(_ sender: Any) {
        presenter?.showPreviousUser()
    }
    
    @IBAction func likeTap(_ sender: Any) {
        presenter?.startSetLike()
    }
    
    @IBAction func closeTap(_ sender: Any) {
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        delegate?.removeFromParentTapped()
        
    }
    
    
    
    
    //MARK: - ARShortProfileViewProtocol
    var presenter: ARShortProfilePresenterProtocol?
    
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.loading.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showError(errorMessage: String) {
        HUD.show(.labeledError(title: "Error", subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showButtons(buttons: [ARProfileButton]) {
        for eachButtonType in buttons {
            switch eachButtonType {
            case .next:
                nextButton.isHidden = false
            case .previous:
                previousButton.isHidden = false
            }
        }
    }
    
    func hideButtons(buttons: [ARProfileButton]) {
        for eachButtonType in buttons {
            switch eachButtonType {
            case .next:
                nextButton.isHidden = true
            case .previous:
                previousButton.isHidden = true
            }
        }
    }
    
    func showShortProfile(profile: ShortUser) {
        
        if let photo = profile.photos.first {
            if let photoLink = photo.url {
                let photoURL = URL(string: photoLink)
                photoView.sd_setImage(with: photoURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            } else {
                photoView.image = #imageLiteral(resourceName: "placeholder")
            }
        } else {
            photoView.image = #imageLiteral(resourceName: "placeholder")
        }
        
        nameAgeLabel.text = (profile.firstName ?? "No data") + ", " + (profile.age ?? "No data")
        let interestsString = profile.interests ?? ""
        let interestsArrayByComma = interestsString.components(separatedBy: ",")
        let interestsArrayBySpace = interestsString.components(separatedBy: " ")
        
        if interestsArrayByComma.count >= interestsArrayBySpace.count {
            interests = interestsArrayByComma.filter{$0 != ""}
        } else {
            interests = interestsArrayBySpace.filter{$0 != ""}
        }
        
        if interests.count > 3 {
            interests[2] += "..."
        }
        
        interestsCollection.reloadData()
        
        introductionLabel.text = profile.shortIntroduction ?? "No data"
        
        guard let isLiked = profile.isLiked else {
            likeButton.setImage(#imageLiteral(resourceName: "likeButton"), for: .normal)
            return
        }
        
        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "dislikeButton"), for: .normal)
            likesView.isHidden = false
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "likeButton"), for: .normal)
            likesView.isHidden = true
        }
        
        self.isLiked = isLiked
        
    }
    
    func likeStatusChanged() {
        self.isLiked = !self.isLiked
        if isLiked {
            likesView.isHidden = false
            likeButton.setImage(#imageLiteral(resourceName: "dislikeButton"), for: .normal)
        } else {
            likesView.isHidden = true
            likeButton.setImage(#imageLiteral(resourceName: "likeButton"), for: .normal)
        }
    }

}

//MARK: - UICollectionViewDataSource
extension ARShortProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestsShortItem", for: indexPath)
        return cell
        
    }
    
}

//MARK: - UICollectionViewDelegate
extension ARShortProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        let interestCell = cell as? InterestViewCell
        guard interestCell != nil else { return }
        interestCell!.configureCell(withInterest: interests[indexPath.row],
                                    maxFontSize: 13.0,
                                    fontColor: UIColor.white,
                                    fontName: "VarelaRound")
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ARShortProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //3 columns
        let cellWidth = collectionView.bounds.width / 3.0
        let cellHeight = collectionView.bounds.height
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
