//
//  JobApplicationService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 25.05.2024.
//

import Foundation
import Firebase

class JobApplicationService : JobApplicationProtocol{

  
    
    let db = Firestore.firestore()

    
    func AddJobApplication(jobApplication: JobApplication) async throws -> Bool {
        guard let jobApplicationID = jobApplication.jobApplicationID, !jobApplicationID.isEmpty else {
                return false
            }
            do {
                try db.collection("JobApplications").document(jobApplication.jobApplicationID!).setData(from: jobApplication)
                return true;
            } catch _ {
                return false;
            }
    }
    

    
    func GetAllJobApplications() async throws -> [JobApplication] {
        var jobApplicationList : [JobApplication] = []
        let query = db.collection("JobApplications")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let jobApplication = try document.data(as: JobApplication.self)
                jobApplicationList.append(jobApplication);
            } catch {
            }
        }
        
        return jobApplicationList;
    }
    
    
    func GetAllJobApplicationDetails() async throws -> [JobApplicationDetail] {
        
        var jobApplicationDetailList : [JobApplicationDetail] = []
        var jobApplicationList = try await self.GetAllJobApplications()
        
        for jobApplication in jobApplicationList{
            var newJobApplicationDetail = JobApplicationDetail();
            var advertiseDetail = try await AdvertiseService().GetAdvertiseDetailById(advertiseId: jobApplication.advertiseID!)
            var userDetail = try await AuthService().GetUserDetailById(userId: jobApplication.userID!)
            newJobApplicationDetail.jobApplication = jobApplication;
            newJobApplicationDetail.userDetail = userDetail;
            newJobApplicationDetail.advertiseDetail = advertiseDetail;
        
            jobApplicationDetailList.append(newJobApplicationDetail)
        }
        
        return jobApplicationDetailList;
        
    }
    
    
    
    func GetJobApplicationById(jobApplicationID: String) async throws -> JobApplication {
        let db = Firestore.firestore()
        let document = try await db.collection("JobApplications").document(jobApplicationID).getDocument()

        if document.exists {
            do {
                let jobApplication = try document.data(as: JobApplication.self)
                return jobApplication
            } catch {
                throw error
            }
        } else {
            return JobApplication()
        }
    }
    
    
    func GetJobApplicationDetailById(jobApplicationID: String) async throws -> JobApplicationDetail {
        var newJobApplicationDetail = JobApplicationDetail();
        var jobApplication = try await  self.GetJobApplicationById(jobApplicationID: jobApplicationID)
        var userDetail = try await AuthService().GetUserDetailById(userId: jobApplication.userID!)
        var advertiseDetail = try await AdvertiseService().GetAdvertiseDetailById(advertiseId: jobApplication.advertiseID!)
        newJobApplicationDetail.advertiseDetail = advertiseDetail
        newJobApplicationDetail.userDetail = userDetail
        newJobApplicationDetail.jobApplication = jobApplication
        
        return newJobApplicationDetail;
    }
    
    func CheckApplicationIsExist(userId: String, advertiseId: String) async throws -> Bool {
        var allJobApplications = try await self.GetAllJobApplications()
        for jobApplication in allJobApplications {
            if jobApplication.advertiseID == advertiseId && jobApplication.userID == userId{
                return false
            }
        }
        
        return true
    }
    
    func GetAllJobApplicationDetailsByUserId(userId: String) async throws -> [JobApplicationDetail] {
        var jobApplicationDetailList  = try await self.GetAllJobApplicationDetails()
        var filteredList = jobApplicationDetailList.filter({$0.jobApplication?.userID == userId});
        
        return filteredList;
    }
    
    
}
