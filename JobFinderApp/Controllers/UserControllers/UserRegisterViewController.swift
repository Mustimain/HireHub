//
//  UserRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserRegisterViewController: UIViewController {

    
    @IBOutlet weak var firstNameInput: UITextField!
    
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var experienceYearInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rePasswordInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func RegisterButton(_ sender: Any) {
        Task { @MainActor in
            
            
            var registerUser = User()
            registerUser.firstName = firstNameInput.text ?? ""
            registerUser.lastName = lastNameInput.text ?? ""
            registerUser.email = emailInput.text ?? ""
            registerUser.createDate = Date.now
            registerUser.cvPath = ""
            registerUser.emailVerification = true
            registerUser.experienceYear = experienceYearInput.text ?? ""
            registerUser.job = jobInput.text ?? ""
            registerUser.password = passwordInput.text ?? ""
            registerUser.phoneNumber = phoneNumberInput.text ?? ""
            
            let res = try await AuthService().UserRegister(user: registerUser)
            
            if res == true{
                
                let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
            }
        }
            
            /*
             if let userTabbarNavigationVC = storyboard?.instantiateViewController(withIdentifier: "UserHomeTabbarController") as? UserHomeTabbarController{
             navigationController?.setNavigationBarHidden(true, animated: false)
             navigationController?.pushViewController(userTabbarNavigationVC, animated: true)
             }
             
             */
        }
        
    }

