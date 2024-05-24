//
//  JobService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 11.05.2024.
//

import Foundation
import Firebase

class JobService : JobProtocol{
    
    func GetAllJobDetails() async throws -> [JobDetail] {
        let jobList = try await self.GetAllJobs()
        let sectorList = try await SectorService().GetAllSectors()
        var jobDetailList : [JobDetail] = []
        
        for job in jobList {
            for sector in sectorList{
                if(job.sectorId == sector.sectorId){
                    var newJobDetail = JobDetail()
                    newJobDetail.job = job;
                    newJobDetail.sector = sector;
                    jobDetailList.append(newJobDetail);
                }
            }
        }
        
        return jobDetailList;
    }
    
    
    let db = Firestore.firestore()
    var jobs : [Job] = []
    
    func GetAllJobs() async throws -> [Job] {
        let query = db.collection("Jobs")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let job = try document.data(as: Job.self)
                self.jobs.append(job);
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
