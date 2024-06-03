//
//  AuthService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import Foundation
import Firebase
import FirebaseStorage


class AuthService : AuthProtocol {

   
      
    let db = Firestore.firestore()
    

    func UserRegister(user: User) async throws -> Bool {
        if (user.userID?.count ?? 0 > 0){
            do {
                try db.collection("Users").document(user.userID ?? "").setData(from: user)
                return true;
            } catch _ {
                return false;
                
            }
        }
        
        return false;
    }
    
    func UserLogin(email: String, password: String) async throws -> Bool {
        
        let query = db.collection("Users").whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let user = try document.data(as: User.self)
                if(user.email == email && user.password == password){
                    return true;
                }
            } catch {
                return false;
            }
        }
        
        return false;
    }
    
    func CompanyRegister(company: Company) async throws -> Bool {
        
        if (company.companyID?.count ?? 0 > 0){
            do {
                try db.collection("Companies").document(company.companyID!).setData(from: company)
                var updateCompany = company
                updateCompany.avarageSalary = company.avarageSalary
                updateCompany.employeeSize = company.employeeSize
                try await self.UpdateCompany(company: updateCompany)
                return true;
            } catch _ {
                return false;
            }
        }
        
        return false;
        
    }
    
    func CompanyLogin(email: String, password: String) async throws -> Bool {
        
        let query = db.collection("Companies").whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let company = try document.data(as: Company.self)
                if(company.email == email && company.password == password){
                    return true;
                }
            } catch {
                return false;
            }
        }
        
        return false
    }
    
    func GetUserByEmail(email: String) async throws -> User {
        
        let query = db.collection("Users").whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let user = try document.data(as: User.self)
                if(user.email == email){
                    return user;
                }
            } catch {
            }
        }
        
        return User();
    }
    
    
    func GetCompanyByEmail(email: String) async throws -> Company {
        
        let query = db.collection("Companies").whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let company = try document.data(as: Company.self)
                if(company.email == email){
                    return company;
                }
            } catch {
            }
        }
        
        return Company();
    }
    
    func GetAllCompanies() async throws -> [Company] {
        
        var companyList : [Company] = []
        let query = db.collection("Companies")
        let querySnapshot = try await query.getDocuments()
        
        for document in querySnapshot.documents {
            do {
                let company = try document.data(as: Company.self)
                companyList.append(company);
            } catch {
            }
        }
        
        return companyList;
    }
    
    func UpdateCompany(company: Company) async throws -> Bool {
        
        guard let companyID = company.companyID, companyID.count > 0 else {
               return false
           }
           
           do {
               // Kullanıcıyı veritabanında güncelle
               try db.collection("Companies").document(companyID).setData(from: company)
               return true
           } catch {
               // Hata durumunda false döner
               return false
           }
    }
    
    func UpdateUser(user: User) async throws -> Bool {
        
        guard let userID = user.userID, userID.count > 0 else {
               return false
           }
           
           do {
               // Kullanıcıyı veritabanında güncelle
               try db.collection("Users").document(userID).setData(from: user)
               return true
           } catch {
               // Hata durumunda false döner
               return false
           }
    }

    func GetCompanyDetailByEmail(email: String) async throws -> CompanyDetail {
        var newCompanyDetail = CompanyDetail()
        let company = try await self.GetCompanyByEmail(email: email)
        let sector = try await SectorService().GetSectorBySectorId(sectorId: company.sectorID!)
        newCompanyDetail.company = company
        newCompanyDetail.sector = sector
        return newCompanyDetail;
        
    }
    
    func GetAllCompanyDetails() async throws -> [CompanyDetail] {
        var companyDetailList : [CompanyDetail] = []
        let companyList = try await self.GetAllCompanies()
        let sectorList = try await SectorService().GetAllSectors()
        
        for company in companyList{
            for sector in sectorList{
                if sector.sectorID == company.sectorID{
                    var newCompanyDetail = CompanyDetail()
                    newCompanyDetail.company = company
                    newCompanyDetail.sector = sector
                    companyDetailList.append(newCompanyDetail)
                }
            }
        }
        
        return companyDetailList
    }
    
    func GetUserDetailByEmail(email: String) async throws -> UserDetail {
        var newUserDetail = UserDetail()
        let user = try await self.GetUserByEmail(email: email)
        let jobDetail = try await JobService().GetJobDetailByJobId(jobId: user.jobID!)
        newUserDetail.user = user;
        newUserDetail.jobDetail = jobDetail;
        
        return newUserDetail;
    }
    
    func GetUserById(userId: String) async throws -> User {
        let db = Firestore.firestore()
        let document = try await db.collection("Users").document(userId).getDocument()
        
        if document.exists {
            do {
                let user = try document.data(as: User.self)
                return user
            } catch {
                return User()
            }
        } else {
            return User()
        }
    }
    
    func GetUserDetailById(userId: String) async throws -> UserDetail {
        var newUserDetail = UserDetail()
        let user = try await self.GetUserById(userId: userId)
        let jobDetail = try await JobService().GetJobDetailByJobId(jobId: user.jobID!)
        newUserDetail.user = user;
        newUserDetail.jobDetail = jobDetail;
        
        return newUserDetail;
    }
    
 
    func SaveUserResume(fileURL: URL, fileName: String) async throws -> Bool {
        do {
            
            let storageRef = Storage.storage().reference()
            let pdfRef = storageRef.child("Resumes/\(fileName)")
            
            pdfRef.putFile(from: fileURL)
            return true
        }catch{
            return false;
        }
    }
    

    
    func UpdateUserResume(fileURL: URL, fileName: String) async throws -> Bool {
        do {
            let storageRef = Storage.storage().reference()
            let pdfRef = storageRef.child("Resumes/\(fileName)")
            try await pdfRef.delete()
            
            pdfRef.putFile(from: fileURL)

            return true
           } catch {
               return false
           }
    }
    
    func GetResumeURL(fileName: String) async throws -> URL {
        var newURL : URL = URL(fileURLWithPath: "")
        do {
                let storageRef = Storage.storage().reference()
                let pdfRef = storageRef.child("Resumes/\(fileName)")
                
                // Dosya URL'sini al
                let url = try await pdfRef.downloadURL()
                newURL = url
                return url
            } catch {
                
            }
        
        return newURL
    }
    

    func CheckUserEmailIsExist(email: String) async throws -> Bool {
        var user = try await self.GetUserByEmail(email: email)
        if user.firstName?.count ?? 0 > 0 {
            return true
        }else{
            return false
        }
    }
    
    func CheckCompanyEmailIsExist(email: String) async throws -> Bool {
        var company = try await self.GetCompanyByEmail(email: email)
        if company.name?.count ?? 0 > 0 {
            return true

        }else{
            return false

        }
    }
    
    
}
