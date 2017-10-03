//
//  UICollectionView+Extensions.swift
//  FlirtARViper
//
//  Created by  on 20.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


extension UICollectionView {
    func scrollToBottom() {
        let items = self.numberOfItems(inSection: 0)
        if items > 0 {
            self.scrollToItem(at: IndexPath(row: items - 1, section: 0), at: .bottom, animated: true)
        }
    }
}
