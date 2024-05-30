//
//  AnalysisProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 30.05.2024.
//

import Foundation


protocol AnalysisProtocol {
    
    // En popüler sektörleri ve başvuru oranlarını al En popüler 5 sektör
    func getPopularSectors()  async throws -> [PopularSector]
    
    // En popüler meslekleri ve başvuru oranlarını al En popüler 10 meslek
    func getPopularJobs()  async throws -> [PopularJob]

    // Ortalama maaşları sektöre göre al
    func getAverageSalariesBySector()  async throws -> [AverageSalaryBySector]
        
    // En aktif şirketleri al Şirketlerin en çok ilanı bulunana ve başvuru alana göre göre sırala
    func getActiveCompanies()  async throws -> [ActiveCompany]


    
}
