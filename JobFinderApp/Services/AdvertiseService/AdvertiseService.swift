//
//  AdvertiseService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 8.05.2024.
//

import Foundation
import Firebase


class AdvertiseService : AdvertiseProtocol{
    
    let db = Firestore.firestore()

    func AddAdvertise(advertise: Advertise) async throws -> Bool {
        
        if (advertise.advertiseID?.count ?? 0 > 0){
            do {
                try db.collection("Advertises").document(advertise.advertiseID!).setData(from: advertise)
                return true;
            } catch _ {
                return false;
            }
        }
        
        return false;
    }
    
    
    func GetAllAdvertiseBySector(sectorId: String) async throws -> Bool {
        return false;
    }
    
    
    
}
