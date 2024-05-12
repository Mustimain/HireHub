//
//  AdvertiseProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 8.05.2024.
//

import Foundation

protocol AdvertiseProtocol {
    
    func AddAdvertise(advertise: Advertise) async throws -> Bool
    func GetAllAdvertises() async throws -> [Advertise]
    func GetAllAdvertiseDetail() async throws -> [AdvertiseDeteail]
    func GetAllAdvertiseByCompanyId(companyId : String) async throws -> [Advertise]

}
