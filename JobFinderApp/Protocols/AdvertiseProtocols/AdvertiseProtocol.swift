//
//  AdvertiseProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 8.05.2024.
//

import Foundation

protocol AdvertiseProtocol {
    
    func AddAdvertise(advertise: Advertise) async throws -> Bool
    func GetAllAdvertiseBySector(sectorId : String) async throws -> Bool
}
