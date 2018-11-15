//
//  Collection+Extensions.swift
//  FlirtARViper
//
//  Created by   on 02.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Generator.Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
}
