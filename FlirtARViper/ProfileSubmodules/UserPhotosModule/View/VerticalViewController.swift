//
//  VerticalViewController.swift
//  FlirtARViper
//
//  Created by on 05.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class VerticalViewController: UIPageViewController {

    //MARK: - Variables
    fileprivate var pages = [UIViewController]()
    fileprivate var currentIndex = 0
    fileprivate var photos = [Photo]() {
        didSet {
            reloadData()
        }
    }
    
    fileprivate var customPageControl = UIPageControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.view.addSubview(customPageControl)
        self.view.bringSubview(toFront: customPageControl)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subView in view.subviews {
            if subView is UIScrollView {
                subView.frame = view.bounds
                if pages.count != 0 {
                    let a = pages[0] as! PhotoViewController
                    a.view.layoutIfNeeded()
                    customPageControl.frame.origin.y = a.view.frame.height / 2
                    customPageControl.frame.origin.x = UIScreen.main.bounds.width - 20
                }
            }
        }
    }
    
    func reloadData() {
        pages.removeAll()
        
        if photos.count != 0 {
            dataSource = self
            delegate = self
            for i in 0..<photos.count {
                let photo = photos[i]
                createSlideView(withPhoto: photo)
            }
            
            if photos.count == 1 {
                view.isUserInteractionEnabled = false
            } else {
                view.isUserInteractionEnabled = true
            }
            
        } else {
            dataSource = nil
            delegate = nil
            createSlideView(withPhoto: nil)
        }
        
        
        initPageController(page: pages[0])
        
    }
    
    func configure(withPhotos photos:[Photo]) {
        self.photos = photos
        
        customPageControl.numberOfPages = pages.count
        customPageControl.currentPage = currentIndex
        customPageControl.transform = CGAffineTransform(rotationAngle: (CGFloat.pi * 90.0) / 180.0)
        
    }
    
    private func createSlideView(withPhoto photo: Photo?) {
        let slide = UIStoryboard(name: "UserPhotosModule", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        print(slide?.view ?? "")
        guard let photoController = slide else {
            return
        }
        
        photoController.confugireView(withPhoto: photo, andTitle: nil, andType: nil)
        pages.append(photoController)
        
    }
    
    private func initPageController(page: UIViewController) {
        setViewControllers([page], direction: .forward, animated: true, completion: nil)
    }
    
    

}

extension VerticalViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? PhotoViewController {
                let index = pages.index(of: currentViewController)
                guard let foundIndex = index else { return }
                customPageControl.currentPage = foundIndex
            }
        }
    }
}


extension VerticalViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if pages.count == 0 { return nil }
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = currentIndex-1
        if previousIndex < 0 {
            return pages[pages.count - 1]
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if pages.count == 0 { return nil }
        
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = currentIndex + 1
        if nextIndex >= pages.count {
            return pages[0]
        }
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}
