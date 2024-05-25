//
//  UserAdvertisesViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 25.05.2024.
//

import UIKit

class UserAdvertisesViewController: UIViewController {

    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var advertiseTitleInput: UITextField!
    @IBOutlet weak var jobNameInput: UITextField!
    @IBOutlet weak var advertiseDescriptionInput: UITextView!
    
    var advertiseDetail : AdvertiseDetail?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        companyNameInput.text = advertiseDetail?.companyDetail?.company?.name
        advertiseTitleInput.text = advertiseDetail?.advertise?.title
        jobNameInput.text = advertiseDetail?.advertise?.jobId
        advertiseDescriptionInput.text = advertiseDetail?.advertise?.description
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    @IBAction func sendAdvertiseApplicationButton(_ sender: Any) {
        
    }
}
