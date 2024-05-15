//
//  UserHomeViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit
import GoogleMaps
import CoreLocation

class UserHomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var homeMapView: UIView!
    var advertiseDetails: [AdvertiseDetail] = []

    let locationManager = CLLocationManager()
    let googleMapView = GMSMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        googleMapView.delegate = self
        setupMap()
        getCurrentLocation()
        Task { @MainActor in
            await fetchCompaniesFromDatabase()
        }
    }

    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 41.015137, longitude: 28.979530, zoom: 8.0)
        googleMapView.camera = camera
        googleMapView.frame = self.homeMapView.bounds
        googleMapView.isMyLocationEnabled = true
        self.homeMapView.addSubview(googleMapView)
    }

    func getCurrentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
            googleMapView.animate(to: camera)
        }
    }

    func addCompanyMarker(advertiseDetail: AdvertiseDetail) {
        guard let latitude = advertiseDetail.company?.locationLat, let longitude = advertiseDetail.company?.locationLong else { return }
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = advertiseDetail.company?.name
        marker.snippet = advertiseDetail.company?.address
        marker.map = googleMapView
    }

    func fetchCompaniesFromDatabase() async {
        do {
            // Veritabanından reklam detaylarını alın
            advertiseDetails = try await AdvertiseService().GetAllAdvertiseDetail()
            await MainActor.run {
                googleMapView.clear() // Mevcut tüm markerları kaldır
                displayCompaniesOnMap()
            }
        } catch {
            print("Error fetching companies: \(error)")
        }
    }

    func displayCompaniesOnMap() {
        for advertiseDetail in advertiseDetails {
            addCompanyMarker(advertiseDetail: advertiseDetail)
        }
    }
}
