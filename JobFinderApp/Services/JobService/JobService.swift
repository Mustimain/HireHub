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
        
        let query = db.collection("Jobs").whereField("jobId", isEqualTo: jobId)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let job = try document.data(as: Job.self)
                return job;
            } catch {
            }
        }
        
        return Job();

    }
    
    
}
