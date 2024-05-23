//
//  CompanyAdvertiseDetailViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 23.05.2024.
//

import UIKit

class CompanyAdvertiseDetailViewController: UIViewController {

    var selectedAdvetise: Advertise?
    var isEditable = false;

    @IBOutlet weak var advertiseTitleInput: UITextField!
    @IBOutlet weak var advertiseJobInput: UITextField!
    @IBOutlet weak var advertiseDescriptionInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.advertiseJobInput.isEnabled = isEditable
        self.advertiseTitleInput.isEnabled = isEditable
        self.advertiseDescriptionInput.isEditable = isEditable
        
        advertiseTitleInput.text = selectedAdvetise?.title
        advertiseJobInput.text = selectedAdvetise?.jobId
        advertiseDescriptionInput.text = selectedAdvetise?.description
    }
    

    @IBAction func editButton(_ sender: Any) {
        
        changeEditable();
        
    }
    @IBAction func updateButton(_ sender: Any) {
        
        Task { @MainActor in
            if isEditable == true{
                selectedAdvetise?.title = advertiseTitleInput.text
                selectedAdvetise?.jobId = advertiseJobInput.text
                selectedAdvetise?.description = advertiseDescriptionInput.text
                
                let res = try await AdvertiseService().UpdateAdvertise(advertise: selectedAdvetise!)
                
                if res == true{
                    
                    let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default) { action in
                        self.navigationController?.popViewController(animated: false);
                    }
                    
                    alert.addAction(action)
                    self.present(alert, animated: true,completion: nil)
                    
                }
            }
            else{
                let alert = UIAlertController(title: "Hata", message: "Lütfen Düzenlemeyi Etkinleştirin", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
            }
         
            
        }
    }
    
    func changeEditable(){
        
        if isEditable == false{
            isEditable = true;
            self.advertiseJobInput.isEnabled = isEditable
            self.advertiseTitleInput.isEnabled = isEditable
            self.advertiseDescriptionInput.isEditable = isEditable
        }else{
            isEditable = false;
            self.advertiseJobInput.isEnabled = isEditable
            self.advertiseTitleInput.isEnabled = isEditable
            self.advertiseDescriptionInput.isEditable = isEditable
        }
    }
    

}
