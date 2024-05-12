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
        Task { @MainActor in
            
            await GetAllAdvertiseByCompanyId();
            
        }
        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = AdvertisesList[indexPath.row].title;
        cell.textLabel?.textColor = .black
        return cell;
    }
    
    func GetAllAdvertiseByCompanyId() async{
        Task { @MainActor in
            
            self.AdvertisesList = try await AdvertiseService().GetAllAdvertiseByCompanyId(companyId: GlobalVeriables.currentCompany?.companyID ?? "");
            AdvertisesTableView.reloadData()
        }
    }
    

}
