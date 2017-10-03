//
//  SlidesViewController.swift
//  FlirtARViper
//
//  Created by  on 08.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class HorizontalViewController: UIPageViewController {

    //MARK: - Variables
    fileprivate var pages = [UIViewController]()
    fileprivate var currentIndex = 0
    fileprivate var containerType = PhotoContainerType.settingsProfile
    fileprivate var photos = [Photo]() {
        didSet {
            reloadData()
        }
    }
    
    //MARK: - UIPageViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subView in view.subviews {
            if subView is UIPageControl {
                subView.isUserInteractionEnabled = false
                if pages.count != 0 {
                    let a = pages[0] as! PhotoViewController
                    a.view.layoutIfNeeded()
                    switch self.containerType {
                    case .arProfile:
                        subView.frame.origin.y = a.view.frame.height - 120.0
                    case .settingsProfile:
                        subView.frame.origin.y = a.view.frame.height - 85.0
                    }
                    
                    self.view.bringSubview(toFront: subView)
                }
            } else if subView is UIScrollView {
                subView.frame = view.bounds
            }
            
        }
    }
    
    func reloadData() {
        pages.removeAll()
        
        if photos.count != 0 {
            dataSource = self
            for i in 0..<photos.count {
                let photo = photos[i]
                let title = "\(i + 1)/\(photos.count)"
                createSlideView(withPhoto: photo, title: title)
            }
            
            if photos.count == 1 {
                view.isUserInteractionEnabled = false
            } else {
                view.isUserInteractionEnabled = true
            }
            
        } else {
            dataSource = nil
            let title = "No photos"
            createSlideView(withPhoto: nil, title: title)
        }
        
        
        initPageController(page: pages[0])
        
    }
    
    func configure(withPhotos photos:[Photo], containerType: PhotoContainerType?) {
        if let containerType = containerType {
            self.containerType = containerType
        }
        
        self.photos = photos
        
        
    }
    
    private func createSlideView(withPhoto photo: Photo?, title: String?) {
        let slide = UIStoryboard(name: "UserPhotosModule", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        print(slide?.view ?? "")
        guard let photoController = slide else {
            return
        }
        
        photoController.confugireView(withPhoto: photo, andTitle: title, andType: containerType)
        pages.append(photoController)
        
    }
    
    private func initPageController(page: UIViewController) {
        setViewControllers([page], direction: .forward, animated: true, completion: nil)
    }

}

extension HorizontalViewController: UIPageViewControllerDataSource {
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
