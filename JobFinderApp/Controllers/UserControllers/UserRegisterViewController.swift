//
//  UserRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit
import FirebaseStorage

class UserRegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIDocumentPickerDelegate{

    
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rePasswordInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var userResumeNameInput: UITextField!
    
    var jobPickerView = UIPickerView();
    var experienceYearPickerView = UIPickerView();
    var jobDetailList: [JobDetail] = []
    var selectedJob : Job = Job()
    var resumeURL : URL?

    override func viewDidLoad()  {
        super.viewDidLoad()

        jobInput.inputView = jobPickerView;
        
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
            
            if firstNameInput.text!.count > 0 && lastNameInput.text!.count > 0 && emailInput.text!.count > 0 && selectedJob.name?.count ?? 0 > 0 && passwordInput.text!.count > 0 && phoneNumberInput.text!.count > 0 && resumeURL != nil{
                
                if passwordInput.text == rePasswordInput.text{
                    var newUser = User()
                    newUser.firstName = firstNameInput.text ?? ""
                    newUser.lastName = lastNameInput.text ?? ""
                    newUser.email = emailInput.text ?? ""
                    newUser.createDate = Date.now
                    newUser.emailVerification = true
                    newUser.jobID = selectedJob.jobID ?? ""
                    newUser.password = passwordInput.text ?? ""
                    newUser.phoneNumber = phoneNumberInput.text ?? ""
                    newUser.updateDate = Date.now
                    
                    let res = try await AuthService().UserRegister(user: newUser)
                    let cvRes = try await AuthService().SaveUserResume(fileURL: resumeURL!, fileName: newUser.userID ?? "deneme")
                    
                    if res == true && cvRes == true{
                        self.showCustomAlert(title: "İşlem Başarılı", message: "Başarıyla kaydınız gerçekleşti. Giriş Yapabilirsiniz")
                        navigationController?.popViewController(animated: false)
                    }else{
                        self.showCustomAlert(title: "Hata", message: "Kayıt gerçekleşmedi. Tekrar Deneyiniz")
                    }
                    
                }else{
                    self.showCustomAlert(title: "Hata", message: "Şifre ve Şifre Tekrarı Aynı olmalıdır. Tekrar Deneyiniz.")
                }
                
            }else{
                self.showCustomAlert(title: "Hata", message: "Alanlar Boş Bırakılamaz. Tüm alanları eksiksiz doldurduğunuzu kontrol edip tekrar deneyiniz")
            }
            
        
        }
        
    }
    
    @IBAction func uploadCvButton(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
                documentPicker.delegate = self
                documentPicker.modalPresentationStyle = .formSheet
                self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
           guard let selectedFileURL = urls.first else {
               return
           }
        resumeURL = selectedFileURL;
        userResumeNameInput.text = resumeURL?.lastPathComponent ?? "tekrar deneyiniz"
        
       }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return jobDetailList.count
        }
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            jobDetailList[row]
        default:
            return "Data not found"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
        case 1:
            jobInput.text = jobDetailList[row].job?.name
            selectedJob = jobDetailList[row].job!
            jobInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat
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
