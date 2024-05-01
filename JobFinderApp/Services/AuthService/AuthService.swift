//
//  AuthService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 1.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCore


class AuthService : AuthProtocol {
    
    let db = Firestore.firestore()
    
    func UserRegister(user: User) async throws -> Bool {
        if (user.userID?.count ?? 0 > 0){
            do {
                try db.collection("Users").document(user.userID ?? "").setData(from: user)
                return true;
            } catch let error {
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
        
        // 3. Return the fetched users
        return false;
    }
    
    func CompanyRegister(company: Company) async throws -> Bool {
        
        if (company.companyID?.count ?? 0 > 0){
            do {
                try db.collection("Companies").document(company.companyID ?? "").setData(from: company)
                return true;
            } catch let error {
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
    
}
