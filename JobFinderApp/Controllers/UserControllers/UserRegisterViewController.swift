//
//  UserRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func UserTabbarNavgaitonButton(_ sender: Any) {
        
        if let userTabbarNavigationVC = storyboard?.instantiateViewController(withIdentifier: "UserHomeTabbarController") as? UserHomeTabbarController{
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.pushViewController(userTabbarNavigationVC, animated: true)
        }
    }

}
