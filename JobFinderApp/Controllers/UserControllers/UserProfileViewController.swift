//
//  UserProfileViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit

class UserProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIDocumentPickerDelegate {
    
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userFirstNameInput: UITextField!
    @IBOutlet weak var userLastNameInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var resumeNameInput: UITextField!
    
    var isEditable = false;
    var selectedJob : Job?
    var jobPicker = UIPickerView();
    var experienceYearPicker = UIPickerView();
    var jobList: [Job] = []
    var resumePdfURL : URL?
    var newResumePdfURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobPicker.delegate = self;
        jobPicker.dataSource = self;
        experienceYearPicker.dataSource = self;
        experienceYearPicker.delegate  = self;
        
        jobInput.inputView = jobPicker;
        jobPicker.tag = 1
        
        
        self.userFullNameLabel.isEnabled = isEditable;
        self.userFirstNameInput.isEnabled = isEditable;
        self.userLastNameInput.isEnabled = isEditable;
        self.jobInput.isEnabled = isEditable;
        self.emailInput.isEnabled = isEditable;
        self.phoneNumberInput.isEnabled = isEditable;
        self.jobInput.text = GlobalVeriables.currentUser?.jobDetail?.job?.name
        
        Task { @MainActor in
            
            await GetAllJobs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { @MainActor in
            
            resumePdfURL = try await AuthService().GetResumeURL(fileName: (GlobalVeriables.currentUser?.user?.userID)!)
            
            self.userFullNameLabel.text = (GlobalVeriables.currentUser?.user?.firstName ?? "") + " " + (GlobalVeriables.currentUser?.user?.lastName ?? "")
            self.userFirstNameInput.text = GlobalVeriables.currentUser?.user?.firstName;
            self.userLastNameInput.text = GlobalVeriables.currentUser?.user?.lastName;
            self.jobInput.text = GlobalVeriables.currentUser?.jobDetail?.job?.name
            self.emailInput.text = GlobalVeriables.currentUser?.user?.email;
            self.phoneNumberInput.text = GlobalVeriables.currentUser?.user?.phoneNumber;
            
            self.resumeNameInput.text = resumePdfURL?.lastPathComponent ?? "Özgeçmiş Bulunamadı";
            
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: false)
        
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
                updateUser?.jobID = selectedJob?.jobID ?? GlobalVeriables.currentUser?.jobDetail?.job?.jobID!
                updateUser?.email = emailInput.text;
                updateUser?.phoneNumber = phoneNumberInput.text;
                
                if userFirstNameInput.text!.count > 0 && userLastNameInput.text!.count > 0 && emailInput.text!.count > 0 && phoneNumberInput.text?.count ?? 0 > 0  && selectedJob != nil {
                    var result = try await AuthService().UpdateUser(user: updateUser!)
                    
                    if newResumePdfURL == nil{
                        
                        var res = try await AuthService().UpdateUserResume(fileURL: resumePdfURL!, fileName: (GlobalVeriables.currentUser?.user?.userID)!)
                        if res == false{
                            self.showCustomAlert(title: "Hata", message: "Özgeçmiş Güncellenemedi.")
                        }
                        
                    }else{
                        var ress = try await AuthService().SaveUserResume(fileURL: newResumePdfURL!, fileName: (GlobalVeriables.currentUser?.user?.userID)!)
                        if ress == false{
                            self.showCustomAlert(title: "Hata", message: "Özgeçmiş Yüklenemedi.")
                        }
                    }
                    
                    if result == true{
                        
                        self.showCustomAlert(title: "Güncelleme Başarılı", message: "Profil bilgileri başarıyla güncellendi.")
                        
                    } else{
                        self.showCustomAlert(title: "Hata", message: "Profil bilgileri güncellenemedi. Lütfen tekrar deneyiniz.")
                        
                    }
                    
                }else{
                    self.showCustomAlert(title: "Hata", message: "Alanlar ve Özgeçmiş boş olamaz lütfen tekrar deneyiniz")
                    
                }
            }else{
                self.showCustomAlert(title: "Hata", message: "Lütfen Profil düzenlemeyi etkinleştirip tekrar deneyiniz.")
            }
        }
    }
    
    func GetAllJobs() async{
        Task { @MainActor in
            jobList = try await JobService().GetAllJobs()
            var url = try await AuthService().GetResumeURL(fileName: GlobalVeriables.currentUser?.user?.userID ?? "")
            if url.absoluteString.count > 0 && url != nil{
                resumePdfURL = url
                
            }
            
            
        }
    }
    
    func changeEditable(){
        if isEditable == false{
            isEditable = true;
            self.userFirstNameInput.isEnabled = isEditable;
            self.userLastNameInput.isEnabled = isEditable;
            self.jobInput.isEnabled = isEditable;
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            
            
            
        }else{
            isEditable = false
            
            self.userFirstNameInput.isEnabled = isEditable;
            self.userLastNameInput.isEnabled = isEditable;
            self.jobInput.isEnabled = isEditable;
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
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            jobList[row]
            
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
        default:
            label?.text =  "Data not found"
        }
        
        
        return label!
    }
    @IBAction func uploadResumeButton(_ sender: Any) {
        if isEditable == true{
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }else{
            self.showCustomAlert(title: "Hata", message: "Lütfen düzenlemeyi etkinlşetirin.")
        }
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        newResumePdfURL = selectedFileURL;
        resumeNameInput.text = newResumePdfURL?.lastPathComponent ?? "tekrar deneyiniz"
        
    }
}
