//
//  CompanyRegisterViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit
import GoogleMaps
import CoreLocation

class CompanyRegisterViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var companyNameInput: UITextField!
    @IBOutlet weak var sectorInput: UITextField!
    @IBOutlet weak var employeeSizeInput: UITextField!
    @IBOutlet weak var avarageSalaryInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rePasswordInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    
    @IBOutlet weak var mapView: UIView!

    let locationManager = CLLocationManager()
    let options = GMSMapViewOptions()
    let marker = GMSMarker()
    let googleMapView = GMSMapView()
    
    var sectorPicker = UIPickerView();
    var employeeSizePicker = UIPickerView();
    var averageSalaryPicker = UIPickerView();

    
    var sectorList: [Sector] = []
    var employeeSizeList : [String] = []
    var selectedSector : Sector = Sector()
    var selectedSalaryLevel : AverageSalaryEnum?
    var selectedEmployeeSize : EmployeeSizeEnum?
    let salaryLevels = AverageSalaryEnum.allCases
    let employeeSizes = EmployeeSizeEnum.allCases


    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        
        sectorInput.inputView = sectorPicker;
        employeeSizeInput.inputView = employeeSizePicker;
        avarageSalaryInput.inputView = averageSalaryPicker;
        sectorPicker.tag = 1
        employeeSizePicker.tag = 2
        averageSalaryPicker.tag = 3

        Task { @MainActor in
            
            await GetAllSector()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.title = ""
    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        Task { @MainActor in
            
            var newCompany = Company()
            newCompany.avarageSalary = .high
            newCompany.description = descriptionInput.text ?? ""
            newCompany.email = emailInput.text ?? ""
            newCompany.employeeSize = .medium
            newCompany.locationLat = marker.position.latitude
            newCompany.locationLong = marker.position.longitude
            newCompany.name = companyNameInput.text ?? ""
            newCompany.password = passwordInput.text ?? ""
            newCompany.phoneNumber = passwordInput.text ?? ""
            newCompany.registerDate = Date.now
            newCompany.sectorID = selectedSector.sectorID ?? ""
            newCompany.address = addressInput.text ?? ""
            newCompany.updateDate = Date.now
            
            var checkCompanyEmail = try await AuthService().CheckCompanyEmailIsExist(email: emailInput.text!)
            if checkCompanyEmail == false{
                if avarageSalaryInput.text!.count > 0 && descriptionInput.text!.count > 0 && emailInput.text!.count > 0 && employeeSizeInput.text!.count > 0 && companyNameInput.text!.count > 0 && passwordInput.text!.count > 0 && selectedSector.name!.count > 0 && addressInput.text!.count > 0{
                    
                    if passwordInput.text == rePasswordInput.text{
                        let res = try await AuthService().CompanyRegister(company: newCompany)
                        
                        if res == true{
                            self.showCustomAlert(title: "İşlem Başarılı", message: "Kayıt Başarıyla gerçekleşti. Giriş Yapabilirsiniz.")
                        }else{
                            self.showCustomAlert(title: "Hata", message: "Kayıt gerçekleşmedi. Lütfen Sonra tekrar deneyinzi.")
                        }
                    }else{
                        self.showCustomAlert(title: "Hata", message: "Şifre ve Şifre Tekrarı aynı olmalıdır. Kontrol edip tekrar deneyiniz")

                    }
                }else{
                    self.showCustomAlert(title: "Hata", message: "İlgili alanlar boş bırakılamaz. Lütfen boş alanları doldurup tekrar deneyiniz.")

                }
            }else{
                self.showCustomAlert(title: "Hata", message: "Email adresi kullanımda. Lütfen farklı bir email adresi deneyiniz.")

            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else { return}
        googleMapView.selectedMarker?.position = locValue
        googleMapView.camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 6.0);
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
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
            sectorInput.text = sectorList[row].name
            selectedSector = sectorList[row]
            sectorInput.resignFirstResponder() // UIPickerView seçildikten sonra klavyeyi kapat
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
    
 
