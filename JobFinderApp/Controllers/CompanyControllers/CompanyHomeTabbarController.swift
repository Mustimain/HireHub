//
//  CompanyHomeTabbarController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyHomeTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(hex: "#588157")
        self.tabBar.barTintColor = UIColor(hex: "#588157")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Bu view controller'dan çıkıldığında navigation barı tekrar göster
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    
}


