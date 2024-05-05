//
//  UserHomeTabbarController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserHomeTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = self.parent as? UITabBarController {
            tabBarController.tabBar.barTintColor = UIColor.red
            tabBarController.tabBar.tintColor = UIColor.white
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
