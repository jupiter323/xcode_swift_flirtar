//
//  AssetService.swift
//  FlirtARViper
//
//  Created by on 30.08.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Photos

class AssetHelper {
    
    static func resolveAssets(_ assets: [PHAsset], size: CGSize = CGSize(width: 720, height: 1280)) -> [UIImage] {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.version = .unadjusted
        requestOptions.deliveryMode = .fastFormat
        requestOptions.resizeMode = .fast
        
        var images = [UIImage]()
        for asset in assets {
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
                if let image = image {
                    images.append(image)
                }
            }
        }
        
        return images
    }
    
    
}
