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
        Task { @MainActor in
            
            
            var testUser = User()
            testUser.userID = "deneme"
            testUser.firstName = "Mustafa"
            testUser.lastName = "Ceylan"
            
            var res = try await UserService().UserRegister(user: testUser)
            
            /*
             if let userTabbarNavigationVC = storyboard?.instantiateViewController(withIdentifier: "UserHomeTabbarController") as? UserHomeTabbarController{
             navigationController?.setNavigationBarHidden(true, animated: false)
             navigationController?.pushViewController(userTabbarNavigationVC, animated: true)
             }
             
             */
        }
    }

}
