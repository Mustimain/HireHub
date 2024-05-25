//
//  JobApplication.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 25.05.2024.
//

import Foundation
import FirebaseFirestore

struct JobApplication : Codable{
    @DocumentID var  jobApplicationID : String? = UUID().uuidString
    var userID : String?
    var advertiseID : String
    var applicationDate : Date?

}
