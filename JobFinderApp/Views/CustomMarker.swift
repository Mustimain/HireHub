//
//  CustomMarker.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 15.05.2024.
//

import UIKit

class CustomMarker: UIView {

    @IBOutlet weak var companyNameInput: UILabel!
    @IBOutlet weak var addressInput: UILabel!
    @IBOutlet weak var employeeSizeInput: UILabel!
    @IBOutlet weak var sectorInput: UILabel!
    @IBOutlet weak var avarageSalaryInput: UILabel!
    @IBOutlet weak var phoneNumberInput: UILabel!
    @IBOutlet weak var emailInput: UILabel!
    
    class func instanceFromNib() -> CustomMarker {
           return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarker
       }
}
