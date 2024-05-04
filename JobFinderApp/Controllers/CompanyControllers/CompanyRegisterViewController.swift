//
//  CompanyRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit
import GoogleMaps

class CompanyRegisterViewController: UIViewController {

    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var sectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        options.frame = self.view.bounds
        let mapView = GMSMapView(options: options)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        // Do any additional setup after loading the view.
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        Task { @MainActor in
            
            var registerCompany = Company()
            registerCompany.avarageSalary = avarageSalaryInput.text ?? ""
            registerCompany.description = descriptionInput.text ?? ""
            registerCompany.email = emailInput.text ?? ""
            registerCompany.employeeSize = employeeSizeInput.text ?? ""
            registerCompany.locationLat = ""
            registerCompany.locationLong = ""
            registerCompany.name = companyNameInput.text ?? ""
            registerCompany.password = passwordInput.text ?? ""
            registerCompany.phoneNumber = passwordInput.text ?? ""
            registerCompany.registerDate = Date.now
            registerCompany.sectorID = sectorInput.text ?? ""
            
            
            let res = try await AuthService().CompanyRegister(company: registerCompany)
            
            if res == true{
                
                let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
            }
        }
    }
        
}
    
 
