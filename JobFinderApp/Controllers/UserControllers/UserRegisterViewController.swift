//
//  UserRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserRegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var experienceYearInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rePasswordInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    var jobPickerView = UIPickerView();
    var experienceYearPickerView = UIPickerView();
    var experienceYears : [String] = []
    
    var jobDetailList: [JobDetail] = []

    override func viewDidLoad()  {
        super.viewDidLoad()
        experienceYears = ["0 - 1", "1 - 3" ,"3 - 5","5 - 10","10+"]

        jobInput.inputView = jobPickerView;
        experienceYearInput.inputView = experienceYearPickerView;
        
        jobPickerView.delegate = self;
        jobPickerView.dataSource = self;
        experienceYearPickerView.delegate = self;
        experienceYearPickerView.dataSource = self;
        
        jobPickerView.tag = 1
        experienceYearPickerView.tag = 2
        
        Task { @MainActor in
            
            await GetAllJobDetails()
        }
    }

    @IBAction func RegisterButton(_ sender: Any) {
        Task { @MainActor in
            
            
            var newUser = User()
            newUser.firstName = firstNameInput.text ?? ""
            newUser.lastName = lastNameInput.text ?? ""
            newUser.email = emailInput.text ?? ""
            newUser.createDate = Date.now
            newUser.cvPath = ""
            newUser.emailVerification = true
            newUser.experienceYear = experienceYearInput.text ?? ""
            newUser.jobId = jobInput.text ?? ""
            newUser.password = passwordInput.text ?? ""
            newUser.phoneNumber = phoneNumberInput.text ?? ""
            
            let res = try await AuthService().UserRegister(user: newUser)
            
            if res == true{
                
                let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
                
            }
        }
        
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return jobDetailList.count
        }
        if pickerView.tag == 2{
            return experienceYears.count

        }
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            jobDetailList[row]
        case 2:
            experienceYears[row]
        default:
            return "Data not found"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
        case 1:
            jobInput.text = jobDetailList[row].job?.name
            jobInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat
        case 2:
            experienceYearInput.text = experienceYears[row]
            experienceYearInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat

        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.font = UIFont.systemFont(ofSize: 18.0) // Metin boyutu ayarlayabilirsiniz
            label?.textAlignment = .center
            label?.textColor = UIColor.black // Metin rengini burada değiştirin

        }
        
        switch pickerView.tag{
        case 1:
            label?.text = jobDetailList[row].job?.name
            label?.textColor = UIColor.black
        case 2:
            label?.text = experienceYears[row]
            label?.textColor = UIColor.black
        default:
            label?.text =  "Data not found"
        }
  
        
        return label!
    }
    
    func GetAllJobDetails() async{
        Task { @MainActor in
            
            self.jobDetailList  = try await JobService().GetAllJobDetails();
        }
    }

}
