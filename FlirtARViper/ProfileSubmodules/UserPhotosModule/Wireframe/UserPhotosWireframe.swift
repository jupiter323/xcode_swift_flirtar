//
//  UserPhotosWireframe.swift
//  FlirtARViper
//
//  Created by  on 08.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

enum UserPhotosSliderOrientation {
    case vertical
    case horizontal
}

enum PhotoContainerType {
    case arProfile
    case settingsProfile
}

class UserPhotosWireframe {
    
    static func configurePhotosController(withPhotos photos: [Photo],
                                          orientation: UserPhotosSliderOrientation,
                                          containerType: PhotoContainerType?,
                                          distance: CGFloat?) -> UIViewController {
        
        if orientation == .horizontal {
            
            
            let photosController = UIStoryboard(name: "UserPhotosModule", bundle: nil).instantiateViewController(withIdentifier: "HorizontalViewController")
            
            if let view = photosController as? HorizontalViewController {
                view.configure(withPhotos: photos,
                               containerType: containerType,
                               distance: distance)
                return view
            }
            
            
        } else if orientation == .vertical {
            let photosController = UIStoryboard(name: "UserPhotosModule", bundle: nil).instantiateViewController(withIdentifier: "VerticalViewController")
            
            if let view = photosController as? VerticalViewController {
                view.configure(withPhotos: photos)
                return view
            }
            
        }
        
        return UIViewController()
        
    }
}
