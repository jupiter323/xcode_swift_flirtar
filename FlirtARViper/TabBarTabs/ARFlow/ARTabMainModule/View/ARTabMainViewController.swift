//
//  ARTabMainViewController.swift
//  FlirtARViper
//
//  Created by   on 05.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD

class ARTabMainViewController: ARViewController, ARTabMainViewProtocol {

    //MARK: - Variables
    fileprivate var annotationsForAR = [ARMarkerAnnotation]() //annotations
    fileprivate var selectedAnnotation: ARMarkerAnnotation? //selected by user annotation
    fileprivate var profileAnnotationView = ARProfileAnnotationView() //reuse existing profile annotation
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure profile annotation
        profileAnnotationView.delegate = self
        profileAnnotationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70.0) //status + tab
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureARController() // - configure self as ar controller
        super.viewWillAppear(animated)
        viperPresenter?.viewWillAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viperPresenter?.viewWillDissapear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - ARTabMainViewProtocol
    var viperPresenter: ARTabMainPresenterProtocol?
    
    func updateAnnotations(annotations: [ARMarkerAnnotation]) {
        self.annotationsForAR = annotations
        self.setAnnotations(self.annotationsForAR)
    }
    
    //MARK: - Initial AR components
    //Show it as root controller
    private func configureARController() {
        self.dataSource = self
        self.presenter.maxVisibleAnnotations = 100
        self.presenter.distanceOffsetMode = .manual
        self.presenter.distanceOffsetMultiplier = 0.1
        self.presenter.maxDistance = 1600
        self.presenter.presenterTransform = ARPresenterStackTransform()
        self.uiOptions.closeButtonEnabled = false
        
        if let customLocation = ProfileService.userLocation {
            self.stopTrackingLocation()
            self.arStatus.userLocation = customLocation
        } else {
            self.startTrackingLocation()
        }
        
        
    }
    
}


extension ARTabMainViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        
        if selectedAnnotation == nil {
            let annotationView = ARMarkerAnnotationView()
            annotationView.annotation = viewForAnnotation
            annotationView.delegate = self
            
            var arBalloonFrame: CGRect!
            
            if self.annotationsForAR.count > 5 {
                arBalloonFrame = CGRect(x: 0, y: 0, width: 130, height: 110)
            } else {
                arBalloonFrame = CGRect(x: 0, y: 0, width: 130, height: 151)
            }
            
            annotationView.frame = arBalloonFrame
            annotationView.annotation = viewForAnnotation
            return annotationView
        } else {
            return ARAnnotationView()
        }
        
        //TODO: Previous version
//        //check does it custom annotation
//        if viewForAnnotation.isKind(of: ARMarkerAnnotation.self) {
//            
//            //check markers in annotationView
//            guard let viewMarkers = (viewForAnnotation as! ARMarkerAnnotation).markers else {
//                    return ARAnnotationView()
//            }
//            
//            //if there are markers in selected annotation
//            if let selectedMarkers = selectedAnnotation?.markers {
//                //if not selected -> hide ballons
//                if viewMarkers != selectedMarkers {
////                    let annotationView = ARMarkerAnnotationView()
////                    annotationView.annotation = viewForAnnotation
////                    annotationView.delegate = self
////                    annotationView.frame = CGRect(x: 0, y: 0, width: 130, height: 196)
////                    annotationView.annotation = viewForAnnotation
//                    return ARAnnotationView()//annotationView
//                } else {
//                    //if selected -> show short profile annotView, reuse it
//                    //show reusable annotation view
//                    return profileAnnotationView
//                }
//            } else {
//                //esle if not selected or there is no selected marker -> show small annotView
//                let annotationView = ARMarkerAnnotationView()
//                annotationView.annotation = viewForAnnotation
//                annotationView.delegate = self
//                annotationView.frame = CGRect(x: 0, y: 0, width: 130, height: 196)
//                annotationView.annotation = viewForAnnotation
//                return annotationView//annotationView
//            }
//            
//        } else {
//            //if error show default
//            return ARAnnotationView()
//        }
        
        
    }
}




//MARK: - ARMarkerAnnotationViewDelegate
extension ARTabMainViewController: ARMarkerAnnotationViewDelegate {
    func didTouchMarker(annotationView: ARMarkerAnnotationView) {
        
        guard let markers = (annotationView.annotation as? ARMarkerAnnotation)?.markers else {
            return
        }
        
        //set selected annotation from small annotView
        self.selectedAnnotation = annotationView.annotation as? ARMarkerAnnotation
        viperPresenter?.showShortProfile(markers: markers)
        
        //TODO: Previous version
//        //save markers to data helper
//        let markers = (annotationView.annotation as? ARMarkerAnnotation)?.markers
//        ARProfileDataHelper.shared.configureWithMarkers(markers: markers)
        
    }
}

//MARK: - ARProfileAnnotationViewDelegate
extension ARTabMainViewController: ARProfileAnnotationViewDelegate {
    func didTapClose() {
        //tap close from short annotView
        self.selectedAnnotation = nil
    }
    func didTapShowFullProfile(forUser user: ShortUser) {
        //tap full profile from short annotView
        //viperPresenter?.openDetailProfile(forUser: user)
    }
    
}

//MARK: - ARShortProfileViewControllerDelegate
extension ARTabMainViewController: ARShortProfileViewControllerDelegate {
    func removeFromParentTapped() {
        self.selectedAnnotation = nil
    }
}




