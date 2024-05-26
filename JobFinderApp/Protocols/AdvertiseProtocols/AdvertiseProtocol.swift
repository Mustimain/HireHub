//
//  AdvertiseProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 8.05.2024.
//

import Foundation

protocol AdvertiseProtocol {
    
    func AddAdvertise(advertise: Advertise) async throws -> Bool
    func UpdateAdvertise(advertise: Advertise) async throws -> Bool

    func GetAllAdvertises() async throws -> [Advertise]
    func GetAllAdvertiseDetail() async throws -> [AdvertiseDetail]
    func GetAllAdvertiseDetailByCompanyId(companyId : String) async throws -> [AdvertiseDetail]
    func GetAllAdvertiseByCompanyId(companyId : String) async throws -> [Advertise]
    func GetAdvertiseDetailById(advertiseId : String) async throws -> AdvertiseDetail

}
