//
//  JobService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation
import Firebase

class JobService : JobProtocol{
    
    
    let db = Firestore.firestore()
    
    
    func GetJobDetailByJobId(jobId: String) async throws -> JobDetail {
        
        var jobDetailList = try await self.GetAllJobDetails()
        for jobDetail in jobDetailList{
            if jobDetail.job?.jobID == jobId{
                return jobDetail
            }
        }
        
        return JobDetail()
    }
    
    
    func GetAllJobDetails() async throws -> [JobDetail] {
        
        let jobList = try await self.GetAllJobs()
        let sectorList = try await SectorService().GetAllSectors()
        var jobDetailList : [JobDetail] = []
        
        for job in jobList {
            for sector in sectorList{
                if(job.sectorID == sector.sectorID){
                    var newJobDetail = JobDetail()
                    newJobDetail.job = job;
                    newJobDetail.sector = sector;
                    jobDetailList.append(newJobDetail);
                }
            }
        }
        
        return jobDetailList;
    }
    
    
    func GetAllJobs() async throws -> [Job] {
        
        var jobs : [Job] = []

        let query = db.collection("Jobs")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let job = try document.data(as: Job.self)
                jobs.append(job);
            } catch {
            }
        }
        
        return jobs;
    }
    
    func GetJobByJobId(jobId: String) async throws -> Job {
        
        let documentRef = db.collection("Jobs").document(jobId)
        
        let documentSnapshot = try await documentRef.getDocument()
        
        do {
            let job = try documentSnapshot.data(as: Job.self)
            return job
            
        }
        catch{
            return Job()
        }

    }
    
    
}
