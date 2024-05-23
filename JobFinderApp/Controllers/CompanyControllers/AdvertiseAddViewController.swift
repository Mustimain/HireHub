//
//  AdvertiseAddViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 4.05.2024.
//

import UIKit

class AdvertiseAddViewController: UIViewController {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
            navigationController?.setNavigationBarHidden(false, animated: animated)

        
    }
    
    @IBAction func AddAdvertiseButton(_ sender: Any) {
        Task { @MainActor in
            
            var newAdvertise = Advertise()
            newAdvertise.createDate = Date.now
            newAdvertise.title = titleInput.text ?? ""
            newAdvertise.description = descriptionInput.text ?? ""
            newAdvertise.jobId = jobInput.text ?? ""
            newAdvertise.companyID = GlobalVeriables.currentCompany?.companyID ?? ""
            
            let res = try await AdvertiseService().AddAdvertise(advertise: newAdvertise)
            
            if res == true{
                
                let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
            }
        }
    }
    
   

}
