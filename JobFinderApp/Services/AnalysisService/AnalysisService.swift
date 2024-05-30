//
//  AnalysisService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 30.05.2024.
//

import Foundation
import Firebase

class AnalysisService : AnalysisProtocol{
    
    let db = Firestore.firestore()
    
    func getPopularSectors()  async throws -> [PopularSector] {
        var newPopularSectorList : [PopularSector] = []
        let allSectors = try await SectorService().GetAllSectors()
        let allJobApplicatons = try await JobApplicationService().GetAllJobApplicationDetails();
        let allAdvertises = try await AdvertiseService().GetAllAdvertiseDetail();
        
        for sector in allSectors {
            var newPopularSector = PopularSector();
            newPopularSector.Sector = sector
            newPopularSector.totalJobAdvertisements = allAdvertises.filter({$0.jobDetail?.sector?.sectorID == sector.sectorID}).count
            newPopularSector.totalJobApplications = allJobApplicatons.filter({$0.advertiseDetail?.jobDetail?.sector?.sectorID == sector.sectorID}).count
            newPopularSectorList.append(newPopularSector)
        }
        return newPopularSectorList;
    }
    
    func getPopularJobs()  async throws -> [PopularJob] {
        var newPopularJobList : [PopularJob] = []
        let allJobDetails = try await JobService().GetAllJobDetails()
        let allJobApplicatons = try await JobApplicationService().GetAllJobApplicationDetails();
        let allAdvertises = try await AdvertiseService().GetAllAdvertiseDetail();
        
        for jobDetail in allJobDetails {
            var newPopularJob = PopularJob()
            newPopularJob.job = jobDetail;
            newPopularJob.totalJobAdvertisements = allAdvertises.filter({$0.advertise?.jobId == jobDetail.job?.jobID}).count
            newPopularJob.totalJobApplications = allJobApplicatons.filter({$0.advertiseDetail?.jobDetail?.job?.jobID == jobDetail.job?.jobID}).count
            newPopularJobList.append(newPopularJob)
        }
        
        return newPopularJobList
    }
    
    func getAverageSalariesBySector()  async throws -> [AverageSalaryBySector] {
        var newAverageSalaryBySectorList :  [AverageSalaryBySector] = [];
        var companyList = try await AuthService().GetAllCompanyDetails()
        var sectorList = try await SectorService().GetAllSectors()
        var totalPrice = 0
        
        for sector in sectorList{
            var newAverageSalaryBySector = AverageSalaryBySector()
            totalPrice = 0
            
            newAverageSalaryBySector.sector = sector
            var filteredList = companyList.filter({$0.sector?.sectorID == sector.sectorID})
            if filteredList.count > 0{
                for salary in filteredList{
                    switch salary.company?.avarageSalary {
                    case .veryLow:
                        totalPrice += 17000
                    case .low:
                        totalPrice += 25000
                    case .medium:
                        totalPrice += 40000
                    case .high:
                        totalPrice += 75000
                    case .veryHigh:
                        totalPrice += 125000
                    default:
                        totalPrice += 0
                        
                        
                    }
                }
                
                newAverageSalaryBySector.averageSalary = Double(totalPrice / filteredList.count)
                newAverageSalaryBySectorList.append(newAverageSalaryBySector)
            }
            
        }
        
        return newAverageSalaryBySectorList
    }
    
    
    func getActiveCompanies()  async throws -> [ActiveCompany]{
        var newActiveCompanies :  [ActiveCompany] = [];
        var allCompanies = try await AuthService().GetAllCompanyDetails()
        var allAdvertiseList = try await AdvertiseService().GetAllAdvertiseDetail()
        
        for companyDetail in allCompanies {
            var newActiveCompany = ActiveCompany()
            newActiveCompany.companyDetail = companyDetail
            newActiveCompany.totalJobAdvertisements = allAdvertiseList.filter({$0.companyDetail?.company?.companyID == companyDetail.company?.companyID}).count
            newActiveCompanies.append(newActiveCompany)
        }
        return newActiveCompanies
    }
    
    
    
    
}
