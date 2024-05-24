//
//  CompanyProfileViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyProfileViewController: UIViewController {

    @IBOutlet weak var companyTitleLabel: UILabel!
    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var companySectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    
    var isEditable = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyNameInput.isEnabled = isEditable;
        self.companySectorInput.isEnabled = isEditable;
        self.employeeSizeInput.isEnabled = isEditable;
        self.avarageSalaryInput.isEnabled = isEditable
        self.descriptionInput.isEnabled = isEditable
        self.emailInput.isEnabled = isEditable
        self.phoneNumberInput.isEnabled = isEditable
        self.addressInput.isEnabled = isEditable
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        companyTitleLabel.text = GlobalVeriables.currentCompany?.name
        companyNameInput.text =  GlobalVeriables.currentCompany?.name
        companySectorInput.text =  GlobalVeriables.currentCompany?.sectorID
        employeeSizeInput.text =  GlobalVeriables.currentCompany?.employeeSize
        avarageSalaryInput.text =  GlobalVeriables.currentCompany?.avarageSalary
        emailInput.text =  GlobalVeriables.currentCompany?.email
        descriptionInput.text =  GlobalVeriables.currentCompany?.description
        phoneNumberInput.text =  GlobalVeriables.currentCompany?.phoneNumber
        addressInput.text =  GlobalVeriables.currentCompany?.address
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Bu view controller'dan çıkıldığında navigation barı tekrar göster
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }


    @IBAction func updateProfileButton(_ sender: Any) {
        Task { @MainActor in
            
            if isEditable == true{
                var updateCompany = GlobalVeriables.currentCompany
                updateCompany?.name = companyNameInput.text;
                updateCompany?.sectorID = companySectorInput.text;
                updateCompany?.employeeSize = employeeSizeInput.text;
                updateCompany?.avarageSalary = avarageSalaryInput.text;
                updateCompany?.description = descriptionInput.text;
                updateCompany?.email = emailInput.text;
                updateCompany?.phoneNumber = phoneNumberInput.text;
                updateCompany?.address = addressInput.text;
                
                var result = try await AuthService().UpdateCompany(company: updateCompany!)
                
                
                if result == true{
                    
                    let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default) { action in
                        self.navigationController?.popViewController(animated: false);
                    }
                    
                    alert.addAction(action)
                    self.present(alert, animated: true,completion: nil)
                    
                }
                
            } else{
                let alert = UIAlertController(title: "Hata", message: "Lütfen Düzenlemeyi Etkinleştirin", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
            }
            
        }
    }
    
    @IBAction func changeEditable(_ sender: Any) {
        changeEditable();

        
    }
    
    func changeEditable(){
        if isEditable == false{
            isEditable = true;
            self.companyNameInput.isEnabled = isEditable;
            self.companySectorInput.isEnabled = isEditable;
            self.employeeSizeInput.isEnabled = isEditable;
            self.avarageSalaryInput.isEnabled = isEditable
            self.descriptionInput.isEnabled = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            self.addressInput.isEnabled = isEditable

            
        }else{
            isEditable = false

            self.companyNameInput.isEnabled = isEditable;
            self.companySectorInput.isEnabled = isEditable;
            self.employeeSizeInput.isEnabled = isEditable;
            self.avarageSalaryInput.isEnabled = isEditable
            self.descriptionInput.isEnabled = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            self.addressInput.isEnabled = isEditable
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
      
            navigationController?.popToRootViewController(animated: false)
        
    }
    
}
