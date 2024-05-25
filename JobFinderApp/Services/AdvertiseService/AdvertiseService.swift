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

    
    func GetAllAdvertiseByCompanyId(companyId: String) async throws -> [Advertise] {
        
        var advertises : [Advertise] = []
        let query = db.collection("Advertises").whereField("companyID", isEqualTo: companyId)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let advertise = try document.data(as: Advertise.self)
                advertises.append(advertise);
            } catch {
            }
        }
        
        return advertises;
    }
    
    
    func GetAllAdvertises() async throws -> [Advertise] {
        var advertises : [Advertise] = []
        let query = db.collection("Advertises")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let advertise = try document.data(as: Advertise.self)
                advertises.append(advertise);
            } catch {
            }
        }
        
        return advertises;
    }
    

    
    func GetAllAdvertiseDetail() async throws -> [AdvertiseDetail] {
        var advertiseDetails : [AdvertiseDetail] = []
        let allAdvertise = try await self.GetAllAdvertises();
        let allCompanies = try await AuthService().GetAllCompanies();
        let allJobDetails = try await JobService().GetAllJobDetails()
        
        if allAdvertise.count > 0{
            for jobDetail in allJobDetails {
                for company in allCompanies {
                    for advertise in allAdvertise {
                        if advertise.companyID == company.companyID && advertise.jobId == jobDetail.job?.jobID{
                            var newAdvertiseDetail = AdvertiseDetail();
                            newAdvertiseDetail.advertise = advertise
                            newAdvertiseDetail.companyDetail?.company = company
                            newAdvertiseDetail.jobDetail = jobDetail;
                            advertiseDetails.append(newAdvertiseDetail);
                        }
                 
                    }

                }
            }
     
         
        }
        
        return advertiseDetails
    }
    
    func AddAdvertise(advertise: Advertise) async throws -> Bool {
        guard let advertiseID = advertise.advertiseID, !advertiseID.isEmpty else {
                return false
            }
            do {
                try db.collection("Advertises").document(advertise.advertiseID!).setData(from: advertise)
                return true;
            } catch _ {
                return false;
            }
        
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
    
    
    func GetAllAdvertiseDetailByCompanyId(companyId: String) async throws -> [AdvertiseDetail] {
        var advertiseDetailList = try await self.GetAllAdvertiseDetail()
        var filteredAdvertiseDetailList : [AdvertiseDetail] = []
        
        for advertisDetail in advertiseDetailList{
            if companyId == advertisDetail.advertise?.companyID{
                filteredAdvertiseDetailList.append(advertisDetail)
            }
        }
        
        return filteredAdvertiseDetailList;
        
    }
    
}
