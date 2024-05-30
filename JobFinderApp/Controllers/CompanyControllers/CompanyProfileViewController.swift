//
//  CompanyProfileViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit
import GoogleMaps
import CoreLocation

class CompanyProfileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var companyTitleLabel: UILabel!
    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var companySectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var mapView: UIView!
    
    
    let locationManager = CLLocationManager()
    let options = GMSMapViewOptions()
    let marker = GMSMarker()
    let googleMapView = GMSMapView()
    
    
    var isEditable = false;
    var selectedSector : Sector?
    var sectorPicker = UIPickerView();
    var employeeSizePicker = UIPickerView();
    var averageSalaryPicker = UIPickerView();
    var sectorList: [Sector] = []
    
    var selectedSalaryLevel : AverageSalaryEnum?
    var selectedEmployeeSize : EmployeeSizeEnum?
    let salaryLevels = AverageSalaryEnum.allCases
    let employeeSizes = EmployeeSizeEnum.allCases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        googleMapView.delegate = self
        getCurrentLocation()
        options.camera = GMSCameraPosition.camera(withLatitude: 41.015137, longitude: 28.979530, zoom: 8.0);
        
        googleMapView.camera = options.camera!
        googleMapView.frame = self.mapView.bounds
        googleMapView.isMyLocationEnabled = true;
        self.mapView.addSubview(googleMapView)
        
        
        sectorPicker.delegate = self;
        sectorPicker.dataSource = self;
        employeeSizePicker.dataSource = self;
        employeeSizePicker.delegate  = self;
        averageSalaryPicker.dataSource = self;
        averageSalaryPicker.delegate  = self;
        
        companySectorInput.inputView = sectorPicker;
        employeeSizeInput.inputView = employeeSizePicker;
        avarageSalaryInput.inputView = averageSalaryPicker;

        sectorPicker.tag = 1
        employeeSizePicker.tag = 2
        averageSalaryPicker.tag = 3

        
        self.companyNameInput.isEnabled = isEditable;
        self.companySectorInput.isEnabled = isEditable;
        self.employeeSizeInput.isEnabled = isEditable;
        self.avarageSalaryInput.isEnabled = isEditable;
        self.descriptionInput.isEditable = isEditable;
        self.emailInput.isEnabled = isEditable;
        self.phoneNumberInput.isEnabled = isEditable;
        self.addressInput.isEnabled = isEditable;
        
        
        Task { @MainActor in
            
            await GetAllSector()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        companyTitleLabel.text = GlobalVeriables.currentCompany?.company?.name
        companyNameInput.text =  GlobalVeriables.currentCompany?.company?.name
        companySectorInput.text =  GlobalVeriables.currentCompany?.sector?.name
        employeeSizeInput.text =  GlobalVeriables.currentCompany?.company?.employeeSize?.description
        avarageSalaryInput.text =  GlobalVeriables.currentCompany?.company?.avarageSalary?.description
        emailInput.text =  GlobalVeriables.currentCompany?.company?.email
        descriptionInput.text =  GlobalVeriables.currentCompany?.company?.description
        phoneNumberInput.text =  GlobalVeriables.currentCompany?.company?.phoneNumber
        addressInput.text =  GlobalVeriables.currentCompany?.company?.address
        marker.position.latitude = GlobalVeriables.currentCompany?.company?.locationLat ?? 0
        marker.position.longitude = GlobalVeriables.currentCompany?.company?.locationLong ?? 0
        marker.map = googleMapView // Haritada marker'ı güncelle
        
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
                if selectedSector != nil {
                    updateCompany?.sectorID = selectedSector?.sectorID

                }else{
                    updateCompany?.sectorID = GlobalVeriables.currentCompany?.sector?.sectorID
                }
                updateCompany?.employeeSize = selectedEmployeeSize
                updateCompany?.avarageSalary = selectedSalaryLevel
                updateCompany?.description = descriptionInput.text;
                updateCompany?.email = emailInput.text;
                updateCompany?.phoneNumber = phoneNumberInput.text;
                updateCompany?.address = addressInput.text;
                updateCompany?.locationLat = marker.position.latitude
                updateCompany?.locationLong = marker.position.longitude
                
                if companyNameInput.text!.count > 0 && companySectorInput.text!.count > 0 && employeeSizeInput.text!.count > 0 && avarageSalaryInput.text!.count > 0 && emailInput.text!.count > 0 && descriptionInput.text!.count > 0 && phoneNumberInput.text!.count > 0 && addressInput.text!.count > 0{
                    
                    var result = try await AuthService().UpdateCompany(company: updateCompany!)
                    
                    if result == true{
                        self.showCustomAlert(title: "İşlem Başarılı", message: "Bilgiler başarıyla güncellendi.")
                        self.navigationController?.popViewController(animated: false)
                        
                    }else{
                        self.showCustomAlert(title: "Hata", message: "Bilgiler güncellenemedi. Lütfen tekrar deneyiniz.")
                    }
                    
                } else{
                    self.showCustomAlert(title: "Hata", message: "Alanlar boş bırakılamaz. Lütfen ilgili alanalrı doldurup tekrar deneyiniz.")
                }
                
            }else{
                self.showCustomAlert(title: "Hata", message: "Lütfen düzenleme yapmak için düzenlemeyi etkinleştirin.")
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
            self.descriptionInput.isEditable = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            self.addressInput.isEnabled = isEditable
            
            
        }else{
            isEditable = false
            
            self.companyNameInput.isEnabled = isEditable;
            self.companySectorInput.isEnabled = isEditable;
            self.employeeSizeInput.isEnabled = isEditable;
            self.avarageSalaryInput.isEnabled = isEditable
            self.descriptionInput.isEditable = isEditable
            self.emailInput.isEnabled = isEditable
            self.phoneNumberInput.isEnabled = isEditable
            self.addressInput.isEnabled = isEditable
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        
        navigationController?.popToRootViewController(animated: false)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else { return}
        googleMapView.selectedMarker?.position = locValue
        googleMapView.camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 6.0);
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isEditable == true{
            // Marker'ın konumunu tıklanan nokta olarak ayarla
            marker.position = coordinate
            // İsteğe bağlı olarak başlık ve açıklama ekle
            marker.title = "İşyeri Konumu"
            marker.snippet = "Seçilen işyeri konumu"
            
            // Marker'ı haritaya ekle
            marker.map = mapView
            
            let geocoder = CLGeocoder()
            
            // Koordinatları adrese çevirme
            geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks, error) in
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                } else {
                    if let placemark = placemarks?.first {
                        // Adres bilgisini alma
                        let address = placemark.thoroughfare ?? "" // Cadde adı
                        let city = placemark.locality ?? "" // Şehir
                        let country = placemark.country ?? "" // Ülke
                        
                        // Adres string'ini oluşturma
                        let addressString = "\(address), \(city), \(country)"
                        
                        self.addressInput.text = addressString
                        
                    }
                }
                
            }
        }
        
    }
    
    
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return sectorList.count
        }else if (pickerView.tag == 2){
            return employeeSizes.count
        }
        else if (pickerView.tag == 3){
            return salaryLevels.count
        }
    
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag{
        case 1:
            sectorList[row]
        case 2:
            employeeSizes[row].description
        case 3:
            salaryLevels[row].description
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
            employeeSizeInput.text = employeeSizes[row].description
            self.selectedEmployeeSize = employeeSizes[row]
            employeeSizeInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat
        case 3:
            avarageSalaryInput.text = salaryLevels[row].description
            self.selectedSalaryLevel = salaryLevels[row]

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
            label?.text = employeeSizes[row].description
            label?.textColor = UIColor.black
        case 3:
            label?.text = salaryLevels[row].description
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
