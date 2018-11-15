//
//  ARProfileAnnotationView.swift
//  FlirtARViper
//
//  Created on 19.08.17.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD

protocol ARProfileAnnotationViewDelegate: class {
    func didTapClose()
    func didTapShowFullProfile(forUser user: ShortUser)
}

extension ARProfileAnnotationView: ARProfileDataHelperDelegate {
    func dataUpdated(user: ShortUser) {
        nameAgeLabel.text = (user.firstName ?? "No data")
            + ", "
            + (user.age ?? "No data")
        updatePhoto(photoString: user.photos.first?.url)
        if user.isLiked != nil {
            setLikeStatus(status: user.isLiked!)
        }
        introductionLabel.text = user.shortIntroduction
        if user.interests != nil {
            updateInterests(interestString: user.interests!)
        }
        
        selUser = user
        
    }
    
    func changeButtonVisibility(buttonType: ARButtonsType, isHidden: Bool) {
        switch buttonType {
        case .nextButton:
            nextButton.isHidden = isHidden
        case .previousButton:
            previousButton.isHidden = isHidden
        }
    }
}

class ARProfileAnnotationView: ARAnnotationView {
    
    
    //MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet var interestsView: [InterestItemView]!
    
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var backImageView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var likesView: LikesAnimationView!
    
    //MARK: - Variables
    fileprivate var markers: [Marker]?
    static var user: ShortUser?
    static var interests = [String]()
    static var isLiked = false
    static var selectedIndex = 0
    
    weak var delegate: ARProfileAnnotationViewDelegate?
    var selUser: ShortUser?
    
    //MARK: - Init
    override init() {
        super.init()
        
        let className = String(describing: type(of: self))
        _ = Bundle.main.loadNibNamed(className, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isInitial = true
    
    //MARK: - UIView
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        //configureUI()
        
        if isInitial {
            photoView.ovalImage()
            configureCircle()
            likesView.isHidden = true
            ARProfileDataHelper.shared.delegate = self
            isInitial = false
        }
        
        likesView.configureAnimation()
        
        guard let newMarkers = (annotation as? ARMarkerAnnotation)?.markers else {
            return
        }
        
        
        ARProfileDataHelper.shared.tryToUpdate(markers: newMarkers)
        
    }
    
    //MARK: - UI Customisation
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
    
    //MARK: - Fill data methods
    fileprivate func updatePhoto(photoString: String?) {
        if let photoString = photoString {
            let imageURL = URL(string: photoString)
            photoView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            photoView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    fileprivate func setLikeStatus(status: Bool) {
        if status {
            self.likeButton.setImage(#imageLiteral(resourceName: "dislikeButton"), for: .normal)
            self.likesView.isHidden = false
        } else {
            self.likeButton.setImage(#imageLiteral(resourceName: "likeButton"), for: .normal)
            self.likesView.isHidden = true
        }
    }
    
    fileprivate func updateInterests(interestString: String) {
        let interestsArrayByComma = interestString.components(separatedBy: ",")
        let interestsArrayBySpace = interestString.components(separatedBy: " ")
        
        var interests = [String]()
        
        if interestsArrayByComma.count >= interestsArrayBySpace.count {
            interests = Array(interestsArrayByComma.prefix(3)).filter{$0 != ""}
        } else {
            interests = Array(interestsArrayBySpace.prefix(3)).filter{$0 != ""}
        }
        
        for i in 0..<interests.count {
            let interestView = interestsView[i]
            interestView.isHidden = false
            
            var title = interests[i]
            if i == interestsView.count - 1 && interestsArrayByComma.count > 3 {
                title += "..."
            }
            
            interestView.title = title
            interestView.itemTextColor = UIColor.white
            interestView.itemTextFont = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        }
        
        if interests.count < 3 {
            for j in interests.count..<interestsView.count {
                let interestView = interestsView[j]
                interestView.isHidden = true
            }
        }
        
    }
    
    //MARK: - Actions
    @IBAction func moreInfoTap(_ sender: Any) {
        guard let selectedUser = selUser else {
            return
        }
        delegate?.didTapShowFullProfile(forUser: selectedUser)
    }
    
    @IBAction func closeButtonTap(_ sender: Any) {
        delegate?.didTapClose()
    }
    
    @IBAction func likeButtonTap(_ sender: Any) {
        ARProfileDataHelper.shared.changeLikeStatus()
    }
    
    
    @IBAction func nextButtonTap(_ sender: Any) {
        ARProfileDataHelper.shared.nextMarker()
    }
    
    @IBAction func previousButtonTap(_ sender: Any) {
        ARProfileDataHelper.shared.previousMarker()
    }
    
}
