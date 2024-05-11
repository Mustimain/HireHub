//
//  SectorProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation

protocol SectorProtocol {
    
    func GetAllSectors() async throws -> [Sector]
    func GetSectorBySectorId(sectorId : String) async throws -> Sector
}
