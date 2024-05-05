//
//  UserHomeViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit
import GoogleMaps
import CoreLocation

class UserHomeViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate  {

    @IBOutlet weak var homeMapView: UIView!
    
    
    let locationManager = CLLocationManager()
    let options = GMSMapViewOptions()
    let marker = GMSMarker()
    let googleMapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapView.delegate = self

      getCurrentLocation()
        options.camera = GMSCameraPosition.camera(withLatitude: 41.015137, longitude: 28.979530, zoom: 8.0);
        
        googleMapView.camera = options.camera!
        googleMapView.frame = self.homeMapView.bounds
        googleMapView.isMyLocationEnabled = true;
        self.homeMapView.addSubview(googleMapView)
        // Do any additional setup after loading the view.
    }
    
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
  

}
