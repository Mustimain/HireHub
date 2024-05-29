//
//  AdvertiseAddViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 4.05.2024.
//

import UIKit
import GoogleGenerativeAI


class AdvertiseAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var jobInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    var jobPickerView = UIPickerView();
    
    var joblist: [Job] = []
    var selectedJob : Job = Job()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobPickerView.delegate = self;
        jobPickerView.dataSource = self;
        jobInput.inputView = jobPickerView;
        jobPickerView.tag = 1
        
        Task { @MainActor in
            
            await GetAllJobs()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
    }
    
    @IBAction func AddAdvertiseButton(_ sender: Any) {
        Task { @MainActor in
            
            if titleInput.text!.count > 0 && descriptionInput.text.count > 0 && selectedJob.name!.count > 0{
                var newAdvertise = Advertise()
                newAdvertise.createDate = Date.now
                newAdvertise.title = titleInput.text ?? ""
                newAdvertise.description = descriptionInput.text ?? ""
                newAdvertise.jobId = selectedJob.jobID
                newAdvertise.companyID = GlobalVeriables.currentCompany?.company?.companyID ?? ""
                
                let res = try await AdvertiseService().AddAdvertise(advertise: newAdvertise)
                
                if res == true{
                    self.showCustomAlert(title: "İşlem Başarılı", message: "İlan Başarıyla Oluşturulmuştur")
                    
                }else{
                    self.showCustomAlert(title: "Hata", message: "İlan Oluşturulamadı lütfen daha sonra tekrar deneyiniz.")
                }
            }
            else{
                self.showCustomAlert(title: "Hata", message: "Alanlar boş bırakılamaz lütfen doldurup tekrar deneyiniz.")
                
            }
            
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        
        switch pickerView.tag{
        case 1:
            jobInput.text = joblist[row].name
            selectedJob = joblist[row]
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
    
    func GetDraftJobDetail(job : String) async{
        var companyDetail = GlobalVeriables.currentCompany
        Task{
            let prompt = "Şirket Adı:\(companyDetail?.company?.name!) Şirket Mail:\(companyDetail?.company?.email!) Şirket Adresi:\(companyDetail?.company?.address!) Şirket Ortalama Maaş:\(companyDetail?.company?.avarageSalary!) Şirket Çalışan Sayısı\(companyDetail?.company?.employeeSize!) Şirket Telefon Numarası\(companyDetail?.company?.phoneNumber!) Şirket Tanıtım Açıklaması\(companyDetail?.company?.description)! ve Şirketin Hizmet veridği Sektör:\(companyDetail?.sector?.name) bu şirket verilerine göre \(job) mesleğe göre iş ilan detay taslağı olusturur ve bu verilere göre doldurur musun sadece taslak ver lütfen"
            
            let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: "AIzaSyCA20uqUiqiPRdyqNZDT7-0L_8_H_633FU")
            
            do{
                let response = try await model.generateContent(prompt)
                guard let text = response.text else{
                    print("Hata Veri Gelmedi")
                    return
                }
                
                descriptionInput.text = text
            }catch{
                print(error.localizedDescription)

            }
            
        }
    }
    
    @IBAction func CreateDraftAdvertiseButton(_ sender: Any) {
        if selectedJob.name?.count ?? 0 > 0 && titleInput.text?.count ?? 0 > 0 {
            Task{
                await self.GetDraftJobDetail(job: selectedJob.name ?? "")
            }
        }else{
            self.showCustomAlert(title: "Bilgilendirme", message: "Taslak Oluşturmak için lütfen bir meslek ve İlan başlığı girip tekrar deneyiniz.")
        }
      
    }
    
}
