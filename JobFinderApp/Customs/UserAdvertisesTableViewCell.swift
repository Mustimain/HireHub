//
//  UserAdvertisesTableViewCell.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 26.05.2024.
//

import UIKit

class UserAdvertisesTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var applicationDate: UILabel!
    @IBOutlet weak var applicationStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
