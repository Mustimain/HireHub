//
//  Jobs.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation
import FirebaseFirestore

struct Job : Codable{
    
    @DocumentID var  jobId : String? = UUID().uuidString
    var  name : String?
    var  sectorId : String?
 
}
