//
//  PersonalPreferenceViewController.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class PersonalPreferenceViewController: UIViewController, PersonalPreferenceViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var lookingGenderSwitcher: GenderPreferenceSwitcher!
    @IBOutlet weak var ageRangeView: RangeView!
    
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSwitcherDelegate()
        configureRangeDelegate()
        
        presenter?.viewDidLoad()
    }
    
    //MARK: - Helpers
    private func configureSwitcherDelegate() {
        lookingGenderSwitcher.delegate = self
    }
    
    private func configureRangeDelegate() {
        ageRangeView.delegate = self
    }
    
    
    //MARK: - PersonalPreferenceViewProtocol
    var presenter: PersonalPreferencePresenterProtocol?
    func fillFieldsWithUser(user: User) {
        if let genderPreferences = user.genderPreferences {
            lookingGenderSwitcher.selectedGender = genderPreferences
        }
        
        if  let minAge = user.minAge,
            let maxAge = user.maxAge {
            ageRangeView.selectedStart = minAge
            ageRangeView.selectedEnd = maxAge
            
        }
    }
}

extension PersonalPreferenceViewController: GenderPreferenceSwitcherDelegate {
    func valueChanged(switcher: GenderPreferenceSwitcher) {
        presenter?.saveLookingGender(gender: switcher.selectedGender)
    }
}

extension PersonalPreferenceViewController: RangeViewDelegate {
    func valueChanged(rangeView: RangeView) {
        presenter?.saveLookingRange(range: rangeView.range)
    }
}
