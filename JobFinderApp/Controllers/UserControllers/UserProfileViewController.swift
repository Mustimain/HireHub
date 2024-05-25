//
//  UserProfileViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userFirstNameInput: UITextField!
    @IBOutlet weak var userLastNameInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var experienceYearInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    
    var isEditable = false;
    var selectedJob : Job = Job()
    var jobPicker = UIPickerView();
    var experienceYearPicker = UIPickerView();
    var jobList: [Job] = []
    var experienceYears : [String] = ["0 - 1", "1 - 3" ,"3 - 5","5 - 10","10+"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobPicker.delegate = self;
        jobPicker.dataSource = self;
        experienceYearPicker.dataSource = self;
        experienceYearPicker.delegate  = self;
        
        jobInput.inputView = jobPicker;
        experienceYearInput.inputView = experienceYearPicker;
        jobPicker.tag = 1
        experienceYearPicker.tag = 2
        
        
        self.userFullNameLabel.isEnabled = isEditable;
        self.userFirstNameInput.isEnabled = isEditable;
        self.userLastNameInput.isEnabled = isEditable;
        self.jobInput.isEnabled = isEditable;
        self.experienceYearInput.isEnabled = isEditable;
        self.emailInput.isEnabled = isEditable;
        self.phoneNumberInput.isEnabled = isEditable;
        
        Task { @MainActor in
            
            await GetAllJobs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userFullNameLabel.text = (GlobalVeriables.currentUser?.user?.firstName ?? "") + " " + (GlobalVeriables.currentUser?.user?.lastName ?? "")
        self.userFirstNameInput.text = GlobalVeriables.currentUser?.user?.firstName;
        self.userLastNameInput.text = GlobalVeriables.currentUser?.user?.lastName;
        self.jobInput.text = GlobalVeriables.currentUser?.jobDetail?.job?.name
        self.emailInput.text = GlobalVeriables.currentUser?.user?.email;
        self.phoneNumberInput.text = GlobalVeriables.currentUser?.user?.phoneNumber;
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    @IBAction func logoutButton(_ sender: Any) {
    }
    
    @IBAction func changeEditButton(_ sender: Any) {
        changeEditable();

    }
    @IBAction func updateButton(_ sender: Any) {
        Task { @MainActor in
            
            if isEditable == true{
                var updateUser = GlobalVeriables.currentUser?.user
                updateUser?.firstName = userFirstNameInput.text;
                updateUser?.lastName = userLastNameInput.text;
                updateUser?.jobID = selectedJob.jobID;
                updateUser?.email = emailInput.text;
                updateUser?.phoneNumber = phoneNumberInput.text;
                
                
                var result = try await AuthService().UpdateUser(user: updateUser!)
                
                
                if result == true{
                    
                    let alert = UIAlertController(title: "Başarılı", message: "Kayıt Başarılı", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default) { action in
                        self.navigationController?.popViewController(animated: false);
                    }
                    
                    alert.addAction(action)
                    self.present(alert, animated: true,completion: nil)
                    
                }
                
            } else{
                let alert = UIAlertController(title: "Hata", message: "Lütfen Düzenlemeyi Etkinleştirin", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                }
                
                alert.addAction(action)
                self.present(alert, animated: true,completion: nil)
            }
            
        }
    }
    
    
    
    func GetAllJobs() async{
        Task { @MainActor in
            jobList = try await JobService().GetAllJobs()
        }
    }
    
    func changeEditable(){
        if isEditable == false{
            isEditable = true;
            self.userFirstNameInput.isEnabled = isEditable;
            self.userLastNameInput.isEnabled = isEditable;
            self.jobInput.isEnabled = isEditable;
            self.experienceYearInput.isEnabled = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
      

            
        }else{
            isEditable = false

            self.userFirstNameInput.isEnabled = isEditable;
            self.userLastNameInput.isEnabled = isEditable;
            self.jobInput.isEnabled = isEditable;
            self.experienceYearInput.isEnabled = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return jobList.count
        }
        if pickerView.tag == 2{
            return experienceYears.count

        }
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            jobList[row]
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
            jobInput.text = jobList[row].name
            selectedJob = jobList[row]; 
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
            label?.text = jobList[row].name
            label?.textColor = UIColor.black
        case 2:
            label?.text = experienceYears[row]
            label?.textColor = UIColor.black
        default:
            label?.text =  "Data not found"
        }
  
        
        return label!
    }
    
}
