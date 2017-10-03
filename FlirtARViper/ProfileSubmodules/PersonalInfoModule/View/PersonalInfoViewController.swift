//
//  PersonalInfoViewController.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol PersonalInfoViewControllerDelegate: class {
    func heightChanged(newValue: CGFloat)
}

class PersonalInfoViewController: UIViewController, PersonalInfoViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var userNameField: TitledInputView!
    @IBOutlet weak var dateOfBirthField: TitledInputView!
    @IBOutlet weak var genderSwitcher: GenderSwitcher!
    @IBOutlet weak var introductionField: TitledInputView!
    @IBOutlet weak var interestsField: TitledInputWithTagsView!
    
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Constraints
    
    @IBOutlet weak var interestsBlockHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBlockHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    fileprivate var datePicker: DatePicker!
    fileprivate var deltaAutocomplete: CGFloat!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        
        datePicker = DatePicker()
        deltaAutocomplete = 0.0
        
        super.viewDidLoad()
        configureDateOfBirthPicker()
        configureTextFieldDelegates()
        configureSwitcherDelegate()
        
        
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    //MARK: - Helpers
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        let _ = userNameField.resignFirstResponder()
        let _ = dateOfBirthField.resignFirstResponder()
        let _ = genderSwitcher.resignFirstResponder()
        let _ = introductionField.resignFirstResponder()
        let _ = interestsField.resignFirstResponder()
    }
    
    private func configureDateOfBirthPicker() {
        
        dateOfBirthField.inputField.inputView = datePicker
        dateOfBirthField.inputField.tintColor = UIColor.clear
        dateOfBirthField.inputField.delegate = self
        
        datePicker.addTarget(self, action: #selector(actionDatePickerValueChanged(_:)), for: .valueChanged)
        
        
    }
    
    private func configureTextFieldDelegates() {
        userNameField.inputField.delegate = self
        introductionField.inputField.delegate = self
        interestsField.delegate = self
    }
    
    private func configureSwitcherDelegate() {
        genderSwitcher.delegate = self
    }
    
    func actionDatePickerValueChanged(_ sender: UIDatePicker) {
        dateOfBirthField.text = String.formattedString(from: sender.date)
        presenter?.saveDateOfBirth(dateOfBirth: sender.date)
    }
    
    fileprivate func saveData(fromField textField: UITextField) {
        if textField == userNameField.inputField {
            presenter?.saveUsername(username: (textField.text))
        } else if textField == introductionField.inputField {
            presenter?.saveIntroduction(introduction: textField.text)
        }
    }
    
    fileprivate func saveDataInterests(interests: String) {
        presenter?.saveInterests(interests: interests)
    }
    
    //MARK: - PersonalInfoViewProtocol
    var presenter: PersonalInfoPresenterProtocol?
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    func fillFieldsWithUser(user: User) {
        
        if let username = user.firstName {
            userNameField.text = username
        }
        if let birthday = user.birthday {
            dateOfBirthField.text = DateFormatter.inputViewDateFormatter.string(from: birthday)
            datePicker.date = birthday
        }
        if let gender = user.gender {
            genderSwitcher.selectedGender = gender
        }
        if let introduction = user.shortIntroduction {
            introductionField.text = introduction
        }
        if let interests = user.interests {
            interestsField.fillTags(tags: interests)
        }
        
    }
    

}

//MARK: - UITextFieldDelegate
extension PersonalInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //date not editable by keyboard
        if textField == dateOfBirthField.inputField {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //route for next field
        if textField == userNameField.inputField {
            let clearedText = BadWordHelper.shared.cleanUp(userNameField.text!)
            userNameField.text = clearedText
            let _ = dateOfBirthField.inputField.becomeFirstResponder()
        } else if textField == introductionField.inputField {
            let clearedText = BadWordHelper.shared.cleanUp(introductionField.text!)
            introductionField.text = clearedText
            let _ = interestsField.inputField.becomeFirstResponder()
        } else if textField == interestsField.inputField {
            let _ = interestsField.inputField.resignFirstResponder()
        }
        
        saveData(fromField: textField)
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == userNameField.inputField {
            let clearedText = BadWordHelper.shared.cleanUp(userNameField.text!)
            userNameField.text = clearedText
        } else if textField == introductionField.inputField {
            let clearedText = BadWordHelper.shared.cleanUp(introductionField.text!)
            introductionField.text = clearedText
        }
        saveData(fromField: textField)
    }
}

//MARK: - GenderSwitherDelegate
extension PersonalInfoViewController: GenderSwitherDelegate {
    func valueChanged(switcher: GenderSwitcher) {
        presenter?.saveGender(gender: switcher.selectedGender)
    }
}

//MARK: - TitledInputWithTagsViewDelegate
extension PersonalInfoViewController: TitledInputWithTagsViewDelegate {
    func saveInterests(interests: String) {
        saveDataInterests(interests: interests)
    }
    
    func heightChangedToValue(value: CGFloat) {
        viewBlockHeight.constant = 380.0 + value
        interestsBlockHeight.constant = value
        delegate?.heightChanged(newValue: viewBlockHeight.constant)
        
    }
    
    func showAutocompleteTable() {
        
        print("INTE H: \(interestsBlockHeight.constant)")
        
        let neededHeight = 20.0 + 64.0 + (40.0 * 4.0)
        let newVal = CGFloat(neededHeight) - interestsBlockHeight.constant
        deltaAutocomplete = newVal
        
        if newVal > 0 {
            viewBlockHeight.constant = viewBlockHeight.constant + newVal
            interestsBlockHeight.constant = interestsBlockHeight.constant + newVal
            delegate?.heightChanged(newValue: viewBlockHeight.constant)
        }
    }
    
    func hideAutocompleteTable() {
        if deltaAutocomplete > 0 {
            viewBlockHeight.constant = viewBlockHeight.constant - deltaAutocomplete
            interestsBlockHeight.constant = interestsBlockHeight.constant - deltaAutocomplete
            delegate?.heightChanged(newValue: viewBlockHeight.constant)
        }
    }
    
    
    
}
