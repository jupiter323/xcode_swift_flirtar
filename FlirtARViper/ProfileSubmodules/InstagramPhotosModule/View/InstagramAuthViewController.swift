//
//  InstagramAuthViewController.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol InstagramAuthDelegate: class {
    func authSuccess(token: String)
    func authFail(error: String)
}

class InstagramAuthViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: - Variables
    weak var delegate: InstagramAuthDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = InstagramAPIRouter.auth
        guard let httpRequest = request.urlRequest else {
            return
        }
        webView.loadRequest(httpRequest)
        
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonTap(_ sender: Any) {
        delegate?.authFail(error: "Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK - UIWebViewDelegate
extension InstagramAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let urlString = request.url?.absoluteString else {
            delegate?.authFail(error: "Invalid url")
            return true
        }
        
        print("InstagramAuth: \(urlString)")
        
        if urlString.contains("access_token") {
            
            let components = urlString.components(separatedBy: "#")
            let instaToken = components[1].components(separatedBy: "=")[1]
            
            delegate?.authSuccess(token: instaToken)
            dismiss(animated: true, completion: nil)
            
        }
        return true
    }
    
}
