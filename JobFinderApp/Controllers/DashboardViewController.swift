//
//  DashboardViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit
import Firebase


class DashboardViewController: UIViewController {
    
    var jobDetailList: [JobDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func UserLoginButton(_ sender: Any) {
        
        if let userLoginVC = storyboard?.instantiateViewController(withIdentifier: "UserLoginViewController") as? UserLoginViewController{
            navigationController?.pushViewController(userLoginVC, animated: true)
        }
        
    }
    
    
    @IBAction func CompanyLoginButton(_ sender: Any) {
        
        if let companyLoginVC = storyboard?.instantiateViewController(withIdentifier: "CompanyLoginViewController") as? CompanyLoginViewController{
            navigationController?.pushViewController(companyLoginVC, animated: true)
        }
    }
    

    /*
    
    @IBAction func AddSector(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        
        // Örnek veri seti (sektörler ve meslekler)
        let sectorsAndJobs: [String: [String]] = [
            "Adalet ve Güvenlik": ["Avukat", "Hakim", "Polis Memuru", "Güvenlik Görevlisi", "Özel Dedektif"],
            "Ağaç İşleri, Kağıt ve Kağıt Ürünleri": ["Orman Mühendisi", "Ağaç İşleri Teknikeri", "Kağıt Fabrikası İşçisi", "Mobilya Tasarımcısı"],
            "Bilişim Teknolojileri": ["Yazılım Geliştirici", "Sistem Mühendisi", "Bilgisayar Destek Uzmanı", "Veri Analisti"],
            "Cam, Çimento ve Toprak": ["Cam İşçisi", "Çimento Fabrikası İşçisi", "Toprak Mühendisi", "Seramik Sanatçısı"],
            "Çevre": ["Çevre Mühendisi", "Çevre Danışmanı", "Atık Yönetim Uzmanı", "Su Kalite Teknisyeni"],
            "Eğitim": ["Öğretmen", "Akademisyen", "Rehberlik Uzmanı", "Okul Müdürü"],
            "Elektrik ve Elektronik": ["Elektrik Mühendisi", "Elektronik Teknisyeni", "Telekomünikasyon Uzmanı", "Robotik Mühendisi"],
            "Enerji": ["Enerji Mühendisi", "Petrol Mühendisi", "Rüzgar Enerjisi Teknisyeni", "Güneş Enerjisi Uzmanı"],
            "Finans": ["Bankacı", "Muhasebeci", "Finansal Danışman", "Sigorta Acentesi"],
            "Gıda": ["Gıda Mühendisi", "Aşçı", "Gıda Güvenliği Uzmanı", "Tarım Teknikeri"],
            "İnşaat": ["İnşaat Mühendisi", "İnşaat İşçisi", "Mimar", "Yapı Denetçisi"],
            "İş ve Yönetim": ["İşletme Yöneticisi", "İnsan Kaynakları Uzmanı", "Pazarlama Müdürü", "Proje Yöneticisi"],
            "Kimya, Petrol, Lastik ve Plastik": ["Kimya Mühendisi", "Petrol Rafineri İşçisi", "Lastik Uzmanı", "Plastik Ürün Tasarımcısı"],
            "Kültür, Sanat ve Tasarım": ["Sanatçı", "Grafik Tasarımcı", "Müze Küratörü", "Moda Tasarımcısı"],
            "Maden": ["Madencilik Mühendisi", "Maden İşçisi", "Jeolog", "Tünel Mühendisi"],
            "Makine": ["Makine Mühendisi", "Tesisatçı", "Otomasyon Uzmanı", "Jeneratör Teknisyeni"],
            "Medya, İletişim ve Yayıncılık": ["Gazeteci", "TV Yapımcısı", "Medya Planlama Uzmanı", "Sosyal Medya Yöneticisi"],
            "Metal": ["Metalurji Mühendisi", "Kaynakçı", "Döküm Operatörü", "CNC Makine Operatörü"],
            "Otomotiv": ["Otomotiv Mühendisi", "Oto Tamircisi", "Oto Elektrikçisi", "Araba Satış Danışmanı"],
            "Sağlık ve Sosyal Hizmetler": ["Doktor", "Hemşire", "Psikolog", "Sosyal Hizmet Uzmanı"],
            "Spor ve Rekreasyon": ["Antrenör", "Fitness Eğitmeni", "Spor Yöneticisi", "Tur Rehberi"],
            "Tarım, Avcılık ve Balıkçılık": ["Ziraat Mühendisi", "Çiftçi", "Avcı", "Balıkçı"],
            "Tekstil, Hazır Giyim, Deri": ["Tekstil Mühendisi", "Konfeksiyon İşçisi", "Moda Tasarımcısı", "Deri Uzmanı"],
            "Ticaret (Satış ve Pazarlama)": ["Satış Temsilcisi", "Pazarlama Müdürü", "Perakende Satış Danışmanı", "Mağaza Müdürü"],
            "Toplumsal ve Kişisel Hizmetler": ["Kuaför", "Temizlik Görevlisi", "Event Yöneticisi", "Terapist"],
            "Turizm, Konaklama, Yiyecek-İçecek Hizmetleri": ["Otel Yöneticisi", "Turist Rehberi", "Aşçı", "Barista"],
            "Ulaştırma, Lojistik ve Haberleşme": ["Lojistik Uzmanı", "Kargo Kuryesi", "Telekomünikasyon Teknisyeni", "Uçak Pilotu"]
        ]
        
        
        for (sector, jobs) in sectorsAndJobs {
            let sectorRef = db.collection("Sectors").document()
            
            sectorRef.setData([
                "name": sector
            ]) { error in
                if let error = error {
                    print("Sektor belgesi eklenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    print("Sektor belgesi başarıyla eklendi: \(sector)")
                    
                    // Meslekleri Jobs koleksiyonuna ekleme
                    for job in jobs {
                        db.collection("Jobs").addDocument(data: [
                            "name": job,
                            "sectorID": sectorRef.documentID  // Sektör belge kimliği ile ilişkilendirme
                        ]) { error in
                            if let error = error {
                                print("Meslek eklenirken hata oluştu: \(error.localizedDescription)")
                            } else {
                                print("Meslek başarıyla eklendi: \(job)")
                            }
                        }
                    }
                }
            }
        }
     */
    
}
    
