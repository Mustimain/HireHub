//
//  CompanyJobApplicationTableViewCell.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.05.2024.
//

import UIKit

class CompanyJobApplicationTableViewCell: UITableViewCell {

    @IBOutlet weak var userFullNameInput: UILabel!
    @IBOutlet weak var jobInput: UILabel!
    @IBOutlet weak var applicationDateInput: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
