//
//  CompanyProfileViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyProfileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var companyTitleLabel: UILabel!
    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var companySectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    
    var isEditable = false;
    var selectedSector : Sector = Sector()
    var sectorPicker = UIPickerView();
    var employeeSizePicker = UIPickerView();
    var sectorList: [Sector] = []
    var employeeSizeList : [String] = ["1 - 10", "10 - 50" ,"50 - 100","100 - 500"," 500 - 1000", "1000+"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectorPicker.delegate = self;
        sectorPicker.dataSource = self;
        employeeSizePicker.dataSource = self;
        employeeSizePicker.delegate  = self;
        
        companySectorInput.inputView = sectorPicker;
        employeeSizeInput.inputView = employeeSizePicker;
        sectorPicker.tag = 1
        employeeSizePicker.tag = 2
        
        self.companyNameInput.isEnabled = isEditable;
        self.companySectorInput.isEnabled = isEditable;
        self.employeeSizeInput.isEnabled = isEditable;
        self.avarageSalaryInput.isEnabled = isEditable;
        self.descriptionInput.isEnabled = isEditable;
        self.emailInput.isEnabled = isEditable;
        self.phoneNumberInput.isEnabled = isEditable;
        self.addressInput.isEnabled = isEditable;
        
        
        Task { @MainActor in
            
            await GetAllSector()
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        companyTitleLabel.text = GlobalVeriables.currentCompany?.company?.name
        companyNameInput.text =  GlobalVeriables.currentCompany?.company?.name
        companySectorInput.text =  GlobalVeriables.currentCompany?.sector?.name
        employeeSizeInput.text =  GlobalVeriables.currentCompany?.company?.employeeSize
        avarageSalaryInput.text =  GlobalVeriables.currentCompany?.company?.avarageSalary
        emailInput.text =  GlobalVeriables.currentCompany?.company?.email
        descriptionInput.text =  GlobalVeriables.currentCompany?.company?.description
        phoneNumberInput.text =  GlobalVeriables.currentCompany?.company?.phoneNumber
        addressInput.text =  GlobalVeriables.currentCompany?.company?.address
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Bu view controller'dan çıkıldığında navigation barı tekrar göster
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }


    @IBAction func updateProfileButton(_ sender: Any) {
        Task { @MainActor in
            
            if isEditable == true{
                var updateCompany = GlobalVeriables.currentCompany?.company
                updateCompany?.name = companyNameInput.text;
                updateCompany?.sectorID = selectedSector.sectorID
                updateCompany?.employeeSize = employeeSizeInput.text;
                updateCompany?.avarageSalary = avarageSalaryInput.text;
                updateCompany?.description = descriptionInput.text;
                updateCompany?.email = emailInput.text;
                updateCompany?.phoneNumber = phoneNumberInput.text;
                updateCompany?.address = addressInput.text;
                
                var result = try await AuthService().UpdateCompany(company: updateCompany!)
                
                
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
    
    @IBAction func changeEditable(_ sender: Any) {
        changeEditable();

        
    }
    
    func changeEditable(){
        if isEditable == false{
            isEditable = true;
            self.companyNameInput.isEnabled = isEditable;
            self.companySectorInput.isEnabled = isEditable;
            self.employeeSizeInput.isEnabled = isEditable;
            self.avarageSalaryInput.isEnabled = isEditable
            self.descriptionInput.isEnabled = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            self.addressInput.isEnabled = isEditable

            
        }else{
            isEditable = false

            self.companyNameInput.isEnabled = isEditable;
            self.companySectorInput.isEnabled = isEditable;
            self.employeeSizeInput.isEnabled = isEditable;
            self.avarageSalaryInput.isEnabled = isEditable
            self.descriptionInput.isEnabled = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            self.addressInput.isEnabled = isEditable
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
      
            navigationController?.popToRootViewController(animated: false)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return sectorList.count
        }else if (pickerView.tag == 2){
            return employeeSizeList.count
        }
    
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            sectorList[row]
        case 2:
            employeeSizeList[row]
        default:
            return "Data not found"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
        case 1:
            companySectorInput.text = sectorList[row].name
            selectedSector = sectorList[row]
            companySectorInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat
        case 2:
            employeeSizeInput.text = employeeSizeList[row]
            employeeSizeInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat

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
            label?.text = sectorList[row].name
            label?.textColor = UIColor.black
        case 2:
            label?.text = employeeSizeList[row]
            label?.textColor = UIColor.black
        default:
            label?.text =  "Data not found"
        }
  
        
        return label!
    }
    
    func GetAllSector() async{
        Task { @MainActor in
            
            self.sectorList  = try await SectorService().GetAllSectors();
        }
    }
    
}
