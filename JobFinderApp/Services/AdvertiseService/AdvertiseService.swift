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
    var advertises : [Advertise] = []
    var advertiseDetails : [AdvertiseDeteail] = []

    
    func GetAllAdvertiseByCompanyId(companyId: String) async throws -> [Advertise] {
        advertises.removeAll(keepingCapacity: false)
        
        let query = db.collection("Advertises").whereField("companyID", isEqualTo: companyId)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let advertise = try document.data(as: Advertise.self)
                self.advertises.append(advertise);
            } catch {
            }
        }
        
        return advertises;
    }
    
    
    func GetAllAdvertises() async throws -> [Advertise] {
        advertises.removeAll(keepingCapacity: false)
        
        let query = db.collection("Advertises")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let advertise = try document.data(as: Advertise.self)
                self.advertises.append(advertise);
            } catch {
            }
        }
        
        return advertises;
    }
    

    
    func GetAllAdvertiseDetail() async throws -> [AdvertiseDeteail] {
        
        var allAdvertise = try await self.GetAllAdvertises();
    
        if allAdvertise.count > 0{
            for advertise in allAdvertise {
                var newAdvertiseDetail = AdvertiseDeteail();
                newAdvertiseDetail.advertise = advertise
                newAdvertiseDetail.company = GlobalVeriables.currentCompany
                advertiseDetails.append(newAdvertiseDetail);
            }
         
        }
        
        return advertiseDetails
    }
    
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
    
    
    
}
