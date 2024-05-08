//
//  Advertise.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 8.05.2024.
//

import Foundation
import FirebaseFirestore


struct Advertise : Codable{
    
    @DocumentID var  advertiseID : String? = UUID().uuidString
    var  companyID : String?
    var  jobId : String?
    var  description : String?
    var  createDate : Date?
    var  title : String?






    
    
}
