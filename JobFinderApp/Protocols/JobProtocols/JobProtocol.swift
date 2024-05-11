//
//  JobProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation

protocol JobProtocol {
    
    func GetAllJobs() async throws -> [Job]
    func GetJobByJobId(jobId : String) async throws -> Job
    func GetAllJobDetails() async throws -> [JobDetail]

   // func GetAllJobDetails(jobId : String) async throws -> Job

}
