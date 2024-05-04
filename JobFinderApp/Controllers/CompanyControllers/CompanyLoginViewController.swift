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
    
    
    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            
            let res = try await AuthService().CompanyLogin(email: companyEmailInput.text ?? "", password: companyPasswordInput.text ?? "");
            
            if (res == true){
                
                if let companyHomeTabbarController = storyboard?.instantiateViewController(withIdentifier: "CompanyHomeTabbarController") as? CompanyHomeTabbarController{
                    navigationController?.pushViewController(companyHomeTabbarController, animated: true)
                }
            }
            else{
                let alert = UIAlertController(title: "Hata", message: "email veya şifre yanlış", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
            }
            
            
        }
        
        
    }
    
    @objc func GoRegisterViewTap(sender:UITapGestureRecognizer) {
        
        if let companyRegisterViewController = storyboard?.instantiateViewController(withIdentifier: "CompanyRegisterViewController") as? CompanyRegisterViewController{
            navigationController?.pushViewController(companyRegisterViewController, animated: true)
        }
    }
}
