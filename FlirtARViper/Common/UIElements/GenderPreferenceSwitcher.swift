//
//  GenderPreferenceSwitcher.swift
//  FlirtARViper
//
//  Created on 04.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol GenderPreferenceSwitcherDelegate: class {
    func valueChanged(switcher: GenderPreferenceSwitcher)
}



class GenderPreferenceSwitcher: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    
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
    
    @IBInspectable var bothItem: String = "Both" {
        didSet {
            bothButton.setTitle(bothItem, for: .normal)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if selectedGender == .female {
            currentSelectedButton = femaleButton
        } else if selectedGender == .male {
            currentSelectedButton = maleButton
        } else {
            currentSelectedButton = bothButton
        }
        
    }
    
    var selectedGender: GenderPreference = .female
    
    //MARK: - Private
    private let selectedImage = #imageLiteral(resourceName: "selectedGender")
    private let unselectedImage = #imageLiteral(resourceName: "unselectedGender")
    
    private var currentSelectedButton: UIButton! {
        didSet {
            
            femaleButton.setImage(unselectedImage, for: .normal)
            maleButton.setImage(unselectedImage, for: .normal)
            bothButton.setImage(unselectedImage, for: .normal)
            
            if selectedGender == .female {
                femaleButton.setImage(selectedImage, for: .normal)
                maleButton.setImage(unselectedImage, for: .normal)
                bothButton.setImage(unselectedImage, for: .normal)
            } else if selectedGender == .male {
                femaleButton.setImage(unselectedImage, for: .normal)
                maleButton.setImage(selectedImage, for: .normal)
                bothButton.setImage(unselectedImage, for: .normal)
            } else {
                femaleButton.setImage(unselectedImage, for: .normal)
                maleButton.setImage(unselectedImage, for: .normal)
                bothButton.setImage(selectedImage, for: .normal)
            }
            delegate?.valueChanged(switcher: self)
        }
    }
    
    //MARK: - Public
    
    weak var delegate: GenderPreferenceSwitcherDelegate?
    
    var selectedItem: String? {
        return currentSelectedButton.currentTitle
    }
    
    //MARK: - Actions
    @IBAction func actionSelectItem(_ sender: UIButton) {
        if sender == femaleButton {
            selectedGender = .female
        } else if sender == maleButton {
            selectedGender = .male
        } else {
            selectedGender = .both
        }

        currentSelectedButton = sender
    }
}
