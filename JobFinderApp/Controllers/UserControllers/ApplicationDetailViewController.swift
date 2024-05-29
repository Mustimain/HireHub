//
//  ApplicationDetailViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 26.05.2024.
//

import UIKit

class ApplicationDetailViewController: UIViewController {

    var selectedJobApplicationDetail : JobApplicationDetail?
    
    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var sectorNameInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var advertiseTitleInput: UITextField!
    @IBOutlet weak var advertiseJobNameInput: UITextField!
    @IBOutlet weak var advertiseDescriptionInput: UITextView!
    @IBOutlet weak var applicationDateInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if selectedJobApplicationDetail != nil{
            
            companyNameInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.company?.name
            sectorNameInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.sector?.name
            employeeSizeInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.company?.employeeSize?.description
            avarageSalaryInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.company?.avarageSalary?.description
            emailInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.company?.email
            phoneNumberInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.company?.phoneNumber
            addressInput.text = selectedJobApplicationDetail?.advertiseDetail?.companyDetail?.company?.address
            advertiseTitleInput.text = selectedJobApplicationDetail?.advertiseDetail?.advertise?.title
            advertiseJobNameInput.text = selectedJobApplicationDetail?.advertiseDetail?.jobDetail?.job?.name
            advertiseDescriptionInput.text = selectedJobApplicationDetail?.advertiseDetail?.advertise?.description
            let applicationDate = dateFormatter.string(from: selectedJobApplicationDetail?.advertiseDetail?.advertise?.createDate ?? Date.now)
            applicationDateInput.text = applicationDate

            
        }
    }
    



}
