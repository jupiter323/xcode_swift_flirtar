//
//  ARAnnotationView.swift
//  FlirtARViper
//
//  Created on 12.08.17.
//

import UIKit
import SDWebImage

protocol ARMarkerAnnotationViewDelegate: class {
    func didTouchMarker(annotationView: ARMarkerAnnotationView)
}


class ARMarkerAnnotationView: ARAnnotationView {

    //MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var imageBackView: UIView!
    
    @IBOutlet weak var markersCountView: UIView!
    @IBOutlet weak var markersCountLabel: UILabel!
    
    //MARK: - Variables
    weak var delegate: ARMarkerAnnotationViewDelegate?
    var markers: [Marker]?
    var isInitial = true
    
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
    
    
    //MARK: - UIView
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        
        photoView.ovalImage()
        markersCountView.round()
        markersCountView.isHidden = true
        
        if isInitial {
            configureCircle()
            isInitial = false
        }
        
        if let annotation = annotation as? ARMarkerAnnotation {
            
            if let markerCount = annotation.markers?.count {
                if markerCount > 1 {
                    markersCountLabel.text = "\(markerCount)"
                    markersCountView.isHidden = false
                } else {
                    markersCountView.isHidden = true
                }
            } else {
                markersCountView.isHidden = true
            }
            
            titleLabel.text = annotation.title
            
            if let photoString = annotation.markers?.first?.user?.photo?.thumbnailUrl {
                let imageURL = URL(string: photoString)
                photoView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            } else {
                photoView.image = #imageLiteral(resourceName: "placeholder")
            }
            
            self.markers = annotation.markers
            
        }
    }
    
    private func configureCircle() {
        photoView.layoutIfNeeded()
        imageBackView.layoutIfNeeded()
        
        let centerPoint = photoView.center
        let radius = photoView.bounds.height / 2 + 3.0
        let color = UIColor(red: 235/255,
                            green: 65/255,
                            blue: 91/255,
                            alpha: 0.5).cgColor
        
        imageBackView.addCircle(centerPoint: centerPoint,
                                radius: radius,
                                color: color)
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouchMarker(annotationView: self)
    }
    
}
