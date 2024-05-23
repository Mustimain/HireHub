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
    var advertiseDetails : [AdvertiseDetail] = []

    
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
    

    
    func GetAllAdvertiseDetail() async throws -> [AdvertiseDetail] {
        
        let allAdvertise = try await self.GetAllAdvertises();
        let allCompanies = try await AuthService().GetAllCompanies();
        
        if allAdvertise.count > 0{
            for company in allCompanies {
                
                for advertise in allAdvertise {
                    if advertise.companyID == company.companyID{
                        var newAdvertiseDetail = AdvertiseDetail();
                        newAdvertiseDetail.advertise = advertise
                        newAdvertiseDetail.company = company
                        advertiseDetails.append(newAdvertiseDetail);
                    }
             
                }
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
    
    
    func UpdateAdvertise(advertise:Advertise) async throws -> Bool {
        guard let advertiseID = advertise.advertiseID, !advertiseID.isEmpty else {
                return false
            }
        
        do {
                // Advertise modelinin tüm alanlarını içeren bir sözlük oluşturun
                let advertiseData = try Firestore.Encoder().encode(advertise)
                
                // Firestore'da belgeyi güncelle
                try await db.collection("Advertises").document(advertiseID).updateData(advertiseData)
                return true
            } catch {
                return false
            }
    }
}
