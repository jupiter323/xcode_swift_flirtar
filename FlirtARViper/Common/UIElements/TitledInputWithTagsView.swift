//
//  TitledInputWithTagsView.swift
//  FlirtARViper
//
//  Created by on 02.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol TitledInputWithTagsViewDelegate: class {
    func heightChangedToValue(value: CGFloat)
    func showAutocompleteTable()
    func hideAutocompleteTable()
    func saveInterests(interests: String)
}


class TitledInputWithTagsView: ViewFromXIB {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var inputField: InputTextField!
    @IBOutlet weak var interestsTagList: TagListView!
    @IBOutlet weak var autoCompleteTable: UITableView!
    @IBOutlet weak var autoCompleteShadow: UIView!
    
    //MARK: - Constraints
    @IBOutlet weak var tagListHeight: NSLayoutConstraint!
    @IBOutlet weak var autoCompleteHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    weak var delegate: TitledInputWithTagsViewDelegate?
    var suggestions = [String]()
    var allData = [String]()
    
    //MARK: Configuration
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var subTitleString: String? = "" {
        didSet {
            subTitleLabel.text = subTitleString
        }
    }
    
    @IBInspectable var inputPlaceholder: String? = "" {
        didSet {
            inputField.placeholder = inputPlaceholder
        }
    }
    
    @IBInspectable var text: String? {
        set{
            inputField.text = newValue
        }
        get{
            return inputField.text
        }
    }
    
    override func resignFirstResponder() -> Bool {
        return inputField.resignFirstResponder()
    }
    
    
    //MARK: - Init
    override func awakeFromNib() {
        
        //Load data for suggestions (tableview)
        loadInterestBase()
        
        //Set delegates and update layouts
        inputField.delegate = self
        interestsTagList.delegate = self
        interestsTagList.layoutIfNeeded()
        interestsTagList.layoutSubviews()
        inputField.layoutIfNeeded()
        
        //Change views z index
        view.bringSubview(toFront: autoCompleteShadow)
        view.bringSubview(toFront: autoCompleteTable)
        view.bringSubview(toFront: inputField)
        
        //Configure tableview
        configureSuggestionDropdown()
        
    }
    
    private func configureSuggestionDropdown() {
        autoCompleteTable.isHidden = true
        autoCompleteShadow.isHidden = true
        
        autoCompleteTable.layer.cornerRadius = 3.0
        autoCompleteTable.clipsToBounds = true
        
        autoCompleteTable.layoutIfNeeded()
        autoCompleteShadow.layoutIfNeeded()
        autoCompleteShadow.dropShadow()
        
        autoCompleteTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: inputField.bounds.width, height: 20))
        
        autoCompleteTable.register(UINib(nibName: "AutoCompleteCell", bundle: nil), forCellReuseIdentifier: "customAutoCell")
    }
    
    //Fill existing tags to view
    func fillTags(tags: String) {
        if !tags.isEmpty {
            let tagsArray = tags.components(separatedBy: ",")
            for eachTag in tagsArray {
                let exsistingTags = interestsTagList.getTagsText()
                if !(exsistingTags.contains(eachTag)) {
                    interestsTagList.addTag(eachTag)
                }
            }
        }
        updateConstraintsAndData()
    }
    
    
    
    //MARK: - Helpers
    //Update constraints and data
    fileprivate func updateConstraintsAndData() {
        delegate?.heightChangedToValue(value: interestsTagList.intrinsicContentSize.height + 20.0 + 44.0 + 1.0 + 8.0)
        tagListHeight.constant = interestsTagList.intrinsicContentSize.height
        let interestsArray = interestsTagList.getTagsText()
        let interestsString = interestsArray.joined(separator: ",")
        delegate?.saveInterests(interests: interestsString)
    }
    
    //Select item from dropdown
    func suggestionSelected(_ sender: UIButton) {
        let index = sender.tag
        
        if !(interestsTagList.getTagsText().contains(suggestions[index])) {
            interestsTagList.addTag(suggestions[index])
            inputField.text = ""
            
            if autoCompleteTable.isHidden != true {
                delegate?.hideAutocompleteTable()
            }
            
            autoCompleteTable.isHidden = true
            autoCompleteShadow.isHidden = true
            
            updateConstraintsAndData()
        }
    }
    
    
    //Load suggestion database from file
    private func loadInterestBase() {
        
        let request = APIRouter.getInterestsBase()
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if js != nil {
                    self.allData = APIParser().parseStringsArray(js: js!)
                }
        }
        
        //TODO: Previous version for local file
