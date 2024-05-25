//
//  AdvertiseAddViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 4.05.2024.
//

import UIKit

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
            
            var newAdvertise = Advertise()
            newAdvertise.createDate = Date.now
            newAdvertise.title = titleInput.text ?? ""
            newAdvertise.description = descriptionInput.text ?? ""
            newAdvertise.jobId = selectedJob.jobID
            newAdvertise.companyID = GlobalVeriables.currentCompany?.company?.companyID ?? ""
            
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


}
