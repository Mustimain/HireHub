//
//  CompanyAdvertiseDetailViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 23.05.2024.
//

import UIKit

class CompanyAdvertiseDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedAdvetiseDetail: AdvertiseDetail?
    var isEditable = false;
    
    @IBOutlet weak var advertiseTitleInput: UITextField!
    @IBOutlet weak var advertiseJobInput: UITextField!
    @IBOutlet weak var advertiseDescriptionInput: UITextView!
    @IBOutlet weak var myButton: UIButton!
    
    var jobPickerView = UIPickerView();
    var joblist: [Job] = []
    var selectedJob : Job = Job()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobPickerView.delegate = self;
        jobPickerView.dataSource = self;
        advertiseJobInput.inputView = jobPickerView;
        jobPickerView.tag = 1
        
        self.advertiseJobInput.isEnabled = isEditable
        self.advertiseTitleInput.isEnabled = isEditable
        self.advertiseDescriptionInput.isEditable = isEditable
        
        advertiseTitleInput.text = selectedAdvetiseDetail?.advertise?.title
        advertiseJobInput.text = selectedAdvetiseDetail?.jobDetail?.job?.name
        advertiseDescriptionInput.text = selectedAdvetiseDetail?.advertise?.description
        selectedJob = selectedAdvetiseDetail?.jobDetail?.job ?? Job()
        
        if selectedAdvetiseDetail?.advertise?.isActive == true{
            myButton.setTitle("İlanı Kaldır", for:  .normal)
        }else{
            myButton.setTitle("İlana Yayınla", for:  .normal)
        }
        
        Task { @MainActor in
            
            await GetAllJobs()
        }
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        
        changeEditable();
        
    }
    @IBAction func updateButton(_ sender: Any) {
        
        Task { @MainActor in
            if isEditable == true{
                selectedAdvetiseDetail?.advertise?.title = advertiseTitleInput.text
                selectedAdvetiseDetail?.advertise?.jobId =  selectedJob.jobID
                selectedAdvetiseDetail?.advertise?.description = advertiseDescriptionInput.text
                
                if advertiseTitleInput.text!.count > 0 && advertiseDescriptionInput.text.count > 0 && selectedJob.name!.count > 0{
                    let res = try await AdvertiseService().UpdateAdvertise(advertise: (selectedAdvetiseDetail?.advertise!)!)
                    
                    if res == true{
                        
                        self.showCustomAlert(title: "İşlem Başarılı", message: "Bilgiler başarıyla güncellendi.")
                    }else{
                        self.showCustomAlert(title: "Hata", message: "Güncelleme işlemi başarısı.Lütfen daha sonra tekrar deneyiniz.")
                    }
                }else{
                    self.showCustomAlert(title: "Hata", message: "Alanlar Boş bırakılamaz lütfen alanları doldurup tekrar deneyiniz.")
                }
            }else{
                self.showCustomAlert(title: "Hata", message: "Güncelleme yapmak için düzenlemeyi etkinleştiriniz.")
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return joblist.count
        }
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            joblist[row]
            
        default:
            return "Data not found"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
        case 1:
            advertiseJobInput.text = joblist[row].name
            selectedJob = joblist[row]
            advertiseJobInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat
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
            label?.text = joblist[row].name
            label?.textColor = UIColor.black
            
        default:
            label?.text =  "Data not found"
        }
        
        
        return label!
    }
    
    
    func GetAllJobs() async{
        Task { @MainActor in
            
            self.joblist  = try await JobService().GetAllJobs();
        }
    }
    @IBAction func disableJobApplicationButton(_ sender: Any) {
        Task { @MainActor in
            
            if selectedAdvetiseDetail?.advertise?.isActive == true{
                var newAdvertiseDetail = selectedAdvetiseDetail
                newAdvertiseDetail?.advertise?.isActive = false
                var res = try await AdvertiseService().UpdateAdvertise(advertise: (newAdvertiseDetail?.advertise)!)
                if res == true{
                    self.showCustomAlert(title: "İşlem Başarılı", message: "İlan Başarıyla Yayından kaldırıldı.")
                }else{
                    self.showCustomAlert(title: "Hata", message: "İşlem Gerçekleşmedi. Daha sonra tekrar deneyiniz.")
                }
                
            }else{
                var newAdvertiseDetail = selectedAdvetiseDetail
                newAdvertiseDetail?.advertise?.isActive = true
                var res = try await AdvertiseService().UpdateAdvertise(advertise: (newAdvertiseDetail?.advertise)!)
                
                if res == true{
                    self.showCustomAlert(title: "İşlem Başarılı", message: "İlan Başarıyla Tekrar Yayınlandı.")
                }else{
                    self.showCustomAlert(title: "Hata", message: "İşlem Gerçekleşmedi. Daha sonra tekrar deneyiniz.")
                }
            }
            
        }
    }
    
    
}
