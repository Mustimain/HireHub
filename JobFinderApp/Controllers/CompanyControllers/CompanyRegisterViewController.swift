//
//  CompanyRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

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
            
            
            var res = try await AuthService().CompanyRegister(company: registerCompany)
            
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
    
 