//        if let rtfPath = Bundle.main.url(forResource: "interestsF", withExtension: "rtf") {
//            do {
//                let attrString = try NSAttributedString(url: rtfPath, options: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType], documentAttributes: nil)
//                let wordsArr = attrString.string.components(separatedBy: CharacterSet.newlines)
//                allData = wordsArr
//            } catch {
//                print("error while loading interests")
//            }
//        }
    }
    
    //Find suggestions in loaded base
    fileprivate func getAutocompleteData(forSubstring: String) {
        var results = [String]()
        
        for eachData in allData {
            if eachData.lowercased().hasPrefix(forSubstring.lowercased()) {
                results.append(eachData)
            }
        }
        
        if results.count != 0 {
            suggestions = results
            autoCompleteTable.reloadData()
            
            if autoCompleteTable.isHidden != false {
                delegate?.showAutocompleteTable()
            }
            
            autoCompleteTable.isHidden = false
            autoCompleteShadow.isHidden = false
            
        } else {
            
            if autoCompleteTable.isHidden != true {
                delegate?.hideAutocompleteTable()
            }
            
            autoCompleteTable.isHidden = true
            autoCompleteShadow.isHidden = true
            
        }
        
    }
    
    //MARK: - Actions
    @IBAction func inputChanged(_ sender: Any) {
        if !inputField.text!.isEmpty {
            getAutocompleteData(forSubstring: inputField.text!)
        } else {
            if autoCompleteTable.isHidden != true {
                delegate?.hideAutocompleteTable()
            }
            
            autoCompleteShadow.layoutSubviews()
            autoCompleteTable.isHidden = true
            autoCompleteShadow.isHidden = true
        }
    }
    
    
}

//MARK: - UITableViewDelegate
extension TitledInputWithTagsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let autoCompleteCell = cell as? AutoCompleteCell else {
            return
        }
        
        autoCompleteCell.dataLabel.text = suggestions[indexPath.row]
        
        autoCompleteCell.selectButton.tag = indexPath.row
        autoCompleteCell.selectButton.addTarget(self, action: #selector(suggestionSelected(_:)), for: .touchUpInside)
        
    }
    
}

//MARK: - UITableViewDataSource
extension TitledInputWithTagsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customAutoCell")
        return cell!
    }
    
}

//MARK: - UITextFieldDelegate
extension TitledInputWithTagsView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text!.isEmpty {
            return true
        }
        
        let clearedText = BadWordHelper.shared.cleanUp(textField.text!)
        
        
        if !(interestsTagList.getTagsText().contains(clearedText)) {
            interestsTagList.addTag(clearedText)
            textField.text = ""
            
            if autoCompleteTable.isHidden != true {
                delegate?.hideAutocompleteTable()
            }
            
            autoCompleteTable.isHidden = true
            autoCompleteShadow.isHidden = true
            
            updateConstraintsAndData()
        }
        
        return true
    }
    
    //Increase keyboard offset for dropdown
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 100.0
        return true
    }
    
    //Set standart keyboard offset
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10.0
        return true
    }
}

//MARK: - TagListViewDelegate
extension TitledInputWithTagsView: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        interestsTagList.removeTagView(tagView)
        updateConstraintsAndData()
    }
}
