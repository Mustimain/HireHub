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
        navigationItem.setHidesBackButton(true, animated: false)

        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(hex: "#588157")
        self.tabBar.barTintColor = UIColor(hex: "#588157")

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

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var formattedHex = hex
        if hex.hasPrefix("#") {
            formattedHex = String(hex.dropFirst())
        }
        
        let scanner = Scanner(string: formattedHex)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(hexNumber & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }
}
