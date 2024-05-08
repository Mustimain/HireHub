//
//  CompanyAdvertiseViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyAdvertiseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func GoAdvertiseAddView(_ sender: Any) {
        
        if let advertiseAddViewController = storyboard?.instantiateViewController(withIdentifier: "AdvertiseAddViewController") as? AdvertiseAddViewController{
            navigationController?.pushViewController(advertiseAddViewController, animated: true)
            
        }
    }


}
