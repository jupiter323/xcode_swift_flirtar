//
//  GenderSwitcher.swift
//  FlirtARViper
//
//  Created by   on 03.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

protocol GenderSwitherDelegate: class {
    func valueChanged(switcher: GenderSwitcher)
}

class GenderSwitcher: ViewFromXIB {
    
    
    
    //MARK: - Outlets
    @IBOutlet private var femaleButton: UIButton!
    @IBOutlet private var maleButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    //MARK: Configuration
    @IBInspectable var title: String = "" {
        didSet{
            self.titleLabel.text = title
        }
    }
    @IBInspectable var femaleItem: String = "Woman" {
        didSet {
            femaleButton.setTitle(femaleItem, for: .normal)
        }
    }
    @IBInspectable var maleItem: String = "Man" {
        didSet {
            maleButton.setTitle(maleItem, for: .normal)
        }
    }
    
    @IBInspectable var isChangeable: Bool = true {
        didSet {
            if isChangeable == false {
                isUserInteractionEnabled = false
                selectedImage = #imageLiteral(resourceName: "genderFillInactive")
                unselectedImage = #imageLiteral(resourceName: "genderEmptyInactive")
            } else {
                isUserInteractionEnabled = true
                selectedImage = #imageLiteral(resourceName: "selectedGender")
                unselectedImage = #imageLiteral(resourceName: "unselectedGender")
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if selectedGender == .female {
            currentSelectedButton = femaleButton
        } else {
            currentSelectedButton = maleButton
        }
        
    }
    
    var selectedGender: Gender = .female
    
    //MARK: - Private
    private var selectedImage = #imageLiteral(resourceName: "selectedGender")
    private var unselectedImage = #imageLiteral(resourceName: "unselectedGender")
    
    private var currentSelectedButton: UIButton! {
        didSet {
            
            femaleButton.setImage(unselectedImage, for: .normal)
            maleButton.setImage(unselectedImage, for: .normal)
            
            if selectedGender == .female {
                femaleButton.setImage(selectedImage, for: .normal)
                maleButton.setImage(unselectedImage, for: .normal)
            } else {
                femaleButton.setImage(unselectedImage, for: .normal)
                maleButton.setImage(selectedImage, for: .normal)
            }
            delegate?.valueChanged(switcher: self)
        }
    }
    
    //MARK: - Public
    
    weak var delegate: GenderSwitherDelegate?
    
    var selectedItem: String? {
        return currentSelectedButton.currentTitle
    }
    
    //MARK: - Actions
    @IBAction func actionSelectItem(_ sender: UIButton) {
        
        if sender == femaleButton {
            selectedGender = .female
        } else {
            selectedGender = .male
        }
        
//        if selectedGender == .female {
//            selectedGender = .male
//        } else {
//            selectedGender = .female
//        }
        currentSelectedButton = sender
    }
}
