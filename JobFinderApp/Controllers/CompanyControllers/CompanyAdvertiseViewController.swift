//
//  CompanyAdvertiseViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyAdvertiseViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    


    @IBOutlet weak var AdvertisesTableView: UITableView!
    
    var advertiseDetailList : [AdvertiseDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdvertisesTableView.delegate = self;
        AdvertisesTableView.dataSource = self;
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { @MainActor in
            
            await GetAllAdvertiseByCompanyId();
            navigationController?.setNavigationBarHidden(true, animated: animated)

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Bu view controller'dan çıkıldığında navigation barı tekrar göster
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    

    @IBAction func GoAdvertiseAddView(_ sender: Any) {
        
        if let advertiseAddViewController = storyboard?.instantiateViewController(withIdentifier: "AdvertiseAddViewController") as? AdvertiseAddViewController{
            navigationController?.pushViewController(advertiseAddViewController, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advertiseDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: advertiseDetailList[indexPath.row].advertise?.createDate ?? Date.now)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyCustomTableViewCell;
        cell.titleLabel.text = advertiseDetailList[indexPath.row].advertise?.title;
        cell.jobLabel.text = advertiseDetailList[indexPath.row].jobDetail?.job?.name;
        cell.createDateLabel.text = dateString;

        cell.titleLabel?.textColor = .black
        cell.jobLabel?.textColor = .black
        cell.createDateLabel?.textColor = .black

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = advertiseDetailList[indexPath.row]
        
        if let compamyAdvertiseDetailVC = storyboard?.instantiateViewController(withIdentifier: "compamyAdvertiseDetailViewController") as? CompanyAdvertiseDetailViewController{
            compamyAdvertiseDetailVC.selectedAdvetiseDetail = selectedItem
            navigationController?.pushViewController(compamyAdvertiseDetailVC, animated: true)
        }
    }
    

    
    func GetAllAdvertiseByCompanyId() async{
        Task { @MainActor in
            advertiseDetailList.removeAll(keepingCapacity: false);
            self.advertiseDetailList = try await AdvertiseService().GetAllAdvertiseDetailByCompanyId(companyId: GlobalVeriables.currentCompany?.company?.companyID ?? "");
            AdvertisesTableView.reloadData()
        }
    }
    

}
