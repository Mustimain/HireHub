//
//  UserJobApplicationViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 26.05.2024.
//

import UIKit

class UserJobApplicationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var jobApplicationTableView: UITableView!
    var jobApplicationDetailList : [JobApplicationDetail] = []
    var selectedJobApplication : JobApplicationDetail = JobApplicationDetail()

    override func viewDidLoad() {
        super.viewDidLoad()
        jobApplicationTableView.delegate = self;
        jobApplicationTableView.dataSource = self;
        Task { @MainActor in
            jobApplicationDetailList.removeAll(keepingCapacity:false)
            jobApplicationTableView.reloadData();
            await GetAllJobApplicationDetails();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { @MainActor in
            
            

            navigationController?.setNavigationBarHidden(true, animated: animated)

        }
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "jobApplicationCell", for: indexPath) as! UserAdvertisesTableViewCell;
        cell.companyNameLabel.text = jobApplicationDetailList[indexPath.row].advertiseDetail?.companyDetail?.company?.name;
        cell.jobLabel.text = jobApplicationDetailList[indexPath.row].advertiseDetail?.jobDetail?.job?.name;
        cell.applicationDate.text = dateString;
        cell.applicationStatus.text = jobApplicationDetailList[indexPath.row].jobApplication?.applicationStatus?.description

        cell.companyNameLabel?.textColor = .black
        cell.jobLabel?.textColor = .black
        cell.applicationDate?.textColor = .black
        cell.applicationStatus.textColor = .black
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedJobApplication = jobApplicationDetailList[indexPath.row]
        
        if let jobApplicationDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApplicationDetailViewController") as? ApplicationDetailViewController{
            jobApplicationDetailVC.selectedJobApplicationDetail = selectedJobApplication
            navigationController?.pushViewController(jobApplicationDetailVC, animated: true)
        }
         
    }
    
    func GetAllJobApplicationDetails() async{
        Task { @MainActor in
            jobApplicationDetailList.removeAll(keepingCapacity: false);
            self.jobApplicationDetailList = try await JobApplicationService().GetAllJobApplicationDetailsByUserId(userId: GlobalVeriables.currentUser?.user?.userID ?? "");
            jobApplicationTableView.reloadData()
        }
    }

}
