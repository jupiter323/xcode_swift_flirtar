//
//  MapTabViewController.swift
//  FlirtARViper
//
//  Created by  on 04.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import PKHUD

//TODO: Update for markers clustering
//class POIItem: NSObject, GMUClusterItem {
//    var position: CLLocationCoordinate2D
//    var name: String!
//    var marker: Marker!
//    
//    init(position: CLLocationCoordinate2D, name: String, marker: Marker) {
//        self.position = position
//        self.name = name
//        self.marker = marker
//    }
//}


class MapTabViewController: UIViewController, MapTabViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var invisibleNotification: UIView!
    @IBOutlet weak var manualLocationField: InputTextField!
    
    
    //MARK: - Variables
    fileprivate var isInitial = true //show first location and set initial camera
    fileprivate let minZoom = Float(10) //min zoom for map
    fileprivate let initialZoom = Float(13) //initial zoom for map
    fileprivate let maxZoom = Float(20) //max zoom for map
    fileprivate var markersOnMap = [Int: GMSMarker]() //markers which exist on map
    fileprivate var customUserLocationMarker: GMSMarker?
    
    fileprivate let mapsLocationKey = "myLocation" //key for observer for init location
    
    fileprivate var clusterManager: GMUClusterManager!
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Update for markers clustering
//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        
//        //One marker icon setted in GMUDefaultClusterRenderer.m in markerWithPosition method
//        let renderer = GMUDefaultClusterRenderer(mapView: googleMap,
//                                                 clusterIconGenerator: iconGenerator)
//        
//        clusterManager = GMUClusterManager(map: googleMap, algorithm: algorithm,
//                                           renderer: renderer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMap()
        presenter?.viewWillAppear()
        
        
        manualLocationField.addCancelDoneOnKeyboardWithTarget(self,
                                                              cancelAction: #selector(cancelButtonHandler),
                                                              doneAction: #selector(doneButtonHandler))
        
        
        manualLocationField.delegate = self
        
        //observer for internal GMAP location
        googleMap.addObserver(self,
                              forKeyPath: mapsLocationKey,
                              options: NSKeyValueObservingOptions(rawValue: 0),
                              context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
        
        //remove observer for internal GMAP location
        googleMap.removeObserver(self,
                                 forKeyPath: mapsLocationKey)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func goButtonTap(_ sender: Any) {
        
        let _ = manualLocationField.resignFirstResponder()
        
        tryToUpdateManualLocation(forAddress: manualLocationField.text!) { (error) in
            if error != nil {
                HUD.show(.labeledError(title: nil, subtitle: error!.localizedDescription))
                HUD.hide(afterDelay: 3.0, completion: { (_) in
                    DispatchQueue.main.async {
                        let _ = self.manualLocationField.becomeFirstResponder()
                    }
                })

            }
        }
        
    }
    
    //Custom myLocation button action
    @IBAction func currentLocationButtonTap(_ sender: Any) {
        if let userLocation = ProfileService.userLocation {
            let cameraPosition = GMSCameraPosition(target: userLocation.coordinate, zoom: initialZoom, bearing: 0, viewingAngle: 0)
            googleMap.animate(to: cameraPosition)
            
        } else if let mapLocation = googleMap.myLocation {
            let cameraPosition = GMSCameraPosition(target: mapLocation.coordinate, zoom: initialZoom, bearing: 0, viewingAngle: 0)
            googleMap.animate(to: cameraPosition)
        }
    }
    
    
    
    //MARK: - Helpers
    fileprivate func configureMap() {
        googleMap.setMinZoom(minZoom, maxZoom: maxZoom)
        
        
        //if user location -> disable
        if let userLocation = ProfileService.userLocation {
            googleMap.isMyLocationEnabled = false
            googleMap.settings.compassButton = false
            googleMap.camera = GMSCameraPosition(target: userLocation.coordinate, zoom: initialZoom, bearing: 0, viewingAngle: 0)
            customUserLocationMarker = GMSMarker(position: userLocation.coordinate)
            customUserLocationMarker?.icon = #imageLiteral(resourceName: "geolocation")
            DispatchQueue.main.async {
                self.customUserLocationMarker?.map = self.googleMap
            }
            
            isInitial = false
            
        } else {
            //if actual location -> enable map features
            googleMap.isMyLocationEnabled = true
            googleMap.settings.compassButton = true
            
            customUserLocationMarker = nil
            isInitial = true
        }
        
        googleMap.settings.myLocationButton = false
        googleMap.settings.zoomGestures = false
        
    }
    
    fileprivate func tryToUpdateManualLocation(forAddress address: String,
                                               completionHandler: @escaping (_ error: ManualLocationError?) -> ()) {
        
        if address.isEmpty {
            completionHandler(ManualLocationError.emptyAddress)
            return
        }
        
        CLGeocoder().getLocationForAddress(address: address) { (location) in
            if location != nil {
                ProfileService.userLocation = location
                self.presenter?.updateUserLocation()
                self.configureMap()
                completionHandler(nil)
            } else {
                completionHandler(ManualLocationError.invalidAddress)
            }
        }
        
        
    }
    
    fileprivate func hideMapNotification() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let lastView = mainView?.subviews.last
        lastView?.removeFromSuperview()
    }
    
    //MARK: Keyboard toolbar handlers
    func doneButtonHandler() {
        
        if manualLocationField.text!.isEmpty {
            cancelButtonHandler()
        } else {
            let _ = manualLocationField.resignFirstResponder()
            goButtonTap(self)
        }
    }
    
    func cancelButtonHandler() {
        manualLocationField.text = ""
        let _ = manualLocationField.resignFirstResponder()
    }
    
    //MARK: - MapTabViewProtocol
    var presenter: MapTabPresenterProtocol?
    
    //Update markers on map
    func createMarkers(newMarkers markers: Set<Marker>) {
        for eachMarker in markers {
            if let location = eachMarker.location?.coodinates {
                let mapMarker = GMSMarker(position: location)
                mapMarker.icon = #imageLiteral(resourceName: "markerIconNew")
                mapMarker.userData = eachMarker
                markersOnMap[eachMarker.hashValue] = mapMarker
                DispatchQueue.main.async {
                    mapMarker.map = self.googleMap
                }
                
                //TODO: Markers clustering
//                let poiItem = POIItem(position: location,
//                                      name: "\(eachMarker.hashValue)",
//                                      marker: eachMarker)
//                markersOnMap[eachMarker.hashValue] = poiItem
//                clusterManager.add(poiItem)
                
            }
        }
        
        //clusterManager.cluster()
        
    }
    
    func updateMarkers(updMarkers markers: Set<Marker>) {
        for eachMarker in markers {
            if let location = eachMarker.location?.coodinates,
                let mapMarker = markersOnMap[eachMarker.hashValue] {
                
                    mapMarker.position = location
                    mapMarker.userData = eachMarker
                    markersOnMap[eachMarker.hashValue] = mapMarker
                
                //TODO: Markers clustering
                //                clusterManager.remove(mapMarkerPOI)
                //
                //                mapMarkerPOI.position = location
                //                markersOnMap[eachMarker.hashValue] = mapMarkerPOI
                //
                //                clusterManager.add(mapMarkerPOI)
                
            }
        }
        
        //clusterManager.cluster()
        
    }
    
    func removeMarkers(remMarkers markers: Set<Marker>) {
        for eachMarker in markers {
            if let mapMarker = markersOnMap[eachMarker.hashValue] {
                mapMarker.map = nil
                markersOnMap.removeValue(forKey: eachMarker.hashValue)
                
                //TODO: Markers clustering
//                clusterManager.remove(mapMarkerPOI)
//                markersOnMap.removeValue(forKey: eachMarker.hashValue)
            }
        }
        
        //clusterManager.cluster()
        
    }
    
    func showMapNotification(withReason reason: UserMapValidation) {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let mapNotification = MapNotificationView(frame: UIScreen.main.bounds)
        mapNotification.configureView()
        mapNotification.messageView.text = reason.rawValue
        mapNotification.delegate = self
        mainView?.addSubview(mapNotification)
    }
    
    
    
    
    func showLocationServiceNotification(withMessage message: LocationServiceNotification) {
        
        let alert = UIAlertController(title: "Location Service",
                                      message: message.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings",
                                      style: .default,
                                      handler: { (_) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.openURL(settingsUrl)
                }
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func invisibleMode(isActivated status: Bool) {
        invisibleNotification.isHidden = status
    }
    
    //MARK: - Observer 
    //Observer for internal GoogleMaps location update
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath, let location = (object as? GMSMapView)?.myLocation {
            if key == mapsLocationKey {
                if isInitial {
                    googleMap.camera = GMSCameraPosition(target: location.coordinate, zoom: initialZoom, bearing: 0, viewingAngle: 0)
                    isInitial = false
                }
                
            }
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension MapTabViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let _ = manualLocationField.resignFirstResponder()
        
        tryToUpdateManualLocation(forAddress: textField.text!) { (error) in
            if error != nil {
                HUD.show(.labeledError(title: nil, subtitle: error!.localizedDescription))
                HUD.hide(afterDelay: 3.0, completion: { (_) in
                    let _ = self.manualLocationField.becomeFirstResponder()
                })
            }
        }
        
        return true
    }
    
}

//MARK: - MapNotificationViewDelegate
extension MapTabViewController: MapNotificationViewDelegate {
    func openProfileSettings() {
        hideMapNotification()
        presenter?.openProfileSettings()
    }
}


//Marker InfoWindow logic commented
//Uncomment to show markers window on map

////MARK: - GMSMapViewDelegate
//extension MapTabViewController: GMSMapViewDelegate {
//    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        
//        if marker != customUserLocationMarker {
//            guard let markerData = marker.userData as? Marker else {
//                return UIView()
//            }
//            
//            let mapInfoView = MarkerInfoView(frame: CGRect(x: 0, y: 0, width: 158, height: 64))
//            marker.tracksInfoWindowChanges = true
//            mapInfoView.configureMarker(withUser: markerData) { (complete) in
//                if complete {
//                    marker.tracksInfoWindowChanges = false
//                }
//            }
//            return mapInfoView
//        }
//        
//        return nil
//    }
//    
//}
