//
//  RangeView.swift
//  FlirtAR
//
//  Created by user on 7/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

struct RangeModel {
    var start: Int
    var end: Int
}

protocol RangeViewDelegate: class {
    func valueChanged(rangeView: RangeView)
}

var defaultRangeStart: Int {
    get { return 18 }
}
var defaultRangeEnd: Int {
    get { return 65 }
}

class RangeView: ViewFromXIB {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var endLabel: UILabel!
    @IBOutlet private weak var startView: UIView!
    @IBOutlet private weak var endView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    //MARK: - Variables
    
    let borderWidth: CGFloat = 1.0
    
    var range = RangeModel(start: defaultRangeStart, end: defaultRangeEnd) {
        didSet {
            startLabel.text = String(range.start)
            endLabel.text = String(range.end)
            delegate?.valueChanged(rangeView: self)
        }
    }
    
    var isActive: Bool = false {
        didSet {
            if oldValue == isActive {
                return
            }
            if isActive {
                startView.setActiveBorders()
                endView.setActiveBorders()
            } else {
                startView.setPassiveBorders()
                endView.setPassiveBorders()
            }
        }
    }
    
    weak var delegate: RangeViewDelegate?
    
    //MARK: - Configuration
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        startView.setPassiveBorders()
        endView.setPassiveBorders()
        
        startView.round()
        endView.round()
        
        
        startLabel.text = String(selectedStart)
        endLabel.text = String(selectedEnd)
        
        inputTextField.delegate = self
        
        let selectedRange = RangeModel(start: selectedStart, end: selectedEnd)
        range = selectedRange
        
        let initialRange = RangeModel(start: rangeStart, end: rangeEnd)
        let rangePickerView = RangePickerView(withInitialRange: initialRange,
                                              withSelectedRange: selectedRange)
        
        rangePickerView.dataSource = self
        rangePickerView.delegate = self
        
        inputTextField.inputView = rangePickerView
        
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var rangeStart: Int = defaultRangeStart {
        didSet {
            startLabel.text = String(rangeStart)
            range = RangeModel(start: rangeStart, end: rangeEnd)
            
        }
    }
    
    @IBInspectable var rangeEnd: Int = defaultRangeEnd {
        didSet {
            endLabel.text = String(rangeEnd)
            range = RangeModel(start: rangeStart, end: rangeEnd)
        }
    }
    
    @IBInspectable var selectedStart: Int  = defaultRangeStart {
        didSet {
            if (selectedStart >= rangeStart && selectedStart <= rangeEnd) {
                startLabel.text = String(selectedStart)
            } else {
                selectedStart = rangeStart
                startLabel.text = String(rangeStart)
            }
        }
    }
    
    @IBInspectable var selectedEnd: Int = defaultRangeEnd {
        didSet {
            if (selectedEnd <= rangeEnd && selectedEnd >= rangeStart) {
                endLabel.text = String(selectedEnd)
            } else {
                selectedEnd = rangeEnd
                endLabel.text = String(rangeEnd)
            }
        }
    }
    
    

    
    
    
}

extension RangeView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isActive = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isActive = false
    }
    
}

extension RangeView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (rangeEnd-rangeStart) + 1
    }
}

extension RangeView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(rangeStart + row)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let firstComponentIndex = 0
        let lastComponentIndex = pickerView.numberOfComponents - 1
        
        var start = pickerView.selectedRow(inComponent: firstComponentIndex) + rangeStart
        let end = pickerView.selectedRow(inComponent: lastComponentIndex) + rangeStart
        
        if start > end {
            start = end
            pickerView.selectRow(end - rangeStart, inComponent: 0, animated: true)
        }
        
        range = RangeModel(start: start, end: end)
    }
    
}

