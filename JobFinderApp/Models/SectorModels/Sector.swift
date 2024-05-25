//
//  Sector.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation
import FirebaseFirestore


struct Sector : Codable{
    
    @DocumentID var  sectorID : String? = UUID().uuidString
    var  name : String?
 
}
