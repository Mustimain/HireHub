//
//  UserLoginViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func LoginButton(_ sender: Any) {
        
        if let userRegisterVC = storyboard?.instantiateViewController(withIdentifier: "UserRegisterViewController") as? UserRegisterViewController{
            navigationController?.pushViewController(userRegisterVC, animated: true)
        }
    }

}
