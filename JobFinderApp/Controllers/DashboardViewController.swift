//
//  DashboardViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func UserLoginButton(_ sender: Any) {
        
        if let userLoginVC = storyboard?.instantiateViewController(withIdentifier: "UserLoginViewController") as? UserLoginViewController{
            navigationController?.pushViewController(userLoginVC, animated: true)
        }
        
    }
    
    /*
    @IBAction func CompanyLoginButton(_ sender: Any) {
        
        if let companyLoginVC = storyboard?.instantiateViewController(withIdentifier: "CompanyLoginViewController") as? CompanyLoginViewController{
            navigationController?.pushViewController(companyLoginVC, animated: true)
        }
    }
    
*/
}
