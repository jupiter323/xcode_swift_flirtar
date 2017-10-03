//
//  UIImageView+Extensions.swift
//  FlirtARViper
//
//  Created by on 11.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

extension UIImageView {
    func ovalImage() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
    }
}
