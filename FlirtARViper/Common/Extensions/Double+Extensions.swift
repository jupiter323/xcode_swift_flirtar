//
//  Double+Extensions.swift
//  FlirtARViper
//
//  Created by   on 07.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation

extension Double {
    func roundTo(symbols: Int) -> Double {
        let divisor = pow(10.0, Double(symbols))
        return (self * divisor).rounded() / divisor
    }
}
