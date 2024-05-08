//
//  CompanyRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit
import GoogleMaps
import CoreLocation

class CompanyRegisterViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var sectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rePasswordInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    
    @IBOutlet weak var mapView: UIView!
    
    
    let locationManager = CLLocationManager()
    let options = GMSMapViewOptions()
    let marker = GMSMarker()
    let googleMapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Kayıt Ol"
        googleMapView.delegate = self

      getCurrentLocation()
        options.camera = GMSCameraPosition.camera(withLatitude: 41.015137, longitude: 28.979530, zoom: 8.0);
        
        googleMapView.camera = options.camera!
        googleMapView.frame = self.mapView.bounds
        googleMapView.isMyLocationEnabled = true;
        self.mapView.addSubview(googleMapView)

    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        Task { @MainActor in
            
            var newCompany = Company()
            newCompany.avarageSalary = avarageSalaryInput.text ?? ""
            newCompany.description = descriptionInput.text ?? ""
            newCompany.email = emailInput.text ?? ""
            newCompany.employeeSize = employeeSizeInput.text ?? ""
            newCompany.locationLat = marker.position.latitude
            newCompany.locationLong = marker.position.longitude
            newCompany.name = companyNameInput.text ?? ""
            newCompany.password = passwordInput.text ?? ""
            newCompany.phoneNumber = passwordInput.text ?? ""
            newCompany.registerDate = Date.now
            newCompany.sectorID = sectorInput.text ?? ""
            newCompany.address = addressInput.text ?? ""
            
            
            let res = try await AuthService().CompanyRegister(company: newCompany)
            
            if res == true{
                
                let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else { return}
        googleMapView.selectedMarker?.position = locValue
        googleMapView.camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 6.0);
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            // Marker'ın konumunu tıklanan nokta olarak ayarla
            marker.position = coordinate
            
            // İsteğe bağlı olarak başlık ve açıklama ekle
            marker.title = "İşyeri Konumu"
            marker.snippet = "Seçilen işyeri konumu"
            
            // Marker'ı haritaya ekle
            marker.map = mapView
        
        let geocoder = CLGeocoder()
        
            // Koordinatları adrese çevirme
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks, error) in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            } else {
                if let placemark = placemarks?.first {
                    // Adres bilgisini alma
                    let address = placemark.thoroughfare ?? "" // Cadde adı
                    let city = placemark.locality ?? "" // Şehir
                    let country = placemark.country ?? "" // Ülke
                    
                    // Adres string'ini oluşturma
                    let addressString = "\(address), \(city), \(country)"
                    
                    self.addressInput.text = addressString
                            
                }
            }
            
            }
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
    
 
