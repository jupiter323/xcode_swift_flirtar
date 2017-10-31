//
//  MarkerInfoView.swift
//  FlirtARViper
//
//  Created by  on 09.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import SDWebImage

class MarkerInfoView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet private weak var avaImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func configureMarker(withUser marker: Marker,
                         completionHandler: @escaping (_ complete: Bool) -> ()) {
        
        self.view!.superview?.backgroundColor = UIColor.clear
        
        avaImage.layoutIfNeeded()
        avaImage.layer.cornerRadius = avaImage.bounds.size.width / 2
        avaImage.clipsToBounds = true
        
        let user = marker.user
        if user != nil {
            if let imageLink = user!.photo?.thumbnailUrl {
                let imageUrl = URL(string: imageLink)
                
                avaImage.sd_setImage(with: imageUrl,
                                     placeholderImage: #imageLiteral(resourceName: "placeholder"),
                                     options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageUrl) in
                        completionHandler(true)
                })
                
            }
            nameLabel.text = user!.firstname
            ageLabel.text = user!.age
        }
        
        let location = marker.location
        
        if location != nil && location?.modified != nil {
            let nowDate = Date()
            let months = nowDate.months(from: location!.modified!)
            let weeks = nowDate.weeks(from: location!.modified!)
            let days = nowDate.days(from: location!.modified!)
            let hours = nowDate.hours(from: location!.modified!)
            let minutes = nowDate.minutes(from: location!.modified!)
            let seconds = nowDate.seconds(from: location!.modified!)
            
            if months != 0 {
                timeLabel.text = "\(months) months ago"
            } else if weeks != 0 {
                timeLabel.text = "\(weeks) weeks ago"
            } else if days != 0 {
                timeLabel.text = "\(days) days ago"
            } else if hours != 0 {
                timeLabel.text = "\(hours) hours ago"
            } else if minutes != 0 {
                timeLabel.text = "\(minutes) minutes ago"
            } else if seconds != 0 {
                timeLabel.text = "\(seconds) seconds ago"
            }
            
            
        }
        
        
    }
    
    
}
