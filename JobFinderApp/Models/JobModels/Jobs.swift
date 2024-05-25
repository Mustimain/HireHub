//
//  Jobs.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation
import FirebaseFirestore

struct Job : Codable{
    
    @DocumentID var  jobID : String? = UUID().uuidString
    var  name : String?
    var  sectorID : String?
 
}
