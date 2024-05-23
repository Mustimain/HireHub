//
//  CompanyAdvertiseViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import UIKit

class CompanyAdvertiseViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    


    @IBOutlet weak var AdvertisesTableView: UITableView!
    
    var AdvertisesList : [Advertise] = []
    
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
        return AdvertisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: AdvertisesList[indexPath.row].createDate!)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyCustomTableViewCell;
        cell.titleLabel.text = AdvertisesList[indexPath.row].title;
        cell.jobLabel.text = AdvertisesList[indexPath.row].jobId;
        cell.createDateLabel.text = dateString;

        cell.titleLabel?.textColor = .black
        cell.jobLabel?.textColor = .black
        cell.createDateLabel?.textColor = .black

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = AdvertisesList[indexPath.row]
        
        if let compamyAdvertiseDetailVC = storyboard?.instantiateViewController(withIdentifier: "compamyAdvertiseDetailViewController") as? CompanyAdvertiseDetailViewController{
            compamyAdvertiseDetailVC.selectedAdvetise = selectedItem
            navigationController?.pushViewController(compamyAdvertiseDetailVC, animated: true)
        }
    }
    

    
    func GetAllAdvertiseByCompanyId() async{
        Task { @MainActor in
            AdvertisesList.removeAll(keepingCapacity: false);
            self.AdvertisesList = try await AdvertiseService().GetAllAdvertiseByCompanyId(companyId: GlobalVeriables.currentCompany?.companyID ?? "");
            AdvertisesTableView.reloadData()
        }
    }
    

}
