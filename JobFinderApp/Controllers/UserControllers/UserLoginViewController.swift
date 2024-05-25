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
        
        self.navigationItem.title = "Giriş Yap"

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GoRegisterViewTap))
        userRegisterLabel.isUserInteractionEnabled = true
        userRegisterLabel.addGestureRecognizer(tap)
    }
    

    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            
            let res = try await AuthService().UserLogin(email: userEmailInput.text ?? "", password: userPasswordInput.text ?? "");
            GlobalVeriables.currentUser =  try await AuthService().GetUserByEmail(email: userEmailInput.text!)
            GlobalVeriables.currentUserJob = try await JobService().GetJobByJobId(jobId: (GlobalVeriables.currentUser?.jobID)!)
            
            if (res == true){
            
                if let userHomeTabbarController = storyboard?.instantiateViewController(withIdentifier: "UserHomeTabbarController") as? UserHomeTabbarController{
                    navigationController?.setNavigationBarHidden(true, animated: false)
                    navigationController?.pushViewController(userHomeTabbarController, animated: true)
                    
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
        
        if let userRegisterViewController = storyboard?.instantiateViewController(withIdentifier: "UserRegisterViewController") as? UserRegisterViewController{
            navigationController?.pushViewController(userRegisterViewController, animated: true)
        }
    }
    
}

