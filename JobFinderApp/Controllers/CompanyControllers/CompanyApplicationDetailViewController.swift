import UIKit
import UniformTypeIdentifiers

class CompanyApplicationDetailViewController: UIViewController, UIDocumentPickerDelegate {
    
    var selectedApplicationDetail: JobApplicationDetail?
    
    @IBOutlet weak var userFirstNameInput: UITextField!
    @IBOutlet weak var userLastNameInput: UITextField!
    @IBOutlet weak var userJobInput: UITextField!
    @IBOutlet weak var userEmailInput: UITextField!
    @IBOutlet weak var userPhoneNumberInput: UITextField!
    @IBOutlet weak var userResumeInput: UITextField!
    
    @IBOutlet weak var jobApplicationTitleInpur: UITextField!
    @IBOutlet weak var jobApplicationNameInput: UITextField!
    @IBOutlet weak var jobDescriptionInput: UITextView!
    
    var resumeURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedApplicationDetail != nil {
            userFirstNameInput.text = selectedApplicationDetail?.userDetail?.user?.firstName
            userLastNameInput.text = selectedApplicationDetail?.userDetail?.user?.lastName
            userJobInput.text = selectedApplicationDetail?.userDetail?.jobDetail?.job?.name
            userEmailInput.text = selectedApplicationDetail?.userDetail?.user?.email
            userPhoneNumberInput.text = selectedApplicationDetail?.userDetail?.user?.phoneNumber
            
            jobApplicationTitleInpur.text = selectedApplicationDetail?.advertiseDetail?.advertise?.title
            jobApplicationNameInput.text = selectedApplicationDetail?.advertiseDetail?.jobDetail?.job?.name
            jobDescriptionInput.text = selectedApplicationDetail?.advertiseDetail?.advertise?.description
            
            Task { @MainActor in
                await self.changeJobApplicationStatus(status: .applicationViewed)
                let resume = try await AuthService().GetResumeURL(fileName: selectedApplicationDetail?.userDetail?.user?.userID ?? "")
                if resume.absoluteString.count > 0 {
                    resumeURL = resume
                    userResumeInput.text = resume.absoluteString
                }
                
            }
        }
    }
    
    @IBAction func downloadResumeButton(_ sender: Any) {
        guard resumeURL != nil else {
            self.showCustomAlert(title: "Hata", message: "Dosya Bulunamadı")
            return
        }
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.editButtonItem.title = "Kaydet"
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedFolderURL = urls.first else {
            self.showCustomAlert(title: "Hata", message: "Dosya Bulunamadı")
            return
        }
        
        guard let resumeURL = resumeURL else {
            self.showCustomAlert(title: "Hata", message: "Dosya Bulunamadı")
            return
        }
        
        // Yeni dosya adını kullanıcıdan al
        let alertController = UIAlertController(title: "Dosya Adı", message: "Lütfen dosya adını girin:", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Dosya adı"
        }
        let confirmAction = UIAlertAction(title: "Kaydet", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let newFileName = alertController.textFields?.first?.text, !newFileName.isEmpty {
                let destinationURL = pickedFolderURL.appendingPathComponent("\(newFileName).pdf")
                do {
                    let data = try Data(contentsOf: resumeURL)
                    try data.write(to: destinationURL)
                    
                    Task {
                        await self.changeJobApplicationStatus(status: .cvDownloaded)

                    }
                    self.showCustomAlert(title: "Başarılı", message: "PDF başarıyla kaydedildi:")
                } catch {
                    self.showCustomAlert(title: "Hata", message: "Aynı PDF mevcut lütfen ismini tekrar giriniz. ")
                }
            } else {
                self.showCustomAlert(title: "Hata", message: "Geçerli bir dosya adı girin.")
            }
        }
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeJobApplicationStatus(status : ApplicationStatusEnum) async{
        Task {
            if selectedApplicationDetail?.jobApplication != nil{
                var updateApplicationDetail = selectedApplicationDetail
                updateApplicationDetail?.jobApplication?.applicationStatus = status
                var res = try await JobApplicationService().ChangeJobApplicationStatus(jobApplication: (updateApplicationDetail?.jobApplication)!)

            }
        }
    }


}
