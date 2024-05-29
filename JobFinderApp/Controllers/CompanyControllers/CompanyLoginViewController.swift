//
//  CompanyLoginViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyLoginViewController: UIViewController {
    
    @IBOutlet weak var companyEmailInput: UITextField!
    @IBOutlet weak var companyPasswordInput: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(GoRegisterViewTap))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.title = ""
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            
            if companyEmailInput.text!.count > 0 && companyPasswordInput.text!.count > 0 {
                
                let res = try await AuthService().CompanyLogin(email: companyEmailInput.text ?? "", password: companyPasswordInput.text ?? "");
                if (res == true){
                    
                    GlobalVeriables.currentCompany = try await AuthService().GetCompanyDetailByEmail(email: self.companyEmailInput.text!)
                    if ((GlobalVeriables.currentCompany?.company?.name?.count ?? 0)! > 0){
                        
                        if let companyHomeTabbarController = storyboard?.instantiateViewController(withIdentifier: "CompanyHomeTabbarController") as? CompanyHomeTabbarController{
                            navigationController?.pushViewController(companyHomeTabbarController, animated: true)
                        }
                        
                    }
                }
                else{
                    self.showCustomAlert(title: "Hata", message: "Email veya şifre yanlış tekrar deneyiniz.")
                    
                }
            }else{
                self.showCustomAlert(title: "Hata", message: "Email ve password boş bırakılamaz.")

            }
            
        }
        
    }
    
    @objc func GoRegisterViewTap(sender:UITapGestureRecognizer) {
        
        if let companyRegisterViewController = storyboard?.instantiateViewController(withIdentifier: "CompanyRegisterViewController") as? CompanyRegisterViewController{
            navigationController?.pushViewController(companyRegisterViewController, animated: true)
        }
    }
}
