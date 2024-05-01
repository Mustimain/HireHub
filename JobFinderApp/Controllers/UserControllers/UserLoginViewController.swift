//
//  UserLoginViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserLoginViewController: UIViewController {

    @IBOutlet weak var userEmailInput: UITextField!
    @IBOutlet weak var userPasswordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            
            let res = try await AuthService().UserLogin(email: userEmailInput.text ?? "", password: userPasswordInput.text ?? "");
            
            if (res == true){
                if let userRegisterVC = storyboard?.instantiateViewController(withIdentifier: "UserRegisterViewController") as? UserRegisterViewController{
                    navigationController?.pushViewController(userRegisterVC, animated: true)
                    
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
    }

