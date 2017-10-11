//
//  FeedbackModuleViewController.swift
//  FlirtARViper
//
//  Created by on 08.10.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class FeedbackModuleViewController: UIViewController, FeedbackModuleViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var feedbackTableView: UITableView!
    
    //MARK: - Private
    fileprivate var feedbackCells: [CellConfiguration] = [.Feedback(.rateAppStore), .Feedback(.customRate)]
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackTableView.register(UINib(nibName: "TitledCell", bundle: nil), forCellReuseIdentifier: "titledCell")
        feedbackTableView.tableFooterView = UIView(frame: .zero)

    }
    
    //MARK: - FeedbackModuleViewProtocol
    var presenter: FeedbackModulePresenterProtocol?
    
}


extension FeedbackModuleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell")
    
        guard cell != nil else {
            return UITableViewCell()
        }
            return cell!
        }
}


extension FeedbackModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch feedbackCells[indexPath.row] {
            
        case .Feedback(.rateAppStore):
            let titledCell = cell as? TitledCell
            titledCell?.configureCell(withType: .Feedback(.rateAppStore))
            titledCell?.delegate = self
        case .Feedback(.customRate):
            let titledCell = cell as? TitledCell
            titledCell?.configureCell(withType: .Feedback(.customRate))
            titledCell?.delegate = self
        default:
            break
        }
    }
}

//MARK: - TitledCellDelegate
extension FeedbackModuleViewController: TitledCellDelegate {
    func rateAppStoreTap() {
        presenter?.openAppStoreRate()
    }
    
    func rateCustomTap() {
        presenter?.openCustomRate()
    }
    
}
