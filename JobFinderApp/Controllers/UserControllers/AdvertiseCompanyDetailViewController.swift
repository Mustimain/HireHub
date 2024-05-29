//
//  AdvertiseCompanyDetailViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.05.2024.
//

import UIKit

class AdvertiseCompanyDetailViewController: UIViewController {

    var selectedAdvertiseDetail : AdvertiseDetail?

    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var sectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedAdvertiseDetail != nil{
            companyNameInput.text = selectedAdvertiseDetail?.companyDetail?.company?.name
            sectorInput.text = selectedAdvertiseDetail?.companyDetail?.sector?.name
            employeeSizeInput.text = selectedAdvertiseDetail?.companyDetail?.company?.employeeSize?.description
            avarageSalaryInput.text = selectedAdvertiseDetail?.companyDetail?.company?.avarageSalary?.description
            emailInput.text = selectedAdvertiseDetail?.companyDetail?.company?.email
            descriptionInput.text = selectedAdvertiseDetail?.companyDetail?.company?.description
            phoneNumberInput.text = selectedAdvertiseDetail?.companyDetail?.company?.phoneNumber
            addressInput.text = selectedAdvertiseDetail?.companyDetail?.company?.address
        }
    }
    

   

}
