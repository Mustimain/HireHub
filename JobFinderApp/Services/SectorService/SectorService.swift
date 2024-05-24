//
//  SectorService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation
import Firebase

class SectorService : SectorProtocol{
    
    let db = Firestore.firestore()
    var sectors : [Sector] = []
    
    func GetAllSectors() async throws -> [Sector] {
        
        let query = db.collection("Sectors")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let sector = try document.data(as: Sector.self)
                self.sectors.append(sector);
            } catch {
            }
        }
        
        return sectors;
    }
    
    func GetSectorBySectorId(sectorId: String) async throws -> Sector {
        
        let documentRef = db.collection("Sectors").document(sectorId)
        
        let documentSnapshot = try await documentRef.getDocument()
        
        do {
            let sector = try documentSnapshot.data(as: Sector.self)
            return sector
            
        }
        catch{
            return Sector()
        }
        
    }
}
    
    

