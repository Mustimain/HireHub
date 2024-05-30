//
//  CompanyJobApplicationViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyJobApplicationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var jobApplicationDetailList : [JobApplicationDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { @MainActor in
            jobApplicationDetailList.removeAll(keepingCapacity:false)
            tableView.reloadData()
            await GetAllJobApplicationByCompanyId();

        }
            navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Bu view controller'dan çıkıldığında navigation barı tekrar göster
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobApplicationDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: jobApplicationDetailList[indexPath.row].jobApplication?.applicationDate ?? Date.now)

        let cell = tableView.dequeueReusableCell(withIdentifier: "companyJonAppCell", for: indexPath) as! CompanyJobApplicationTableViewCell;
        cell.userFullNameInput.text = "\(jobApplicationDetailList[indexPath.row].userDetail?.user?.firstName ?? "") \(jobApplicationDetailList[indexPath.row].userDetail?.user?.lastName ?? "" )";
        
        cell.jobInput.text = jobApplicationDetailList[indexPath.row].advertiseDetail?.jobDetail?.job?.name
        cell.applicationDateInput.text = dateString;

        cell.userFullNameInput?.textColor = .black
        cell.jobInput?.textColor = .black
        cell.applicationDateInput?.textColor = .black

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.count > 0{
            let selectedItem = jobApplicationDetailList[indexPath.row]
            
            if let applicationDetailVC = storyboard?.instantiateViewController(withIdentifier: "CompanyApplicationDetailViewController") as? CompanyApplicationDetailViewController{
                applicationDetailVC.selectedApplicationDetail = selectedItem
                navigationController?.pushViewController(applicationDetailVC, animated: true)
            }
        }
      
        
    }
    
    
    func GetAllJobApplicationByCompanyId() async{
        Task { @MainActor in
            jobApplicationDetailList.removeAll(keepingCapacity: false);
            self.jobApplicationDetailList = try await JobApplicationService().GetAllJobApplicationDetailsByCompanyId(companyId: GlobalVeriables.currentCompany?.company?.companyID ?? "")
            tableView.reloadData()
        }
    }

}
