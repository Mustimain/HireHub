//
//  JobApplicationProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 25.05.2024.
//

import Foundation

protocol JobApplicationProtocol{
    func AddJobApplication(jobApplication : JobApplication) async throws -> Bool
    func ChangeJobApplicationStatus(jobApplication : JobApplication) async throws -> Bool

    func GetAllJobApplications() async throws -> [JobApplication]
    func GetAllJobApplicationDetails() async throws -> [JobApplicationDetail]
    func GetJobApplicationById(jobApplicationID : String) async throws -> JobApplication
    func GetJobApplicationDetailById(jobApplicationID : String) async throws -> JobApplicationDetail
    func CheckApplicationIsExist(userId : String,advertiseId : String) async throws -> Bool
    func GetAllJobApplicationDetailsByUserId(userId : String) async throws -> [JobApplicationDetail]
    func GetAllJobApplicationDetailsByCompanyId(companyId : String) async throws -> [JobApplicationDetail]

}
