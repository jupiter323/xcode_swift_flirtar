//
//  SelectLocationViewController.swift
//  FlirtARViper
//
//  Created by on 04.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import GoogleMaps

protocol SelectLocationViewControllerDelegate: class {
    func locationConfirmed(newLocation: CLLocation)
    func selectLocationCancelled()
}

class SelectLocationViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //MARK: - Variables
    fileprivate var selectedLocation: CLLocation?
    fileprivate var marker: GMSMarker? {
        willSet {
            if newValue != nil {
                doneButton.isHidden = false
            } else {
                doneButton.isHidden = true
            }
        }
    }
    
    weak var delegate: SelectLocationViewControllerDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isHidden = true
        googleMap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let coordinates = CLLocationCoordinate2D(latitude: 34.062097, longitude: -118.248487)
        let zoom = googleMap.camera.zoom
        let camera = GMSCameraPosition(target: coordinates, zoom: zoom, bearing: 0, viewingAngle: 0)
        googleMap.camera = camera
        
    }
    
    //MARK: - Actions
    @IBAction func cancelTap(_ sender: Any) {
        delegate?.selectLocationCancelled()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTap(_ sender: Any) {
        if selectedLocation != nil {
            delegate?.locationConfirmed(newLocation: selectedLocation!)
        }
        dismiss(animated: true, completion: nil)
    }
    

}

//MARK: - GMSMapViewDelegate
extension SelectLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //add
        if marker == nil {
            marker = GMSMarker(position: coordinate)
            DispatchQueue.main.async {
                self.marker?.map = self.googleMap
            }
            //change position
        } else {
            marker?.position = coordinate
        }
        
        selectedLocation = CLLocation(latitude: coordinate.latitude,
                                      longitude: coordinate.longitude)
        
        
    }
}
