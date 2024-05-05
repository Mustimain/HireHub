//
//  Company.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import Foundation
import FirebaseFirestore


struct Company : Codable{
    
    @DocumentID var  companyID : String? = UUID().uuidString
    var name : String?
    var sectorID : String?
    var employeeSize : String?
    var avarageSalary : String?
    var address : String?
    var locationLong : Double?
    var locationLat : Double?
    var description : String?
    var email : String?
    var password : String?
    var phoneNumber : String?
    var registerDate : Date?

}
