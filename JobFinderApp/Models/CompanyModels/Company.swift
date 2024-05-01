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
    var employeeSize : Int?
    var avarageSalary : String?
    var locationLong : String?
    var locationLat : String?
    var description : String?
    var email : String?
    var password : String?
    var phoneNumber : String?
    var registerDate : Date?

}
