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
        Task { @MainActor in
            
            
            var checkApplicationIsExist = try await JobApplicationService().CheckApplicationIsExist(userId: (GlobalVeriables.currentUser?.user?.userID)!, advertiseId: (advertiseDetail?.advertise?.advertiseID)!)
            
            if checkApplicationIsExist == true{
                var newJobApplication = JobApplication()
                newJobApplication.advertiseID = advertiseDetail?.advertise?.advertiseID
                newJobApplication.applicationDate = Date.now
                newJobApplication.userID = GlobalVeriables.currentUser?.user?.userID
                
                var result = try await JobApplicationService().AddJobApplication(jobApplication: newJobApplication)
                
                if (result == true){

                    let alert = UIAlertController(title: "İşlem Başarılı", message: "Başvuru başarıyla alınmıştır", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default) { action in
                        
                    }
                    
                    alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
                    
                }
                else{
                        let alert = UIAlertController(title: "Hata", message: "Başvuru yapılırken hata oluştur lütfen daha sonra tekrar deneyin", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Ok", style: .default) { action in
                            
                        }
                        
                        alert.addAction(action)
                    self.present(alert, animated: true,completion: nil)
                    
                    }
            }else{
                
                let alert = UIAlertController(title: "Hata", message: "Başvuru daha önce yapılmıştır", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
            self.present(alert, animated: true,completion: nil)
            }
            
         
        }
    }
}
