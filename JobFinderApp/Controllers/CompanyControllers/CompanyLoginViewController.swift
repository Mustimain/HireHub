//
//  CompanyLoginViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LoginButton(_ sender: Any) {
        
        if let companyRegisterVC = storyboard?.instantiateViewController(withIdentifier: "CompanyRegisterViewController") as? CompanyRegisterViewController{
            navigationController?.pushViewController(companyRegisterVC, animated: true)
        }
    }
    

}
