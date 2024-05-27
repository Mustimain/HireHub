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
    @IBOutlet weak var userRegisterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GoRegisterViewTap))
        userRegisterLabel.isUserInteractionEnabled = true
        userRegisterLabel.addGestureRecognizer(tap)
    }
    

    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            
            if userEmailInput.text!.count > 0 && userPasswordInput.text!.count > 0 {
                let res = try await AuthService().UserLogin(email: userEmailInput.text ?? "", password: userPasswordInput.text ?? "");
                
                if (res == true){
                    GlobalVeriables.currentUser =  try await AuthService().GetUserDetailByEmail(email: userEmailInput.text!)

                    if let userHomeTabbarController = storyboard?.instantiateViewController(withIdentifier: "UserHomeTabbarController") as? UserHomeTabbarController{
                        navigationController?.setNavigationBarHidden(true, animated: false)
                        navigationController?.pushViewController(userHomeTabbarController, animated: true)
                        
                    }
                }
                else{
                    self.showCustomAlert(title: "Hata", message: "Şifre veya Email yanlış tekrar deneyiniz.")
                        
                    }
            }else{
                self.showCustomAlert(title: "Hata", message: "Alanlar Boş Bırakılamaz.")

            }
       
            
         
            }
        }
    
    @objc func GoRegisterViewTap(sender:UITapGestureRecognizer) {
        
        if let userRegisterViewController = storyboard?.instantiateViewController(withIdentifier: "UserRegisterViewController") as? UserRegisterViewController{
            navigationController?.pushViewController(userRegisterViewController, animated: true)
        }
    }
    
}

extension UIViewController {
    
    func showCustomAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Tamam", style: .default) { action in
            // Additional action if needed
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
