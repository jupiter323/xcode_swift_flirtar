//
//  RangePickerView.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class RangePickerView: UIPickerView {
    
    //MARK: - Private
    
    private var defaultRange: RangeModel!
    private var selectedRange: RangeModel!
    
    //MARK: - Configuration
    
    convenience init(withInitialRange range: RangeModel,
                     withSelectedRange newSelectedRange: RangeModel) {
        self.init(frame: CGRect.zero)
        defaultRange = range
        selectedRange = newSelectedRange
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        selectRow((selectedRange.start - defaultRange.start), inComponent: 0, animated: false)
        selectRow((defaultRange.end - defaultRange.start) - (defaultRange.end - selectedRange.end), inComponent: 1, animated: false)
        
        self.showsSelectionIndicator = true
        self.backgroundColor = UIColor.white
        
        //Add center line view
        let height: CGFloat = 1.0
        let width: CGFloat = 10.0
        
        let x = bounds.midX - width / 2.0
        let y = bounds.midY - height / 2.0
        
        let lineFrame = CGRect(x: x, y: y, width: width, height: height)
        
        let centerLineView = UIView(frame: lineFrame)
        
        centerLineView.backgroundColor = UIColor.lightGray
        
        addSubview(centerLineView)

    }
    
}
